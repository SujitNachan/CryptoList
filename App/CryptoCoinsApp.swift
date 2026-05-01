import SwiftUI

@available(iOS 17, *)
@main
struct CryptoCoinsApp: App {

    private let container = AppDependencyContainer()

    var body: some Scene {
        WindowGroup {
            CoinListView(viewModel: container.makeCoinListViewModel())
        }
    }
}
