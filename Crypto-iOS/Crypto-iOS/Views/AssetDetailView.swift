import SwiftUI

struct AssetDetailView: View {
    let asset: Asset
    
    var body: some View {
        Text(asset.name)
        Text(asset.symbol)
        Text(asset.priceUsd)
        Text(asset.changePercent24Hr)
            .navigationTitle(asset.name)
    }
}

#Preview {
    AssetDetailView(
        asset: .init(
            id: "bitcoin",
            name: "Bitcoin",
            symbol: "BTC",
            priceUsd: "$100",
            changePercent24Hr: "+5%"
        )
    )
}
