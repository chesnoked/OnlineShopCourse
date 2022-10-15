//
//  OnlineShopCourseApp.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 15.10.2022.
//

import SwiftUI

@main
struct OnlineShopCourseApp: App {
    @StateObject private var shopVM: ShopViewModel = ShopViewModel()
    var body: some Scene {
        WindowGroup {
            OnlineShopView()
                .environmentObject(shopVM)
        }
    }
}
