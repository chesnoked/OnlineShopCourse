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
    @EnvironmentObject private var cartVM: CartViewModel
    @Binding var product: ProductModel
    @State private var amount: UInt8 = 1
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                // product images
                productImages
                // product data
                VStack(alignment: .leading, spacing: 10) {
                    // product article
                    productArticle
                    // product brand
                    productBrand
                    // product name
                    productName
                    // product cost
                    productCost
                    
                    // cart block
                    HStack(spacing: 15) {
                        // add to cart
                        addToCart
                        // product amount
                        productAmount
                    }
                    
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
    // add to cart
    private var addToCart: some View {
        Button(action: {
            cartVM.addToCart(product: product, amount: amount)
        }, label: {
            Image(systemName: "cart.fill.badge.plus")
                .foregroundColor(Color.palette.child)
        })
    }
    // product amount
    private var productAmount: some View {
        HStack(spacing: 10) {
            Stepper("", value: $amount, in: 1...10)
                .labelsHidden()
                .preferredColorScheme(.dark)
            Text("\(amount)")
                .foregroundColor(Color.palette.child)
        }
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


