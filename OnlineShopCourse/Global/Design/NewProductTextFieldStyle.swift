//
//  NewProductTextFieldStyle.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 21.10.2022.
//

import SwiftUI

struct NewProductTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .medium, design: .rounded))
            .foregroundColor(Color.palette.parent.opacity(0.88))
            .padding(5)
            .background(Color.white.cornerRadius(5))
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(
                        Color.palette.parent
                        ,
                        lineWidth: 1.0
                    )
            }
    }
}

extension View {
    func newProductTextFieldStyle() -> some View {
        return modifier(NewProductTextFieldStyle())
    }
}
