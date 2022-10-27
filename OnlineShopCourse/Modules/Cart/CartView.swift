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
            VStack(spacing: 0) {
                // nav bar
                navBar
                // positions
                positions
                    .animation(.linear)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.palette.parent.ignoresSafeArea())
    }
}

extension CartView {
    // nav bar
    private var navBar: some View {
        HStack(spacing: 0) {
            uploadOrder
            Spacer()
            total
            Spacer()
            resetOrder
        }
        .padding([.horizontal, .vertical])
        .background(Color.palette.child.ignoresSafeArea())
    }
    // upload order
    private var uploadOrder: some View {
        Button(action: {
            //
        }, label: {
            if cartVM.orderValidity {
                CloudAnimation()
            } else {
                Image(systemName: "icloud.and.arrow.up")
                    .foregroundColor(Color.palette.parent)
                    .bold()
            }
        })
    }
    // total
    private var total: some View {
        Text("\(cartVM.total.twoDecimalPlaces()) ₽")
            .font(.headline)
            .foregroundColor(Color.palette.parent)
    }
    // reset order
    private var resetOrder: some View {
        Button(action: {
            cartVM.resetOrder()
        }, label: {
            Image(systemName: "arrow.triangle.2.circlepath")
                .foregroundColor(Color.palette.parent)
                .bold()
        })
    }
    // positions
    private var positions: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 10) {
                ForEach(cartVM.order) { position in
                    PositionSwipeView(position: $cartVM.order[cartVM.getPositionIndex(position: position)])
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
}
