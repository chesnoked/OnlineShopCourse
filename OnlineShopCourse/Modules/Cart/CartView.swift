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
    
    @EnvironmentObject private var authVM: AuthViewModel
    @EnvironmentObject private var shopVM: ShopViewModel
    @EnvironmentObject private var cartVM: CartViewModel
    @State private var selectedPosition: PositionModel? = nil
    @State private var showNewOrderView: Bool = false
    
    var body: some View {
        
        ZStack {
            
            // new order
            newOrder
                
            VStack(spacing: 0) {
                
                // checkout
                checkout
                    .padding(.top)
                
                // positions
                positions
                    .padding(.vertical)
                    .animation(.linear)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.palette.parent.ignoresSafeArea())
    }
    // get user details
    private func getUserDetails() {
        cartVM.orderDetails.secondName = authVM.user?.secondName ?? ""
        cartVM.orderDetails.firstName = authVM.user?.firstName ?? ""
        cartVM.orderDetails.thirdName = authVM.user?.thirdName ?? ""
        cartVM.orderDetails.email = authVM.user?.email ?? ""
        cartVM.orderDetails.phone = authVM.user?.phone ?? ""
        cartVM.orderDetails.index = authVM.user?.index ?? ""
        cartVM.orderDetails.country = authVM.user?.country ?? ""
        cartVM.orderDetails.city = authVM.user?.city ?? ""
        cartVM.orderDetails.address = authVM.user?.address ?? ""
    }
}

extension CartView {
    // new order
    @ViewBuilder private var newOrder: some View {
        if showNewOrderView {
            NewOrderView(showNewOrderView: $showNewOrderView)
                .transition(.move(edge: .top))
                .animation(.linear(duration: 0.88))
                .zIndex(1)
                .onAppear {
                    getUserDetails()
                }
        }
    }
    // checkout
    @ViewBuilder private var checkout: some View {
        if !cartVM.positions.isEmpty {
            Button(action: {
                showNewOrderView.toggle()
            }, label: {
                Text("Checkout: \(cartVM.total.twoDecimalPlaces()) ₽")
                    .glassomorphismTextFieldStyle()
            })
        }
    }
    // positions
    private var positions: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 10) {
                ForEach(cartVM.positions) { position in
                    PositionSwipeView(position: $cartVM.positions[cartVM.getPositionIndex(position: position)])
                        .onTapGesture {
                            selectedPosition = position
                        }
                }
                .sheet(item: $selectedPosition) { position in
                    ProductDetailView(product: $shopVM.originalProducts[shopVM.getProductIndex(product: position.product)], amount: position.amount, position: position)
                }
            }
        }
    }
}
