//
//  ShopView.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 15.10.2022.
//

import SwiftUI

struct ShopView: View {
    var body: some View {
        ZStack {
            Text("Shop")
                .font(.largeTitle)
                .foregroundColor(Color.palette.child)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.palette.parent.ignoresSafeArea())
    }
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView()
    }
}
