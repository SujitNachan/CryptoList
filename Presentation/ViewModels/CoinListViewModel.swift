import Foundation
import Combine

// MARK: - Tab

enum CoinTab: String, CaseIterable {
    case all       =  "All Coins"
    case watchlist = "Watchlist"
}

// MARK: - ViewModel

@MainActor
final class CoinListViewModel: ObservableObject {

    // MARK: Published state

    @Published var allCoins: [Coin]     = []
    @Published var watchedCoins: [Coin] = []

    @Published var searchText: String   = ""
    @Published var filter: CoinFilter   = .default
    @Published var selectedTab: CoinTab = .all

    @Published var isRefreshing: Bool   = false
    @Published var lastUpdatedLabel: String? = nil

    // MARK: Computed filtered lists

    var filteredAllCoins: [Coin]     { apply(filter: filter, search: searchText, to: allCoins) }
    var filteredWatchlist: [Coin]    { apply(filter: filter, search: searchText, to: watchedCoins) }

    var activeFilterCount: Int {
        var count = 0
        if filter.showActive != nil    { count += 1 }
        if !filter.types.isEmpty       { count += filter.types.count }
        if filter.showNewOnly          { count += 1 }
        return count
    }

    // MARK: Dependencies

    private let fetchCoinsUseCase: FetchCoinsUseCaseProtocol
    private let toggleWatchlistUseCase: ToggleWatchlistUseCaseProtocol
    private let fetchWatchlistUseCase: FetchWatchlistUseCaseProtocol

    private var cancellables = Set<AnyCancellable>()

    // MARK: Init

    init(
        fetchCoinsUseCase: FetchCoinsUseCaseProtocol,
        toggleWatchlistUseCase: ToggleWatchlistUseCaseProtocol,
        fetchWatchlistUseCase: FetchWatchlistUseCaseProtocol
    ) {
        self.fetchCoinsUseCase      = fetchCoinsUseCase
        self.toggleWatchlistUseCase = toggleWatchlistUseCase
        self.fetchWatchlistUseCase  = fetchWatchlistUseCase

        bindPublishers()
    }

    // MARK: Public interface

    func onAppear() {
        Task { await fetchCoinsUseCase.refresh() }
    }

    func refresh() async {
        await fetchCoinsUseCase.refresh()
    }

    func toggleWatchlist(for coin: Coin) {
        Task { await toggleWatchlistUseCase.execute(coinID: coin.id) }
    }

    func resetFilters() {
        filter = .default
    }

    // MARK: - Private

    private func bindPublishers() {
        fetchCoinsUseCase.coinsPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$allCoins)

        fetchWatchlistUseCase.watchedCoinsPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$watchedCoins)

        fetchCoinsUseCase.isRefreshingPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$isRefreshing)

        fetchCoinsUseCase.lastUpdatedPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$lastUpdatedLabel)
    }

    // MARK: - Filtering logic

    private func apply(filter: CoinFilter, search: String, to coins: [Coin]) -> [Coin] {
        coins.filter { coin in
            // Search
            if !search.isEmpty {
                let q = search.lowercased()
                guard coin.name.lowercased().contains(q) ||
                      coin.symbol.lowercased().contains(q) else { return false }
            }
            // Active status
            if let active = filter.showActive, coin.isActive != active { return false }
            // Type
            if !filter.types.isEmpty, !filter.types.contains(coin.type) { return false }
            // New
            if filter.showNewOnly, !coin.isNew { return false }
            return true
        }
    }
}
