//
//  WelcomeBlockStyle.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 23.11.2022.
//

import SwiftUI

struct CustomDivider: View {
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(gradient: .init(colors: [
                    .clear,
                    Color.palette.child,
                    .clear
                ]),
                               startPoint: .leading,
                               endPoint: .trailing)
            )
            .frame(width: UIScreen.main.bounds.width * 0.66, height: 1.6)
            .shadow(color: Color.palette.child, radius: 3, x: 0, y: 0)
    }
}

struct WelcomeBlockStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.callout)
            .foregroundColor(Color.palette.child)
            .frame(width: UIScreen.main.bounds.width, height: 150)
            .background(
                LinearGradient(gradient: .init(colors: [
                    Color.palette.child,
                    Color.palette.child.opacity(0.3)
                ]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .opacity(0.37)
                .blur(radius: 15)
                .cornerRadius(0)
            )
            .overlay(alignment: .top) {
                CustomDivider()
            }
            .overlay(alignment: .bottom) {
                CustomDivider()
            }
    }
}

extension View {
    func welcomeBlockStyle() -> some View {
        return modifier(WelcomeBlockStyle())
    }
}
