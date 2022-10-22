//
//  CloudAnimation.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 23.10.2022.
//

struct CloudAnimation_Previews: PreviewProvider {
    static var previews: some View {
        CloudAnimation()
    }
}

import SwiftUI

struct CloudAnimation: View {
    @State private var trigger: Bool = false
    var body: some View {
        Image(systemName: "icloud.and.arrow.up")
            .foregroundColor(Color.palette.parent)
            .bold()
            .scaleEffect(trigger ? 1.2 : 1)
            .animation(.linear(duration: 0.66).repeatForever(autoreverses: true))
            .onAppear {
                trigger.toggle()
            }
    }
}
