import SwiftUI

struct AssetDetailView: View {
    @State var viewModel: AssetDetailViewModel
    
    var iconUrl: URL? {
        URL(string: "https://assets.coincap.io/assets/icons/\(viewModel.asset.symbol.lowercased())@2x.png")
    }
    
    var body: some View {
        VStack {
            Divider()
            AsyncImage(
                url: iconUrl
            ){
                image in image.resizable()
            }placeholder: {
                Image(systemName: "dollarsign.arrow.circlepath")
            }
            .frame(width: 40, height: 40)
            
            Text(viewModel.asset.name)
            Text(viewModel.asset.symbol)
            Text(viewModel.asset.priceUsd)
            Text(viewModel.asset.changePercent24Hr)
            Divider()
                .padding()
            Button {
                Task {
                    await viewModel.addToFavourites()
                }
            } label: {
                Text("Add to Favourites")
            }
        }
        .navigationTitle(viewModel.asset.name)
        .alert(viewModel.errorMessage ?? "", isPresented: $viewModel.showError){
            Button("OK"){
                
            }
        }
    }
}

#Preview {
    AssetDetailView(
        viewModel: .init(
            asset: .init(
                id: "bitcoin",
                name: "Bitcoin",
                symbol: "BTC",
                priceUsd: "$100",
                changePercent24Hr: "+5%"
            )
        )
    )
}
