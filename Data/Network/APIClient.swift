import Foundation

// MARK: - Protocol

protocol APIClientProtocol {
    func fetchCoins() async throws -> [CoinDTO]
}

// MARK: - Errors

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case decodingFailed(underlying: Error)
    case networkUnavailable

    var errorDescription: String? {
        switch self {
        case .invalidURL:               return "Invalid API URL."
        case .invalidResponse(let c):   return "Server returned status \(c)."
        case .decodingFailed(let e):    return "Decoding error: \(e.localizedDescription)"
        case .networkUnavailable:       return "Network unavailable."
        }
    }
}

// MARK: - Implementation

final class APIClient: APIClientProtocol {

    private let session: URLSession
    private let baseURL = "https://api.jsonbin.io/v3/b/69f046e8856a6821897f1741"

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchCoins() async throws -> [CoinDTO] {
        guard let url = URL(string: baseURL) else { throw APIError.invalidURL }

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(from: url)
        } catch {
            throw APIError.networkUnavailable
        }

        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw APIError.invalidResponse(statusCode: http.statusCode)
        }

        do {
            // The jsonbin wrapper: { "record": [...], "metadata": {...} }
            let wrapper = try JSONDecoder().decode(JSONBinResponse.self, from: data)
            return wrapper.record
        } catch {
            throw APIError.decodingFailed(underlying: error)
        }
    }
}

// MARK: - DTOs

struct JSONBinResponse: Decodable {
    let record: [CoinDTO]
}

struct CoinDTO: Decodable {
    let name: String
    let symbol: String
    let type: String
    let isActive: Bool
    let isNew: Bool

    enum CodingKeys: String, CodingKey {
        case name, symbol, type
        case isActive = "is_active"
        case isNew    = "is_new"
    }

    func toDomain(isWatched: Bool = false) -> Coin {
        Coin(
            id: name,
            name: name,
            symbol: symbol,
            type: CoinType(rawValue: type.lowercased()) ?? .coin,
            isActive: isActive,
            isNew: isNew,
            isWatched: isWatched
        )
    }
}
