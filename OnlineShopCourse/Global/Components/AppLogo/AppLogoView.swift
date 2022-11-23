//
//  AppLogoView.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 23.11.2022.
//

//struct AppLogoView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppLogoView()
//    }
//}

import SwiftUI
import SDWebImageSwiftUI

struct AppLogoView: View {
    var body: some View {
        AnimatedImage(name: "MyLikeAppLogo.GIF")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
            .frame(width: 88, height: 88)
            .overlay {
                Circle()
                    .fill(Color.palette.child.opacity(0.15))
                    .blur(radius: 5)
            }
            .overlay {
                Circle()
                    .stroke(
                        LinearGradient(gradient: .init(colors: [
                            Color.palette.child,
                            .clear,
                            Color.palette.child
                        ]),
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                        ,
                        lineWidth: 5.0
                    )
            }
            .shadow(color: Color.palette.child, radius: 5, x: 0, y: 0)
    }
}
