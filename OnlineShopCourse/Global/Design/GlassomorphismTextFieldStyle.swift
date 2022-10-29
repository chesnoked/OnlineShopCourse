//
//  GlassomorphismTextFieldStyle.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 29.10.2022.
//

import SwiftUI

struct GlassomorphismTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .medium, design: .rounded))
            .foregroundColor(Color.palette.child)
            .padding()
            .background(
                LinearGradient(gradient: .init(colors: [
                    Color.palette.child,
                    Color.palette.child.opacity(0.3)
                ]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .opacity(0.37)
                .blur(radius: 15)
                .cornerRadius(30)
            )
        // strokes
            .overlay(
                RoundedRectangle(cornerRadius: 30.0)
                    .stroke(
                        LinearGradient(gradient: .init(colors: [
                            Color.palette.child.opacity(0.7),
                            .clear,
                            .clear,
                            .clear,
                            .clear,
                            .clear,
                            .clear,
                            .clear,
                            .clear,
                            .clear,
                            .clear,
                            Color.palette.child.opacity(0.7)
                        ]),
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                        ,
                        lineWidth: 2.0
                    )
                // shadow
                    .shadow(color: Color.palette.child, radius: 1, x: 1, y: -1)
            )
    }
}

extension View {
    func glassomorphismTextFieldStyle() -> some View {
        return modifier(GlassomorphismTextFieldStyle())
    }
}
