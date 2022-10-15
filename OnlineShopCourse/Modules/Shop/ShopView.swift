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
    var body: some View {
        ZStack {
            // products
            products
                .padding(.vertical)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.palette.parent.ignoresSafeArea())
    }
}

extension ShopView {
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
                }
            }
        }
    }
}
