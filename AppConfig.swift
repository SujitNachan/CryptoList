import Foundation

enum AppConfig {
    static var baseURL: String {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String else {
            fatalError("BaseURL not found in Info.plist")
        }
        return "https://\(urlString)"
    }
}
