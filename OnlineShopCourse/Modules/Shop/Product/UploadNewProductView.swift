//
//  UploadNewProductView.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 20.10.2022.
//

//struct UploadNewProductView_Previews: PreviewProvider {
//    static var previews: some View {
//        UploadNewProductView()
//    }
//}

import SwiftUI
import PhotosUI

struct UploadNewProductView: View {
    @EnvironmentObject private var shopVM: ShopViewModel
    @Binding var showUploadNewProductView: Bool
    @State private var trigger: Bool = false
    @State private var pickerSelectedItems: [PhotosPickerItem] = []
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 0) {
                    // upload product
                    uploadProduct
                    Spacer()
                    // refresh shop
                    refreshShop
                }
                // product categories picker
                productCategoriesPicker
                // brand picker
                productBrandPicker
                // product article
                productArticle
                // product name
                productName
                // product cost
                productCost
                // product description
                productDescription
                // selected images
                selectedImages
                // status animation
                statusAnimation
                    .padding(.top)
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 0.66)
            .padding(.top, 50)
            // drag button
            dragButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.palette.child.ignoresSafeArea())
    }
}

extension UploadNewProductView {
    // product categories picker
    private var productCategoriesPicker: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("CATEGORY:")
                    .bold()
                    .foregroundColor(Color.palette.child)
                    .padding(.leading)
                Picker("", selection: $shopVM.newProduct.category) {
                    ForEach(Categories.allCases, id: \.self) { category in
                        Text(category.rawValue)
                            .tag(category.rawValue)
                    }
                }
                .accentColor(Color.palette.child)
            }
            .background(Color.palette.parent.cornerRadius(5))
            Spacer()
            Image(systemName: "checkmark")
                .foregroundColor(Categories.init(rawValue: shopVM.newProduct.category) == nil ? .clear : Color.palette.parent)
        }
    }
    // product brand picker
    private var productBrandPicker: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("BRAND:")
                    .bold()
                    .foregroundColor(Color.palette.child)
                    .padding(.leading)
                Picker("", selection: $shopVM.newProduct.brand) {
                    ForEach(Brands.allCases, id: \.self) { brand in
                        Text(brand.rawValue)
                            .tag(brand.rawValue)
                    }
                }
                .accentColor(Color.palette.child)
            }
            .background(Color.palette.parent.cornerRadius(5))
            Spacer()
            Image(systemName: "checkmark")
                .foregroundColor(Brands.init(rawValue: shopVM.newProduct.brand) == nil ? .clear : Color.palette.parent)
        }
    }
    // product article
    private var productArticle: some View {
        HStack(spacing: 0) {
            TextField("article", text: $shopVM.newProduct.article)
                .uploadDataTextFieldStyle()
            Spacer()
            Image(systemName: "checkmark")
                .foregroundColor(shopVM.newProduct.article.isEmpty ? .clear : Color.palette.parent)
        }
    }
    // product name
    private var productName: some View {
        HStack(spacing: 0) {
            TextField("name", text: $shopVM.newProduct.name)
                .uploadDataTextFieldStyle()
            Spacer()
            Image(systemName: "checkmark")
                .foregroundColor(shopVM.newProduct.name.isEmpty ? .clear : Color.palette.parent)
        }
    }
    // product cost
    private var productCost: some View {
        HStack(spacing: 0) {
            TextField("cost", text: $shopVM.newProduct.cost)
                .uploadDataTextFieldStyle()
            Spacer()
            Image(systemName: "checkmark")
                .foregroundColor(Double(shopVM.newProduct.cost) == nil ? .clear : Color.palette.parent)
        }
    }
    // product description
    private var productDescription: some View {
        HStack(alignment: .bottom, spacing: 0) {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $shopVM.newProduct.description)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(Color.palette.parent.opacity(0.88))
                    .cornerRadius(5)
                    .frame(height: 150)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(
                                Color.palette.parent
                                ,
                                lineWidth: 1.0
                            )
                    }
                if shopVM.newProduct.description.isEmpty {
                    Text("description")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(Color.gray.opacity(0.55))
                        .padding(EdgeInsets(top: 7, leading: 5, bottom: 5, trailing: 5))
                }
            }
            Spacer()
            Image(systemName: "checkmark")
                .foregroundColor(shopVM.newProduct.description.isEmpty ? .clear : Color.palette.parent)
        }
    }
    // image picker
    private var imagePicker: some View {
        PhotosPicker(selection: $pickerSelectedItems, maxSelectionCount: 5, matching: .any(of: [.images, .not(.videos)])) {
            Image(systemName: "photo.stack")
                .foregroundColor(Color.palette.parent)
                .bold()
        }
        .onChange(of: pickerSelectedItems) { newItems in
            Task {
                shopVM.newProduct.mainImage = nil
                shopVM.newProduct.images.removeAll()
                for item in newItems {
                    if let imageData = try? await item.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                        shopVM.newProduct.images.append(image)
                    }
                }
            }
        }
    }
    // selected images
    private var selectedImages: some View {
        HStack(spacing: 5) {
            // image picker
            imagePicker
            ForEach(shopVM.newProduct.images, id: \.self) { image in
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(5)
                    if shopVM.newProduct.mainImage == image {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color.palette.parent)
                            .bold()
                            .background(Circle().fill(Color.palette.child))
                    }
                }
                .onTapGesture {
                    shopVM.newProduct.mainImage = image
                }
            }
        }
    }
    // status animation
    private var statusAnimation: some View {
        Group {
            if shopVM.progressViewIsLoading {
                ProgressView()
                    .tint(Color.palette.parent)
            } else if shopVM.showStatusAnimation {
                StatusAnimation(status: shopVM.uploadProductStatus)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    // drag button
    private var dragButton: some View {
        VStack(spacing: 0) {
            Spacer()
            DragButton(trigger: $trigger)
                .gesture(DragGesture()
                    .onChanged({ _ in
                        trigger = true
                    })
                        .onEnded({ dragValue in
                            trigger = false
                            if dragValue.translation.height < -55 {
                                shopVM.resetProduct()
                                showUploadNewProductView.toggle()
                            }
                        })
                )
        }
    }
}

extension UploadNewProductView {
    // upload product
    @ViewBuilder private var uploadProduct: some View {
        if shopVM.productValidity {
            Button(action: {
                if let product = shopVM.setProduct() {
                    shopVM.uploadProduct(product: product)
                }
            }, label: {
                CloudAnimation()
            })
        }
    }
    // refresh shop
    private var refreshShop: some View {
        Button(action: {
            shopVM.refreshShop()
        }, label: {
            Image(systemName: "arrow.triangle.2.circlepath")
                .foregroundColor(Color.palette.parent)
                .bold()
        })
    }
}
