//
//  WelcomeView.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 23.11.2022.
//

//struct WelcomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomeView()
//    }
//}

import SwiftUI

struct WelcomeView: View {
    
    @State private var showLoginPage: Bool = false
    
    var body: some View {
        
        GeometryReader { proxy in
            
            // login page
            loginPage
            
            // app card
            appCard
                .position(x: proxy.frame(in: CoordinateSpace.local).midX,
                          y: proxy.frame(in: CoordinateSpace.local).midY)
            
            // welcome
            TabView {
                WelcomeBlock {
                    Text("Welcome 1")
                }
                WelcomeBlock {
                    Text("Welcome 2")
                }
                WelcomeBlock {
                    userConnect
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(height: proxy.size.height / 2)
            .position(x: proxy.frame(in: CoordinateSpace.local).midX,
                      y: proxy.size.height - proxy.size.height / 4)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.palette.parent.ignoresSafeArea())
    }
}

extension WelcomeView {
    // ViewBuilder welcome block
    struct WelcomeBlock<Content:View>:View {
        init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        let content: Content
        var body: some View {
            content
                .welcomeBlockStyle()
        }
    }
}

extension WelcomeView {
    // login page
    @ViewBuilder private var loginPage: some View {
        if showLoginPage {
            AuthView()
                .transition(.move(edge: .bottom).animation(.linear(duration: 1.2)))
                .zIndex(1)
        }
    }
    // app card
    private var appCard: some View {
        VStack(spacing: 15) {
            AppLogoView()
            Text("MyLikeApp")
                .font(.system(size: 18, weight: .heavy, design: .monospaced))
                .foregroundColor(Color.palette.child)
        }
    }
    // user connect
    private var userConnect: some View {
        Button(action: {
            showLoginPage = true
        }, label: {
            Text("Sign In / Sign Up")
        })
    }
}


