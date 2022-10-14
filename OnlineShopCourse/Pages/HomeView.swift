//
//  HomeView.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 15.10.2022.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Text("Home")
                .font(.largeTitle)
                .foregroundColor(Color.palette.child)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.palette.parent.ignoresSafeArea())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
