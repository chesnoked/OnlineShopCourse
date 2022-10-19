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
    
    private let myColorTheme: MyColorTheme = MyColorTheme()
    
    var parent: Color {
        return myColorTheme.loadColor(forKey: "parent_color") ?? Color("parent")
    }
    var child: Color {
        return myColorTheme.loadColor(forKey: "child_color") ?? Color("child")
    }
}

struct MyColorTheme {
    
    private let userDefaults = UserDefaults.standard
    
    func saveColor(color: Color, forKey: String) {
        let color = UIColor(color).cgColor
        if let components = color.components {
            userDefaults.set(components, forKey: forKey)
        }
    }
    
    func loadColor(forKey: String) -> Color? {
        guard let components = userDefaults.object(forKey: forKey) as? [CGFloat] else { return nil }
        return Color(.sRGB,
        red: components[0],
        green: components[1],
        blue: components[2],
        opacity: components[3])
    }
    
    func defaultColorTheme() {
        saveColor(color: Color("parent"), forKey: "parent_color")
        saveColor(color: Color("child"), forKey: "child_color")
    }
}
