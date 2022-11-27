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
    @State var amount: UInt8 = 1
    @State var position: PositionModel? = nil
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                // product images
                productImages
                // product data
                VStack(alignment: .leading, spacing: 15) {
                    // product article
                    productArticle
                    // product category
                    productCategory
                    // product brand
                    productBrand
                    // product name
                    productName
                    // product cost
                    productCost
                    // cart module
                    cartModule
                    // product description
                    productDescription
                }
                .padding([.horizontal, .vertical])
                Spacer()
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.palette.parent.ignoresSafeArea())
    }
}

extension ProductDetailView {
    // product images
    @ViewBuilder private var productImages: some View {
        TabView {
            if product.images.count >= 2 {
                ForEach(product.images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            } else if let image = product.mainImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 300)
        .onAppear {
            shopVM.getProductImages(product: product)
        }
        .onDisappear {
            shopVM.originalProducts[shopVM.getProductIndex(product: product)].images.removeAll()
        }
    }
    // product article
    private var productArticle: some View {
        Text("ID: \(product.id)")
            .font(.caption)
            .bold()
            .foregroundColor(Color.palette.child)
    }
    // product category
    private var productCategory: some View {
        Text("CATEGORY: \(product.category?.rawValue ?? "")")
            .font(.caption)
            .bold()
            .foregroundColor(Color.palette.child)
    }
    // product brand
    private var productBrand: some View {
        Text("BRAND: \(product.brand?.rawValue ?? "")")
            .font(.caption)
            .bold()
            .foregroundColor(Color.palette.child)
    }
    // product name
    private var productName: some View {
        Text(product.name ?? "")
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
    // cart module
    private var cartModule: some View {
        HStack(spacing: 10) {
            // add to favorites
            addToFavorites
            // add to cart
            addToCart
            // product amount
            productAmount
                .padding(.leading, 5)
        }
    }
    // product description
    private var productDescription: some View {
        ScrollView(.vertical, showsIndicators: true) {
            Text(product.description ?? "")
                .font(.subheadline)
                .foregroundColor(Color.palette.child)
        }
    }
    
}

extension ProductDetailView {
    // add to favorites
    private var addToFavorites: some View {
        Button(action: {
            withAnimation(.linear(duration: 0.66)) {
                shopVM.addToFavorites(product: product)
            }
        }, label: {
            Image(systemName: "heart.circle")
                .foregroundColor(product.isFavorites ? Color.palette.child : Color.white)
        })
    }
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
        .onChange(of: amount) { newValue in
            changeProductAmount(to: newValue)
        }
    }
    // change product amount
    private func changeProductAmount(to newValue: UInt8) {
        guard let position = position else { return }
        cartVM.positions[cartVM.getPositionIndex(position: position)].amount = newValue
    }
}


