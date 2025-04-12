// Esto ya no se ocupa, ver otro archivo viewmodel
import Foundation

@Observable
final class AssetListViewModel{
   var errorMessage: String?
    var assets: [Asset] = []
    
    func fetchAssets() async {
        let urlSession = URLSession.shared
        let apiKey = "ffab4e2f346a6fc24e7537ce4e0495c81eea0cbf1a78a4d39fec59d0d2d0e92f"
        
        guard let url = URL(string: "https://rest.coincap.io/v3/assets?apiKey=\(apiKey)") else {
            errorMessage = "Invalid URL"
            return
        }
        
        do {
            let (data, _) = try await urlSession.data(for: URLRequest(url: url))
            let assetsResponse = try JSONDecoder().decode(AssetsResponse.self, from: data)
            self.assets = assetsResponse.data
        }catch{
            print(error.localizedDescription)
            errorMessage = error.localizedDescription
        }
    }
    
}
