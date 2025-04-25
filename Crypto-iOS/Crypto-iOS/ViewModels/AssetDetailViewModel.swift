import Foundation
import Dependencies

@Observable
final class AssetDetailViewModel {
    let asset: Asset
    var errorMessage: String?
    var showError = false
    
    @ObservationIgnored
    @Dependency(\.assetApiCLient) var apiClient
     
    @ObservationIgnored
    @Dependency(\.authClient) var authClient
    
    
    init(asset: Asset) {
        self.asset = asset
    }
    
    func addToFavourites() async {
        do {
            let user = try authClient.getCurrentUser()
            try await apiClient.saveFavourite(user, asset)
        } catch let error as AuthError {
            errorMessage = error.localizedDescription
            showError = true
        } catch {
            showError = true
        }
    }
    
//    func addToFavourites(){
//        // Check user login
//        guard let user = Auth.auth().currentUser else {
//            errorMessage = "User not authenticated"
//            showError = true
//            return
//        }
//        
//        let userId = user.uid
//        
//        // Connect Firestore
//        let db = Firestore.firestore()
//        let assetCollection = db.collection("favourites")
//        assetCollection
//            .document(userId)
//            .setData(
//                ["favourites": FieldValue.arrayUnion([asset.id])],
//                merge: true
//            )
//            
//    }
}
