import SwiftUI

struct FavouritesView: View {
    @State var viewModel: FavouritesViewModel = .init()
    
    var body: some View {
        List {
            ForEach(viewModel.assets){ asset in
                AssetView(assetVieState: .init(asset))
            }
        }
        .listStyle(.plain)
        .task {
            await viewModel.getFavourites()
        }
    }
}
