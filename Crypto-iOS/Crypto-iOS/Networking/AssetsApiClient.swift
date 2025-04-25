import Dependencies
import Foundation
import XCTestDynamicOverlay
import FirebaseFirestore

struct AssetsApiClient {
    var fetchAllAssets: () async throws -> [Asset]
    var saveFavourite: (User, Asset) async throws -> Void
    var fetchFavourites: (User) async throws -> [String]
    var fetchAsset: (String) async throws -> Asset
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
        let db = Firestore.firestore().collection("favourites")
        let urlSession = URLSession.shared
        let apiKey = ""//Complete apikey
        let baseUrl = "https://rest.coincap.io/v3"
        
        return .init(
            fetchAllAssets: {
                guard let url = URL(string: "\(baseUrl)/assets?apiKey=\(apiKey)") else {
                    throw NetworkinError.invalidURL
                }
                
                let (data, _) = try await urlSession.data(for: URLRequest(url: url))
                let assetsResponse = try JSONDecoder().decode(AssetsResponse.self, from: data)
                return assetsResponse.data
            },
            saveFavourite: {
                user,
                asset in
                try await db.document(
                    user.id
                ).setData(
                    ["favourites": FieldValue.arrayUnion(
                            [asset.id]
                        )],
                    merge: true
                )
            },
            fetchFavourites: { user in
                let doc = try await db.document(user.id).getDocument()
                let favourites = doc.get("favourites") as? [String]
                return favourites ?? []
            },
            fetchAsset: { assetId in
                guard let url = URL(string: "\(baseUrl)/assets/\(assetId)?apiKey=\(apiKey)") else {
                    throw NetworkinError.invalidURL
                }
                
                let (data, _) = try await urlSession.data(for: URLRequest(url: url))
                let asset = try JSONDecoder().decode(AssetResponse.self, from: data)
                
                return asset.data
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
            },
            saveFavourite: { _, _ in },
            fetchFavourites: { _ in [] },
            fetchAsset: { _ in
                .init(
                    id: "bitcoin",
                    name: "Bitcoin",
                    symbol: "BTC",
                    priceUsd: "100",
                    changePercent24Hr: "5.36"
                )
            }
        )
    }
    
    static var testValue: AssetsApiClient{
        .init(
            fetchAllAssets: {
                XCTFail("AssetsApiClient.fetchAllAssets is unimplemented")
                //            reportIssue("AssetsApiClient.fetchAllAssets is unimplemented")
                return []
            },
            saveFavourite: { _, _ in
                XCTFail("AssetsApiClient.saveFavourite is unimplemented")
            },
            fetchFavourites: { _ in
                XCTFail("AssetsApiClient.fetchFavourites is unimplemented")
                return []
            },
            fetchAsset: {_ in
                XCTFail("AssetsApiClient.fetchAsset is unimplemented")
                return .init(
                    id: "bitcoin",
                    name: "Bitcoin",
                    symbol: "BTC",
                    priceUsd: "100",
                    changePercent24Hr: "5.36"
                )
            }
        )
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
