import SwiftData

@available(iOS 17, *)
@Model
final class CoinEntity {
    @Attribute(.unique) var name: String
    var symbol: String
    var type: String
    var isActive: Bool
    var isNew: Bool

    init(name: String, symbol: String, type: String, isActive: Bool, isNew: Bool) {
        self.name = name
        self.symbol = symbol
        self.type = type
        self.isActive = isActive
        self.isNew = isNew
    }
}

@available(iOS 17, *)
@Model
final class WatchedCoinEntity {
    @Attribute(.unique) var coinID: String

    init(coinID: String) {
        self.coinID = coinID
    }
}

@available(iOS 17, *)
@Model
final class MetadataEntity {
    @Attribute(.unique) var key: String
    var value: Double   // store Date as timeIntervalSince1970

    init(key: String, value: Double) {
        self.key = key
        self.value = value
    }
}
