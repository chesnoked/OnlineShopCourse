//
//  PositionView.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 25.10.2022.
//

//struct PositionView_Previews: PreviewProvider {
//    static var previews: some View {
//        PositionView()
//    }
//}

import SwiftUI

struct PositionView: View {
    let position: PositionModel
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            // position image
            positionImage
                .padding(.leading)
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
            .padding()
            Spacer()
            // position data
            VStack(alignment: .trailing, spacing: 5) {
                // product amount
                productAmount
                // position cost
                positionCost
            }
            .padding(.trailing)
        }
        .frame(width: UIScreen.main.bounds.width * 0.88, alignment: .leading)
        .background(Color.palette.child.cornerRadius(5))
    }
}

extension PositionView {
    // position image
    @ViewBuilder private var positionImage: some View {
        if let image = position.product.mainImage {
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
                            lineWidth: 0.44
                        )
                }
        }
    }
    // product category
    private var productCategory: some View {
        Text(position.product.category.rawValue)
            .font(.caption)
            .bold()
            .foregroundColor(Color.palette.parent)
    }
    // product brand
    private var productBrand: some View {
        Text(position.product.brand.rawValue)
            .font(.caption)
            .bold()
            .foregroundColor(Color.palette.parent)
    }
    // product name
    private var productName: some View {
        Text(position.product.name)
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


