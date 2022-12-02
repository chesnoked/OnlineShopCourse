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
    @EnvironmentObject private var shopVM: ShopViewModel
    @State private var isDeleting: Bool = false
    @Binding var product: ProductModel
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
            ZStack(alignment: .bottomTrailing) {
                // product image
                Image(uiImage: image)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                // add to favorites
                addToFavorites
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 10))
            }
            .frame(width: Settings.shared.productCardSize, height: Settings.shared.productCardSize)
            .overlay(alignment: .center) {
                if UserDataService.shared.isAdmin {
                    // delete button
                    deleteButton
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10))
                    // delete status
                    deleteStatus
                }
            }
        }
    }
    // add to favorites
    private var addToFavorites: some View {
        Button(action: {
            withAnimation(.linear(duration: 0.66)) {
                shopVM.addToFavorites(product: product)
            }
        }, label: {
            Image(systemName: "heart.fill")
                .foregroundColor(product.isFavorites ? Color.palette.child : Color.white)
        })
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
        Text("\((product.cost ?? 0).twoDecimalPlaces()) ₽")
            .font(.callout)
            .bold()
            .foregroundColor(Color.palette.child)
    }
}

extension ProductCardView {
    // func delete product
    private func deleteProduct() {
        isDeleting = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            isDeleting = false
        }
        shopVM.deleteProduct(product: product) { result in
            switch result {
            case .success(_):
                isDeleting = false
            case .failure(_):
                break
            }
        }
    }
    // delete button
    private var deleteButton: some View {
        Button(action: {
            deleteProduct()
        }, label: {
            Image(systemName: "xmark.app.fill")
                .font(.caption)
                .bold()
                .foregroundColor(Color.red)
                .background(
                    Image(systemName: "app.fill")
                        .font(.caption)
                        .bold()
                        .foregroundColor(Color.black)
                )
        })
    }
    // delete status
    @ViewBuilder private var deleteStatus: some View {
        if isDeleting {
            ProgressView()
                .tint(Color.palette.child)
        }
    }
}
