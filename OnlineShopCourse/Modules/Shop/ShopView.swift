//
//  ShopView.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 15.10.2022.
//

//struct ShopView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShopView()
//    }
//}

import SwiftUI

struct ShopView: View {
    
    @EnvironmentObject private var shopVM: ShopViewModel
    @State private var showContextMenu: Bool = true
    @State private var selectedProduct: ProductModel? = nil
    @State private var showUploadNewProductView: Bool = false
    @State private var trigger: Bool = false
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            // upload new product
            uploadNewProduct
            
            VStack(spacing: 0) {
                
                // admin bar
                adminBar
                
                // products
                products
                    .padding(.vertical)
                
                
                // shop bar
                ShopBarView()
                    .padding(.vertical)
                    .padding(.bottom)
            }
            
            // context menus
            ZStack(alignment: .bottom) {
                if showContextMenu {
                    if shopVM.shopBarSelectedOption == .byCategory {
                        categoriesContextMenu
                    }
                    if shopVM.shopBarSelectedOption == .byBrand {
                        brandsContextMenu
                    }
                }
                // hide button
                hideButton
                    .opacity(shopVM.shopBarSelectedOption == .byCategory || shopVM.shopBarSelectedOption == .byBrand ? 1.0 : 0.0)
                    .padding(.bottom)
            }
            .padding(.bottom)
            .padding(.bottom)
            .padding(.bottom)
            .offset(y: -30)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.palette.parent.ignoresSafeArea())
    }
}

extension ShopView {
    // upload new product
    @ViewBuilder private var uploadNewProduct: some View {
        if showUploadNewProductView {
            UploadNewProductView(showUploadNewProductView: $showUploadNewProductView)
                .transition(.move(edge: .top))
                .animation(.linear(duration: 0.88))
                .zIndex(1)
        }
    }
    // admin bar
    @ViewBuilder private var adminBar: some View {
        if UserDataService.shared.isAdmin {
            DragButton(trigger: $trigger)
                .gesture(DragGesture()
                    .onChanged({ _ in
                        trigger = true
                    })
                        .onEnded({ dragValue in
                            trigger = false
                            if dragValue.translation.height > 55 {
                                showUploadNewProductView.toggle()
                            }
                        })
                )
        }
    }
    // products
    @ViewBuilder private var products: some View {
        let columns: [GridItem] = [GridItem(.fixed(Settings.shared.productCardSize), spacing: 15, alignment: nil),
                                   GridItem(.fixed(Settings.shared.productCardSize), spacing: 15, alignment: nil)]
        ScrollView(.vertical, showsIndicators: true) {
            LazyVGrid(columns: columns,
                      alignment: .center,
                      spacing: 15,
                      pinnedViews: []) {
                ForEach(shopVM.currentProducts) { product in
                    ProductCardView(product: product)
                        .onTapGesture {
                            selectedProduct = product
                        }
                }
                .sheet(item: $selectedProduct) { product in
                    ProductDetailView(product: $shopVM.originalProducts[shopVM.getProductIndex(product: product)])
                }
            }
        }
    }
}

extension ShopView {
    // categories context menu
    private var categoriesContextMenu: some View {
        CustomContexMenu {
            ForEach(Categories.allCases, id: \.self) { category in
                ContextMenuItem {
                    Text(category.rawValue)
                        .font(.caption)
                        .bold(shopVM.selectedCategory == category)
                        .scaleEffect(shopVM.selectedCategory == category ? 1.2 : 1.0)
                        .foregroundColor(Color.palette.child)
                }
                .onTapGesture {
                    if shopVM.selectedCategory == category { shopVM.selectedCategory = nil }
                    else { shopVM.selectedCategory = category }
                }
            }
        }
    }
    // brands context menu
    private var brandsContextMenu: some View {
        CustomContexMenu {
            ForEach(Brands.allCases, id: \.self) { brand in
                ContextMenuItem {
                    Text(brand.rawValue)
                        .font(.caption)
                        .bold(shopVM.selectedBrand == brand)
                        .scaleEffect(shopVM.selectedBrand == brand ? 1.2 : 1.0)
                        .foregroundColor(Color.palette.child)
                }
                .onTapGesture {
                    if shopVM.selectedBrand == brand { shopVM.selectedBrand = nil }
                    else { shopVM.selectedBrand = brand }
                }
            }
        }
    }
    // hide button
    private var hideButton: some View {
        Button(action: {
            showContextMenu.toggle()
        }, label: {
            Image(systemName: showContextMenu ? "chevron.compact.down" : "chevron.compact.up")
                .font(.caption2)
                .bold()
                .foregroundColor(Color.palette.child)
        })
    }
}
