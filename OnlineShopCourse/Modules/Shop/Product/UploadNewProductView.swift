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
            VStack(spacing: 10) {
                HStack(spacing: 0) {
                    // upload product
                    uploadProduct
                    Spacer()
                    // reset product
                    resetProduct
                }
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
                // image picker
                imagePicker
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
    // product brand picker
    private var productBrandPicker: some View {
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
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    // product article
    private var productArticle: some View {
        HStack(spacing: 0) {
            TextField("article", text: $shopVM.newProduct.article)
                .newProductTextFieldStyle()
            Spacer()
            Image(systemName: "checkmark")
                .foregroundColor(shopVM.newProduct.article.isEmpty ? .clear : Color.palette.parent)
        }
    }
    // product name
    private var productName: some View {
        HStack(spacing: 0) {
            TextField("name", text: $shopVM.newProduct.name)
                .newProductTextFieldStyle()
            Spacer()
            Image(systemName: "checkmark")
                .foregroundColor(shopVM.newProduct.name.isEmpty ? .clear : Color.palette.parent)
        }
    }
    // product cost
    private var productCost: some View {
        HStack(spacing: 0) {
            TextField("cost", text: $shopVM.newProduct.cost)
                .newProductTextFieldStyle()
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
    // selected images
    private var selectedImages: some View {
        HStack(spacing: 5) {
            ForEach(shopVM.newProduct.images, id: \.self) { image in
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(5)
                    if shopVM.newProduct.mainImage == image {
                        Image(systemName: "checkmark")
                            .foregroundColor(Color.palette.child)
                            .bold()
                    }
                }
                .onTapGesture {
                    shopVM.newProduct.mainImage = image
                }
            }
        }
    }
    // image picker
    private var imagePicker: some View {
        PhotosPicker(selection: $pickerSelectedItems, maxSelectionCount: 5, matching: .any(of: [.images, .not(.videos)])) {
            Image(systemName: "photo.stack")
                .font(.system(size: 18))
                .bold()
                .foregroundColor(Color.palette.child)
        }
        .padding(10)
        .background(Circle().fill(Color.palette.parent))
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
                                showUploadNewProductView.toggle()
                            }
                        })
                )
        }
    }
}

extension UploadNewProductView {
    // upload product
    private var uploadProduct: some View {
        Button(action: {
            if let product = shopVM.setProduct() {
                shopVM.uploadProduct(product: product)
            }
        }, label: {
            Image(systemName: "icloud.and.arrow.up")
                .foregroundColor(Color.palette.parent)
                .bold()
        })
    }
    // reset product
    private var resetProduct: some View {
        Button(action: {
            shopVM.resetProduct()
        }, label: {
            Image(systemName: "arrow.triangle.2.circlepath")
                .foregroundColor(Color.palette.parent)
                .bold()
        })
    }
}
