//
//  ContentView.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 15.10.2022.
//

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnlineShopView()
//    }
//}

import SwiftUI

enum TabItems: String, CaseIterable {
    case home = "house.fill"
    case shop = "shippingbox.fill"
    case cart = "cart.fill"
    case profile = "person.crop.circle.fill"
}

struct OnlineShopView: View {
    @StateObject private var shopVM: ShopViewModel = ShopViewModel()
    @StateObject private var cartVM: CartViewModel = CartViewModel()
    @StateObject private var profileVM: ProfileViewModel = ProfileViewModel()
    @Namespace private var tabBarNameSpace
    @State private var selectedTab: TabItems = .shop
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // pages
                pages
                Spacer()
                // tab bar
                tabBar
                    .padding(.vertical)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.palette.parent.ignoresSafeArea())
        .environmentObject(shopVM)
        .environmentObject(cartVM)
        .environmentObject(profileVM)
    }
}

extension OnlineShopView {
    // pages
    @ViewBuilder private var pages: some View {
        switch selectedTab {
        case .home:
            HomeView()
        case .shop:
            ShopView()
        case .cart:
            CartView()
        case .profile:
            ProfileView()
        }
    }
    // tab bar
    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(TabItems.allCases, id: \.self) { tabItem in
                ZStack {
                    if selectedTab == tabItem {
                        Circle()
                            .fill(Color.palette.child)
                            .matchedGeometryEffect(id: "tabs", in: tabBarNameSpace)
                            .frame(width: UIScreen.main.bounds.width / 6)
                    }
                    Image(systemName: tabItem.rawValue)
                        .foregroundColor(selectedTab == tabItem ? Color.palette.parent : Color.palette.child)
                        .glassomorphismTextFieldStyle()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture {
                    withAnimation(.linear) {
                        selectedTab = tabItem
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: 37)
    }
}
