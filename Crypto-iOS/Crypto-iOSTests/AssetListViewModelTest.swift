import Testing
import Dependencies

@testable import Crypto_iOS

var assetStub: Asset = .init(
    id: "bitcoin",
    name: "Bitcoin",
    symbol: "BTC",
    priceUsd: "80123.12",
    changePercent24Hr: "20.121212"
)

extension AssetsApiClient {
     static var mockWithFailure: AssetsApiClient {
         .init(fetchAllAssets: {
             throw NetworkinError.invalidURL
         })
     }
     
     static var mockWithSuccess: AssetsApiClient {
         .init(fetchAllAssets: {
             [ assetStub ]
         })
     }
 }

struct AssetListViewModelTests {
     
     @Test func clientConfigured() {
         let viewModel = AssetListViewModelFinal()
         
         viewModel.configClient()
         
         #expect(viewModel.clientConfigured == true)
     }
     
     @Test func fetchAssetsFailure() async throws {
         let viewModel = withDependencies {
             $0.assetApiCLient = .mockWithFailure
         } operation: {
             AssetListViewModelFinal()
         }
         
         await viewModel.fetchAssets()
         
         #expect(viewModel.errorMessage == "Invalid URL")
     }
     
     @Test func fetchAssetsSuccess() async throws {
         let viewModel = withDependencies {
             $0.assetApiCLient = .mockWithSuccess
         } operation: {
             AssetListViewModelFinal()
         }
         
         await viewModel.fetchAssets()
         
         #expect(viewModel.assets.count == 1)
         #expect(viewModel.assets == [ assetStub ])
     }
 }
