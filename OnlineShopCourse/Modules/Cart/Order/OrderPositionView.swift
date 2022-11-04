//
//  OrderPositionView.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 04.11.2022.
//

//struct OrderPositionView_Previews: PreviewProvider {
//    static var previews: some View {
//        OrderPositionView()
//    }
//}

import SwiftUI

struct OrderPositionView: View {
    @Binding var order: OrderModel
    var body: some View {
        HStack(spacing: 0) {
            Text("№: \(order.id)")
                .font(.caption)
                .bold()
                .foregroundColor(Color.palette.parent)
            Spacer()
            Text("\(order.total.twoDecimalPlaces()) ₽")
                .font(.callout)
                .foregroundColor(Color.palette.parent)
        }
        .padding(.horizontal)
        .frame(width: UIScreen.main.bounds.width * 0.66, height: 55)
        .background(Color.palette.child.cornerRadius(5))
    }
}


