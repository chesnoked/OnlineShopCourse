//
//  ColorTheme.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 15.10.2022.
//

import Foundation
import SwiftUI

extension Color {
    static let palette: Palette = Palette()
}

struct Palette {
    let child: Color = Color("child")
    let parent: Color = Color("parent")
}
