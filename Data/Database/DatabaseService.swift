import Foundation
import SwiftData

// MARK: - Protocol

protocol DatabaseServiceProtocol {
    /// Persist the full coin list (as raw DTOs).
    func saveCoins(_ coins: [CoinDTO])

    /// Load the persisted coin list. Returns nil if cache is empty.
    func loadCoins() -> [CoinDTO]?

    /// Return the set of coin IDs that are watched.
    func loadWatchedIDs() -> Set<String>

    /// Persist the watched-ID set immediately.
    func saveWatchedIDs(_ ids: Set<String>)

    /// Timestamp of the last successful network fetch.
    func loadLastFetchDate() -> Date?
    func saveLastFetchDate(_ date: Date)
}

@available(iOS 17, *)
final class DatabaseService: DatabaseServiceProtocol {

    private let container: ModelContainer
    private var context: ModelContext

    init() {
        let schema = Schema([CoinEntity.self, WatchedCoinEntity.self, MetadataEntity.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            container = try ModelContainer(for: schema, configurations: config)
            context = ModelContext(container)
            context.autosaveEnabled = false
        } catch {
            fatalError("SwiftData init failed: \(error)")
        }
    }

    // MARK: - Coins

    func saveCoins(_ coins: [CoinDTO]) {
        // Delete old entries
        try? context.delete(model: CoinEntity.self)

        for dto in coins {
            let entity = CoinEntity(
                name: dto.name,
                symbol: dto.symbol,
                type: dto.type,
                isActive: dto.isActive,
                isNew: dto.isNew
            )
            context.insert(entity)
        }
        try? context.save()
    }

    func loadCoins() -> [CoinDTO]? {
        let entities = (try? context.fetch(FetchDescriptor<CoinEntity>())) ?? []
        guard !entities.isEmpty else { return nil }
        return entities.map {
            CoinDTO(name: $0.name, symbol: $0.symbol, type: $0.type,
                    isActive: $0.isActive, isNew: $0.isNew)
        }
    }

    // MARK: - Watchlist

    func loadWatchedIDs() -> Set<String> {
        let entities = (try? context.fetch(FetchDescriptor<WatchedCoinEntity>())) ?? []
        return Set(entities.map(\.coinID))
    }

    func saveWatchedIDs(_ ids: Set<String>) {
        try? context.delete(model: WatchedCoinEntity.self)
        for id in ids { context.insert(WatchedCoinEntity(coinID: id)) }
        try? context.save()
    }

    // MARK: - Last fetch date

    func loadLastFetchDate() -> Date? {
        let descriptor = FetchDescriptor<MetadataEntity>(
            predicate: #Predicate { $0.key == "lastFetch" }
        )
        guard let entity = try? context.fetch(descriptor).first else { return nil }
        return Date(timeIntervalSince1970: entity.value)
    }

    func saveLastFetchDate(_ date: Date) {
        let descriptor = FetchDescriptor<MetadataEntity>(
            predicate: #Predicate { $0.key == "lastFetch" }
        )
        if let entity = try? context.fetch(descriptor).first {
            entity.value = date.timeIntervalSince1970
        } else {
            context.insert(MetadataEntity(key: "lastFetch", value: date.timeIntervalSince1970))
        }
        try? context.save()
    }
}
