//
//  ProductDetailView.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 16.10.2022.
//

//struct ProductDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductDetailView()
//    }
//}

import SwiftUI

struct ProductDetailView: View {
    @Environment(\.presentationMode) private var mode
    @EnvironmentObject private var shopVM: ShopViewModel
    @Binding var product: ProductModel
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                // product images
                productImages
                // product data
                VStack(alignment: .leading, spacing: 5) {
                    // product article
                    productArticle
                    // product brand
                    productBrand
                    // product name
                    productName
                    // product cost
                    productCost
                    // product description
                    productDescription
                }
                .padding([.horizontal, .vertical])
                Spacer()
            }
            // close button
            closeButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.palette.parent.ignoresSafeArea())
    }
}

extension ProductDetailView {
    // product images
    @ViewBuilder private var productImages: some View {
        if let _ = product.images.first {
            TabView {
                ForEach(product.images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(height: 300)
        } else {
            ProgressView()
                .tint(Color.palette.child)
                .frame(maxWidth: .infinity, maxHeight: 300, alignment: .center)
        }
    }
    // product article
    private var productArticle: some View {
        Text("ID: \(product.article)")
            .font(.caption)
            .bold()
            .foregroundColor(Color.palette.child)
    }
    // product brand
    private var productBrand: some View {
        Text("BRAND: \(product.brand.rawValue)")
            .font(.caption)
            .bold()
            .foregroundColor(Color.palette.child)
    }
    // product name
    private var productName: some View {
        Text(product.name)
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
    // product description
    private var productDescription: some View {
        Text(product.description)
            .font(.subheadline)
            .foregroundColor(Color.palette.child)
    }
    
}

extension ProductDetailView {
    // close button
    private var closeButton: some View {
        VStack(spacing: 0) {
            Spacer()
            Button(action: {
                mode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.compact.down")
                    .foregroundColor(Color.palette.child)
                    .bold()
            })
        }
        .padding(.bottom)
    }
}


