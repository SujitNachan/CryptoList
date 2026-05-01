import Foundation

// MARK: - Domain Model

struct Coin: Identifiable, Equatable, Hashable {
    let id: String          // "name" field used as stable ID
    let name: String
    let symbol: String
    let type: CoinType
    let isActive: Bool
    let isNew: Bool
    var isWatched: Bool
}

// MARK: - Coin Type

enum CoinType: String, CaseIterable, Hashable {
    case coin  = "coin"
    case token = "token"

    var displayName: String {
        rawValue.capitalized
    }
}

// MARK: - Filter Options

struct CoinFilter: Equatable {
    var showActive: Bool?       // nil = all, true = active only, false = inactive only
    var types: Set<CoinType>    // empty = all types
    var showNewOnly: Bool

    static let `default` = CoinFilter(showActive: nil, types: [], showNewOnly: false)

    var isDefault: Bool {
        showActive == nil && types.isEmpty && !showNewOnly
    }
}
