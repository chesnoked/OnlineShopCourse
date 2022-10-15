//
//  ProductCardView.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 16.10.2022.
//

struct ProductCardView_Previews: PreviewProvider {
    static var previews: some View {
        ProductCardView(product: ProductModel(image: "5"))
    }
}

import SwiftUI

struct ProductCardView: View {
    let product: ProductModel
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // product image
            Image(product.image)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .frame(width: Settings.shared.productCardSize, height: Settings.shared.productCardSize)
            // product data
            Text(product.id).lineLimit(1)
                .font(.subheadline)
                .foregroundColor(Color.palette.child.opacity(0.88))
                .padding(.top, 5)
        }
    }
}
