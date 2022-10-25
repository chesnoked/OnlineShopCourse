//
//  CartView.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 15.10.2022.
//

//struct CartView_Previews: PreviewProvider {
//    static var previews: some View {
//        CartView()
//    }
//}

import SwiftUI

struct CartView: View {
    @EnvironmentObject private var shopVM: ShopViewModel
    @EnvironmentObject private var cartVM: CartViewModel
    @State private var selectedPosition: PositionModel? = nil
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 10) {
                    ForEach(cartVM.order) { position in
                        PositionView(position: $cartVM.order[cartVM.getPositionIndex(position: position)])
                            .onTapGesture {
                                selectedPosition = position
                            }
                    }
                    .sheet(item: $selectedPosition) { position in
                        ProductDetailView(product: $shopVM.products[shopVM.getProductIndex(product: position.product)], amount: position.amount, position: position)
                    }
                }
            }
            .padding(.vertical)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.palette.parent.ignoresSafeArea())
    }
}
