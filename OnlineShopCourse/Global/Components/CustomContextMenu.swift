//
//  CustomContextMenu.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 21.11.2022.
//

import SwiftUI

// @ViewBuilder context menu one item
struct ContextMenuItem<Item:View>: View {
    init(@ViewBuilder item: () -> Item) {
        self.item = item()
    }
    let item: Item
    var body: some View {
        item
    }
}
// @ViewBuilder custom context menu
struct CustomContexMenu<Content:View>: View {
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    let content: Content
    var body: some View {
        VStack(spacing: 15) {
            content
        }
        .padding([.horizontal, .vertical])
        .frame(width: UIScreen.main.bounds.width * 0.33)
        .glassomorphismTextFieldStyle()
        .padding(1)
        .background(Color.palette.parent.cornerRadius(30.0))
    }
}
