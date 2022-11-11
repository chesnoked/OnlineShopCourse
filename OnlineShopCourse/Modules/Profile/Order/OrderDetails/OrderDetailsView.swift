//
//  OrderDetailsView.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 11.11.2022.
//

//struct OrderDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        OrderDetailsView()
//    }
//}

import SwiftUI

struct OrderDetailsView: View {
    @Binding var order: OrderModel
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                OrderPositionView(order: $order)
                positions
                    .padding(.vertical)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.palette.parent.ignoresSafeArea())
    }
}

extension OrderDetailsView {
    // positions
    private var positions: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 10) {
                ForEach(order.positions) { position in
                    OrderDetailsPositionView(position: position)
                }
            }
        }
    }
}


