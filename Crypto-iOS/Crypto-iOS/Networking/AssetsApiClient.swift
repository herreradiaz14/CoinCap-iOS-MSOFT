import Dependencies
import Foundation
import XCTestDynamicOverlay

struct AssetsApiClient {
    var fetchAllAssets: () async throws -> [Asset]
}

enum NetworkinError: Error {
    case invalidURL
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        }
    }
}

extension AssetsApiClient: DependencyKey {
    static var liveValue: AssetsApiClient{
        .init(
            fetchAllAssets: {
                let urlSession = URLSession.shared
                let apiKey = "ffab4e2f346a6fc24e7537ce4e0495c81eea0cbf1a78a4d39fec59d0d2d0e92f"
                
                guard let url = URL(string: "https://rest.coincap.io/v3/assets?apiKey=\(apiKey)") else {
                    throw NetworkinError.invalidURL
                }
                
                let (data, _) = try await urlSession.data(for: URLRequest(url: url))
                let assetsResponse = try JSONDecoder().decode(AssetsResponse.self, from: data)
                return assetsResponse.data
            }
        )
    }
    
    // Para poder visualizar datos fijos y no tener que llamar a cada rato al API (cuendo estemos testeando)
    static var previewValue: AssetsApiClient{
        .init(
            fetchAllAssets: {
                [
                    .init(
                        id: "bitcoin",
                        name: "Bitcoin",
                        symbol: "BTC",
                        priceUsd: "100",
                        changePercent24Hr: "5.36"
                    ),
                    .init(
                        id: "dollar",
                        name: "Dollar",
                        symbol: "SOL",
                        priceUsd: "20",
                        changePercent24Hr: "-3"
                    )
                ]
            }
        )
    }
    
    static var testValue: AssetsApiClient{
        .init(fetchAllAssets: {
            //reportIssue("API is unimplemented")
            XCTFail("API is unimplemented")
            return[]
        })
    }
}

extension DependencyValues {
    var assetApiCLient: AssetsApiClient{
        get {
            self[AssetsApiClient.self]
        }
        set {
            self[AssetsApiClient.self] = newValue
        }
    }
}
