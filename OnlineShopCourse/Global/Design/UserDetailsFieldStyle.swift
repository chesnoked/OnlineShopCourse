//
//  UserDetailsFieldStyle.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 11.11.2022.
//

import SwiftUI

struct UserDetailsFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .foregroundColor(Color.palette.child)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(5)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(
                        Color.palette.child
                        ,
                        lineWidth: 1.0
                    )
            )
    }
}

extension View {
    func userDetailsFieldStyle() -> some View {
        return modifier(UserDetailsFieldStyle())
    }
}
