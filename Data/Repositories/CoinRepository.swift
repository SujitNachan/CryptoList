import Foundation
import Combine

protocol CoinRepositoryProtocol {
    /// Emits the full coin list. First emission comes from cache (if any),
    /// then from the network. The publisher never completes.
    var coinsPublisher: AnyPublisher<[Coin], Never> { get }

    /// Indicates whether a background network refresh is in-flight.
    var isRefreshingPublisher: AnyPublisher<Bool, Never> { get }

    /// Human-readable last-update label, e.g. "Last updated 2 min ago" or "Offline".
    var lastUpdatedPublisher: AnyPublisher<String?, Never> { get }

    /// Trigger a manual network refresh.
    func refresh() async

    /// Toggle watched state for a coin (optimistic update + persistence).
    func toggleWatchlist(coinID: String) async
}

final class CoinRepository: CoinRepositoryProtocol {

    // MARK: - Dependencies

    private let apiClient: APIClientProtocol
    private let databaseService: DatabaseServiceProtocol

    // MARK: - Publishers (backing subjects)

    private let coinsSubject        = CurrentValueSubject<[Coin], Never>([])
    private let isRefreshingSubject = CurrentValueSubject<Bool, Never>(false)
    private let lastUpdatedSubject  = CurrentValueSubject<String?, Never>(nil)

    // MARK: - Internal state

    private var watchedIDs: Set<String>
    private var refreshTask: Task<Void, Never>?
    private var lastFetchDate: Date?

    // MARK: - Init

    init(apiClient: APIClientProtocol, databaseService: DatabaseServiceProtocol) {
        self.apiClient       = apiClient
        self.databaseService = databaseService
        self.watchedIDs      = databaseService.loadWatchedIDs()
        self.lastFetchDate   = databaseService.loadLastFetchDate()

        loadCacheAndRefresh()
    }

    // MARK: - CoinRepositoryProtocol

    var coinsPublisher: AnyPublisher<[Coin], Never> {
        coinsSubject.eraseToAnyPublisher()
    }

    var isRefreshingPublisher: AnyPublisher<Bool, Never> {
        isRefreshingSubject.eraseToAnyPublisher()
    }

    var lastUpdatedPublisher: AnyPublisher<String?, Never> {
        lastUpdatedSubject.eraseToAnyPublisher()
    }

    func refresh() async {
        await performNetworkRefresh()
    }

    func toggleWatchlist(coinID: String) async {
        // 1. Optimistic UI update
        if watchedIDs.contains(coinID) {
            watchedIDs.remove(coinID)
        } else {
            watchedIDs.insert(coinID)
        }

        // 2. Reflect change in published coins immediately
        let updated = coinsSubject.value.map { coin -> Coin in
            var c = coin
            if c.id == coinID { c.isWatched = watchedIDs.contains(coinID) }
            return c
        }
        coinsSubject.send(updated)

        // 3. Persist before the app can be suspended
        databaseService.saveWatchedIDs(watchedIDs)
    }

    // MARK: - Private helpers

    private func loadCacheAndRefresh() {
        // Show cached data immediately (no blocking spinner).
        if let cached = databaseService.loadCoins() {
            let coins = cached.map { $0.toDomain(isWatched: watchedIDs.contains($0.name)) }
            coinsSubject.send(coins)
            updateLastUpdatedLabel()
        }

        // Background refresh.
        Task { await performNetworkRefresh() }
    }

    private func performNetworkRefresh() async {
        guard !isRefreshingSubject.value else { return }
        isRefreshingSubject.send(true)
        defer { isRefreshingSubject.send(false) }

        do {
            let dtos = try await apiClient.fetchCoins()
            databaseService.saveCoins(dtos)

            let now = Date()
            databaseService.saveLastFetchDate(now)
            lastFetchDate = now

            let coins = dtos.map { $0.toDomain(isWatched: watchedIDs.contains($0.name)) }
            coinsSubject.send(coins)
            updateLastUpdatedLabel()
        } catch {
            // Network failed — show stale label.
            if coinsSubject.value.isEmpty {
                lastUpdatedSubject.send("Offline")
            } else {
                updateLastUpdatedLabel(offline: true)
            }
        }
    }

    private func updateLastUpdatedLabel(offline: Bool = false) {
        guard let date = lastFetchDate else {
            lastUpdatedSubject.send(offline ? "Offline" : nil)
            return
        }

        let elapsed = Date().timeIntervalSince(date)
        let label: String
        switch elapsed {
        case ..<60:
            label = "Last updated just now"
        case ..<3600:
            let mins = Int(elapsed / 60)
            label = "Last updated \(mins) min ago"
        default:
            let hrs = Int(elapsed / 3600)
            label = "Last updated \(hrs)h ago"
        }
        lastUpdatedSubject.send(offline ? "\(label) · Offline" : label)
    }
}
