import Foundation
import Combine

// MARK: - Fetch Coins Use Case

protocol FetchCoinsUseCaseProtocol {
    var coinsPublisher: AnyPublisher<[Coin], Never> { get }
    var isRefreshingPublisher: AnyPublisher<Bool, Never> { get }
    var lastUpdatedPublisher: AnyPublisher<String?, Never> { get }
    func refresh() async
}

final class FetchCoinsUseCase: FetchCoinsUseCaseProtocol {
    private let repository: CoinRepositoryProtocol

    init(repository: CoinRepositoryProtocol) {
        self.repository = repository
    }

    var coinsPublisher: AnyPublisher<[Coin], Never> { repository.coinsPublisher }
    var isRefreshingPublisher: AnyPublisher<Bool, Never> { repository.isRefreshingPublisher }
    var lastUpdatedPublisher: AnyPublisher<String?, Never> { repository.lastUpdatedPublisher }

    func refresh() async { await repository.refresh() }
}

// MARK: - Toggle Watchlist Use Case

protocol ToggleWatchlistUseCaseProtocol {
    func execute(coinID: String) async
}

final class ToggleWatchlistUseCase: ToggleWatchlistUseCaseProtocol {
    private let repository: CoinRepositoryProtocol

    init(repository: CoinRepositoryProtocol) {
        self.repository = repository
    }

    func execute(coinID: String) async {
        await repository.toggleWatchlist(coinID: coinID)
    }
}

// MARK: - Fetch Watchlist Use Case

protocol FetchWatchlistUseCaseProtocol {
    var watchedCoinsPublisher: AnyPublisher<[Coin], Never> { get }
}

final class FetchWatchlistUseCase: FetchWatchlistUseCaseProtocol {
    private let repository: CoinRepositoryProtocol

    init(repository: CoinRepositoryProtocol) {
        self.repository = repository
    }

    var watchedCoinsPublisher: AnyPublisher<[Coin], Never> {
        repository.coinsPublisher
            .map { $0.filter(\.isWatched) }
            .eraseToAnyPublisher()
    }
}
