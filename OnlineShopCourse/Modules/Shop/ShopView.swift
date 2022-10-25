//
//  ShopView.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 15.10.2022.
//

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView()
    }
}

import SwiftUI

struct ShopView: View {
    @EnvironmentObject private var shopVM: ShopViewModel
    @State private var selectedProduct: ProductModel? = nil
    @State private var showUploadNewProductView: Bool = false
    @State private var trigger: Bool = false
    var body: some View {
        ZStack {
            // upload new product
            uploadNewProduct
            VStack(spacing: 0) {
                // admin bar
                adminBar
                // products
                products
                    .padding(.vertical)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.palette.parent.ignoresSafeArea())
    }
}

extension ShopView {
    // upload new product
    @ViewBuilder private var uploadNewProduct: some View {
        if showUploadNewProductView {
            UploadNewProductView(showUploadNewProductView: $showUploadNewProductView)
                .transition(.move(edge: .top))
                .animation(.linear(duration: 0.88))
                .zIndex(1)
        }
    }
    // admin bar
    private var adminBar: some View {
        DragButton(trigger: $trigger)
            .gesture(DragGesture()
                .onChanged({ _ in
                    trigger = true
                })
                    .onEnded({ dragValue in
                        trigger = false
                        if dragValue.translation.height > 55 {
                            showUploadNewProductView.toggle()
                        }
                    })
            )
    }
    // products
    @ViewBuilder private var products: some View {
        let columns: [GridItem] = [GridItem(.fixed(Settings.shared.productCardSize), spacing: 15, alignment: nil),
                                   GridItem(.fixed(Settings.shared.productCardSize), spacing: 15, alignment: nil)]
        ScrollView(.vertical, showsIndicators: true) {
            LazyVGrid(columns: columns,
                      alignment: .center,
                      spacing: 15,
                      pinnedViews: []) {
                ForEach(shopVM.products) { product in
                    ProductCardView(product: product)
                        .onTapGesture {
                            selectedProduct = product
                        }
                }
                .sheet(item: $selectedProduct) { product in
                    ProductDetailView(product: $shopVM.products[shopVM.getProductIndex(product: product)])
                }
            }
        }
    }
}
