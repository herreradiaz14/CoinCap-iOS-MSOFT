import SwiftUI

struct AssetViewState {
    let asset: Asset
    
    init(_ asset: Asset) {
        self.asset = asset
    }
    
    var percentageColor: Color {
        percentage >= 0 ? .green : .red
    }
    
    var percentage: Double {
        Double(asset.changePercent24Hr) ?? 0
    }
    
    var formattedPrice: String {
        String(format: "%.2f",  Double(asset.priceUsd) ?? 0)
    }
    
    var formattedPercentage: String {
        String(format: "%.2f",  Double(asset.changePercent24Hr) ?? 0)
    }
    
    var iconUrl: URL? {
        URL(string: "https://assets.coincap.io/assets/icons/\(asset.symbol.lowercased())@2x.png")
    }
}

struct AssetView: View {
    let assetVieState: AssetViewState
    var body: some View {
        Grid {
            GridRow {
                AsyncImage(
                    url: assetVieState.iconUrl
                ){
                    image in image.resizable()
                }placeholder: {
                    // Cmd + shift + L
                    Image(systemName: "dollarsign.arrow.circlepath")
                }
                .frame(width: 40, height: 40)
            
            
                VStack(alignment: .leading) {
                    Text(assetVieState.asset.symbol)
                        .font(.headline)
                    Text(assetVieState.asset.name)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                
                Text(assetVieState.formattedPercentage)
                    .foregroundStyle(assetVieState.percentageColor)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
                Text(assetVieState.formattedPrice)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}

#Preview {
    AssetView(
        assetVieState: .init(
            .init(
                id: "bitcoin",
                name: "Bitcoin",
                symbol: "BTC",
                priceUsd: "$100",
                changePercent24Hr: "+5%"
            )
        )
    )
}
