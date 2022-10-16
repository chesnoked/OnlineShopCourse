//
//  OnlineShopCourseApp.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 15.10.2022.
//

import SwiftUI
import FirebaseCore

@main
struct OnlineShopCourseApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var shopVM: ShopViewModel = ShopViewModel()
    
    var body: some Scene {
        WindowGroup {
            OnlineShopView()
                .environmentObject(shopVM)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
