//
//  UploadNewProductView.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 20.10.2022.
//

//struct UploadNewProductView_Previews: PreviewProvider {
//    static var previews: some View {
//        UploadNewProductView()
//    }
//}

import SwiftUI

struct UploadNewProductView: View {
    @Binding var showUploadNewProductView: Bool
    @State private var trigger: Bool = false
    var body: some View {
        ZStack {
            Text("New product")
                .font(.largeTitle)
                .foregroundColor(Color.palette.parent)
            // drag button
            dragButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.palette.child.ignoresSafeArea())
    }
}

extension UploadNewProductView {
    // drag button
    private var dragButton: some View {
        VStack(spacing: 0) {
            Spacer()
            DragButton(trigger: $trigger)
                .gesture(DragGesture()
                    .onChanged({ _ in
                        trigger = true
                    })
                        .onEnded({ dragValue in
                            trigger = false
                            if dragValue.translation.height < -55 {
                                showUploadNewProductView.toggle()
                            }
                        })
                )
        }
    }
}
