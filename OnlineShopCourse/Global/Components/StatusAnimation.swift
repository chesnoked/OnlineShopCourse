//
//  StatusAnimation.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 23.10.2022.
//

//struct StatusAnimation_Previews: PreviewProvider {
//    static var previews: some View {
//        StatusAnimation()
//    }
//}

import SwiftUI

enum ImageStatus: String {
    case ok = "hand.thumbsup.fill"
    case none = "hand.thumbsdown.fill"
}

struct StatusAnimation: View {
    let mode: ImageStatus
    @State private var trigger: Bool = false
    var body: some View {
        Image(systemName: mode.rawValue)
            .foregroundColor(Color.palette.parent)
            .scaleEffect(trigger ? 1.61 : 1.0)
            .animation(Animation.timingCurve(0.34, 1.56, 0.88, 1.2, duration: 1))
            .onAppear {
                trigger.toggle()
            }
    }
}
