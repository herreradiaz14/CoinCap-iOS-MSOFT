import Foundation
import Dependencies

@Observable
final class AssetListViewModelFinal{
    var errorMessage: String?
    var assets: [Asset] = []
    
    @ObservationIgnored
    @Dependency(\.assetApiCLient) var apiClient
    
    var clientConfigured = false
    
    func configClient() {
        clientConfigured = true
    }
    
    func fetchAssets() async {
            do {
                assets = try await apiClient.fetchAllAssets()
            } catch let error as NetworkinError {
                errorMessage = error.localizedDescription
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    
}
