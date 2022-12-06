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
    
    @AppStorage("current_user") private var currentUser: String = "new_user"
    
    @StateObject private var authVM: AuthViewModel = AuthViewModel()
//    @StateObject private var shopVM: ShopViewModel = ShopViewModel()
//    @StateObject private var cartVM: CartViewModel = CartViewModel()
//    @StateObject private var profileVM: ProfileViewModel = ProfileViewModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if currentUser == "new_user" {
                    WelcomeView()
                }
                else if UserDataService.shared.currentUser == nil && authVM.user == nil {
                    AuthView()
                } else {
                    OnlineShopView()
                }
            }
            .environmentObject(authVM)
//            .environmentObject(shopVM)
//            .environmentObject(cartVM)
//            .environmentObject(profileVM)
            .statusBarHidden(true)
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
