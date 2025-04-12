import SwiftUI

struct AssetList: View {
    @State var viewModel: AssetListViewModelFinal = .init()
    var body: some View {
        NavigationStack {
            Text(
                viewModel.errorMessage ?? ""
            )
            List{
                ForEach(
                    viewModel.assets
                ) {
                    asset in NavigationLink {
                        AssetDetailView(asset: asset)
                    } label: {
                        AssetView(
                            assetVieState: .init(
                                asset
                            )
                        )
                    }
                }
            }
            .listStyle(
                .plain
            )
            .task {
                //Poner las funciones asincronas
                await viewModel
                    .fetchAssets()
            }
            .navigationTitle("Home")
            //        .onAppear{
            //
            //        }
    //        .onDisappear{
    //            task?.cancel()
    //        }
            // Para cargar los registros dando clic en el boton
    //        Button("Fetch assets"){
    //            Task{
    //                await viewModel.fetchAssets()
    //            }
    //        }
        }
    }
}

#Preview {
    AssetList()
}
