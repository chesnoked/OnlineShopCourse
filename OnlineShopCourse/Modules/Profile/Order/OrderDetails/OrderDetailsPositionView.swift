//
//  OrderDetailsPositionView.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 11.11.2022.
//

//struct OrderDetailsPositionView_Previews: PreviewProvider {
//    static var previews: some View {
//        OrderDetailsPositionView()
//    }
//}

import SwiftUI

struct OrderDetailsPositionView: View {
    @EnvironmentObject private var shopVM: ShopViewModel
    let position: PositionModel
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            // position image
            positionImage
            // product data
            VStack(alignment: .leading, spacing: 5) {
                // product category
                productCategory
                // product brand
                productBrand
                // product name
                productName
                // product cost
                productCost
            }
            .padding(.horizontal)
            Spacer()
            // position data
            VStack(alignment: .trailing, spacing: 5) {
                // product amount
                productAmount
                // position cost
                positionCost
                Spacer()
            }
        }
        .padding()
        .frame(width: Settings.shared.positionWidth, alignment: .leading)
        .background(Color.palette.child.cornerRadius(5))
    }
    // get product
    private func getProduct() -> ProductModel? {
        return shopVM.originalProducts.first { oneProduct in
            position.product.id == oneProduct.id
        }
    }
}

extension OrderDetailsPositionView {
    // position image
    @ViewBuilder private var positionImage: some View {
        if let image = getProduct()?.mainImage {
            Image(uiImage: image)
                .resizable()
                .frame(width: 50, height: 50)
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke (
                            Color.palette.parent
                            ,
                            lineWidth: 0.55
                        )
                }
        }
    }
    // product category
    private var productCategory: some View {
        Text(getProduct()?.category?.rawValue ?? "")
            .font(.caption)
            .bold()
            .foregroundColor(Color.palette.parent)
    }
    // product brand
    private var productBrand: some View {
        Text(getProduct()?.brand?.rawValue ?? "")
            .font(.caption)
            .bold()
            .foregroundColor(Color.palette.parent)
    }
    // product name
    private var productName: some View {
        Text(getProduct()?.name ?? "")
            .lineLimit(1)
            .font(.headline)
            .foregroundColor(Color.palette.parent)
    }
    // product cost
    private var productCost: some View {
        Text("\(position.product.cost.twoDecimalPlaces()) ₽")
            .font(.callout)
            .foregroundColor(Color.palette.parent)
    }
    // product amount
    private var productAmount: some View {
        Text("x\(position.amount)")
            .font(.caption)
            .bold()
            .foregroundColor(Color.palette.parent)
    }
    // position cost
    private var positionCost: some View {
        Text("\(position.cost.twoDecimalPlaces()) ₽")
            .font(.callout)
            .foregroundColor(Color.palette.parent)
    }
}
