import Foundation

/// Central dependency container — wire everything here so call-sites stay clean.
@available(iOS 17, *)
final class AppDependencyContainer {

    // MARK: - Shared singletons

    private lazy var apiClient: APIClientProtocol = APIClient()
    private lazy var databaseService: DatabaseServiceProtocol = DatabaseService()

    // MARK: - Data layer

    private lazy var coinRepository: CoinRepositoryProtocol = CoinRepository(
        apiClient: apiClient,
        databaseService: databaseService
    )

    // MARK: - Domain layer

    private lazy var fetchCoinsUseCase: FetchCoinsUseCaseProtocol =
        FetchCoinsUseCase(repository: coinRepository)

    private lazy var toggleWatchlistUseCase: ToggleWatchlistUseCaseProtocol =
        ToggleWatchlistUseCase(repository: coinRepository)

    private lazy var fetchWatchlistUseCase: FetchWatchlistUseCaseProtocol =
        FetchWatchlistUseCase(repository: coinRepository)

    // MARK: - Presentation layer

    @MainActor func makeCoinListViewModel() -> CoinListViewModel {
        CoinListViewModel(
            fetchCoinsUseCase: fetchCoinsUseCase,
            toggleWatchlistUseCase: toggleWatchlistUseCase,
            fetchWatchlistUseCase: fetchWatchlistUseCase
        )
    }
}
