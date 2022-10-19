//
//  ProfileView.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 15.10.2022.
//

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

import SwiftUI

struct ProfileView: View {
    @State private var myColorTheme: MyColorTheme = MyColorTheme()
    @State private var parentColor: Color = Color.palette.parent
    @State private var childColor: Color = Color.palette.child
    var body: some View {
        ZStack {
            // color theme changer
            colorThemeChanger
            VStack(spacing: 0) {
                Text("Profile")
                    .font(.largeTitle)
                    .foregroundColor(Color.palette.child)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.palette.parent.ignoresSafeArea())
    }
}

extension ProfileView {
    // color theme changer
    private var colorThemeChanger: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                // parent color picker
                ColorPicker(selection: $parentColor, supportsOpacity: true, label: { })
                    .onChange(of: parentColor) { newParentColor in
                        myColorTheme.saveColor(color: newParentColor, forKey: "parent_color")
                    }
                Spacer()
                Button(action: { myColorTheme.defaultColorTheme() }, label: { Text("set to default").foregroundColor(Color.palette.child) })
                Spacer()
                // child color picker
                ColorPicker(selection: $childColor, supportsOpacity: true, label: { })
                    .onChange(of: childColor) { newChildColor in
                        myColorTheme.saveColor(color: newChildColor, forKey: "child_color")
                    }
            }
            .labelsHidden()
            .padding([.horizontal, .vertical])
            Spacer()
        }
    }
}
