//
//  ProductCardView.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 16.10.2022.
//

//struct ProductCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductCardView(product: ProductModel(image: "5"))
//    }
//}

import SwiftUI

struct ProductCardView: View {
    let product: ProductModel
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // product image
            productImage
                .padding(.bottom, 5)
            // product brand
            productBrand
            // product name
            productName
            // product cost
            productCost
        }
    }
}

extension ProductCardView {
    // product image
    @ViewBuilder private var productImage: some View {
        if let image = product.mainImage {
            Image(uiImage: image)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .frame(width: Settings.shared.productCardSize, height: Settings.shared.productCardSize)
        }
    }
    // product brand
    private var productBrand: some View {
        Text(product.brand?.rawValue ?? "")
            .font(.caption)
            .bold()
            .foregroundColor(Color.palette.child)
    }
    // product name
    private var productName: some View {
        Text(product.name ?? "")
            .lineLimit(1)
            .font(.headline)
            .foregroundColor(Color.palette.child)
    }
    // product cost
    private var productCost: some View {
        Text("\(product.cost.twoDecimalPlaces()) ₽")
            .font(.callout)
            .bold()
            .foregroundColor(Color.palette.child)
    }
}
