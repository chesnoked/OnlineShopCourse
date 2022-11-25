//
//  ShopBarView.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 15.11.2022.
//

//struct ShopBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShopBarView()
//    }
//}

import SwiftUI

enum ShopBarOptions: String, CaseIterable {
    case byFavorites = "star.fill"
    case byName = "textformat.size"
    case byCategory = "list.bullet"
    case byBrand = "bold"
    case news = "clock.arrow.2.circlepath"
    case search = "magnifyingglass"
}

struct ShopBarView: View {
    @EnvironmentObject private var shopVM: ShopViewModel
    @Binding var showCategoriesContextMenu: Bool
    @Binding var showBrandsContextMenu: Bool
    @Namespace private var shopBarNameSpace
    var body: some View {
        if shopVM.shopBarSelectedOption == .search {
            searchBar
        } else {
            shopBar
        }
    }
}

extension ShopBarView {
    // shop bar
    private var shopBar: some View {
        HStack(spacing: 0) {
            ForEach(ShopBarOptions.allCases, id: \.self) { option in
                ZStack {
                    if shopVM.shopBarSelectedOption == option {
                        Rectangle()
                            .fill(Color.palette.parent)
                            .matchedGeometryEffect(id: "shopbar", in: shopBarNameSpace)
                    }
                    Image(systemName: option.rawValue)
                        .foregroundColor(shopVM.shopBarSelectedOption == option ? Color.palette.child : Color.palette.parent)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture {
                    withAnimation(.spring()) {
                        shopVM.shopBarSelectedOption = option
                    }
                    if shopVM.shopBarSelectedOption == .byCategory { showCategoriesContextMenu.toggle() }
                    if shopVM.shopBarSelectedOption == .byBrand { showBrandsContextMenu.toggle() }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.55, height: 30)
        .background(Color.palette.child.cornerRadius(30.0))
    }
    // search bar
    private var searchBar: some View {
        TextField("", text: $shopVM.searchText)
            .font(.subheadline)
            .foregroundColor(Color.palette.child)
            .padding(.horizontal)
            .frame(width: UIScreen.main.bounds.width * 0.55, height: 30)
            .background(
                RoundedRectangle(cornerRadius: 30.0)
                    .stroke(
                        Color.palette.child
                        ,
                        lineWidth: 1.0
                    )
            )
            .overlay(alignment: .trailing) {
                Button(action: {
                    if shopVM.searchText.isEmpty {
                        shopVM.shopBarSelectedOption = .byName
                    } else {
                        shopVM.searchText = ""
                    }
                }, label: {
                    Image(systemName: shopVM.searchText.isEmpty ? "magnifyingglass" : "xmark")
                        .font(.caption)
                        .foregroundColor(Color.palette.child.opacity(0.44))
                        .animation(.linear(duration: 0.33))
                        .padding(.trailing, 5)
                })
            }
    }
}
