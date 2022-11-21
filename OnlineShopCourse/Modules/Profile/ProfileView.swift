//
//  ProfileView.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 15.10.2022.
//

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var authVM: AuthViewModel
    @EnvironmentObject private var profileVM: ProfileViewModel
    @State private var showLeftContextMenu: Bool = false
    @State private var showRightContextMenu: Bool = false
    @State private var selectedOrder: OrderModel? = nil
    @State private var myColorTheme: MyColorTheme = MyColorTheme()
    @State private var parentColor: Color = Color.palette.parent
    @State private var childColor: Color = Color.palette.child
    var body: some View {
        
        ZStack(alignment: showLeftContextMenu ? .topLeading : showRightContextMenu ? .topTrailing : .top) {
            VStack(spacing: 0) {
                
                // nav bar
                navBar
                    .padding([.horizontal, .vertical])
                
                // orders
                orders
                    .padding([.horizontal, .vertical])
            }
            // context menus
            Group {
                if showLeftContextMenu {
                    leftContextMenu
                }
                if showRightContextMenu {
                    rightContextMenu
                }
            }
            .transition(.opacity.animation(.linear(duration: 0.33)))
            .padding([.horizontal, .vertical])
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.palette.parent.ignoresSafeArea())
    }
}

extension ProfileView {
    // nav bar
    private var navBar: some View {
        HStack(spacing: 0) {
            // left context menu
            Button(action: {
                showRightContextMenu = false
                showLeftContextMenu = true
            }, label: {
                Image(systemName: "gear")
                    .glassomorphismTextFieldStyle()
            })
            Spacer()
            // right context menu
            Button(action: {
                showLeftContextMenu = false
                showRightContextMenu = true
            }, label: {
                Image(systemName: "person.fill")
                    .glassomorphismTextFieldStyle()
            })
        }
        .contentShape(Rectangle())
        .onTapGesture {
            showLeftContextMenu = false
            showRightContextMenu = false
        }
    }
}

extension ProfileView {
    // left context menu
    private var leftContextMenu: some View {
        CustomContexMenu {
            // parent color picker
            ContextMenuItem {
                HStack(spacing: 0) {
                    Text("parent color")
                        .font(.caption)
                        .foregroundColor(Color.palette.child)
                    Spacer()
                    parentColorPicker
                }
            }
            // child color picker
            ContextMenuItem {
                HStack(spacing: 0) {
                    Text("child color")
                        .font(.caption)
                        .foregroundColor(Color.palette.child)
                    Spacer()
                    childColorPicker
                }
            }
            // default color theme
            ContextMenuItem {
                defaultColorTheme
            }
        }
    }
    // right context menu
    private var rightContextMenu: some View {
        CustomContexMenu {
            ContextMenuItem {
                HStack(spacing: 0) {
                    Text("sign out")
                        .font(.caption)
                        .foregroundColor(Color.palette.child)
                    Spacer()
                    Button(action: {
                        authVM.signOut()
                    }, label: {
                        Image(systemName: "door.left.hand.open")
                            .font(.caption)
                            .bold()
                            .foregroundColor(Color.palette.child)
                    })
                }
            }
        }
    }
}

extension ProfileView {
    // parent color picker
    private var parentColorPicker: some View {
        ColorPicker(selection: $parentColor, supportsOpacity: true, label: { })
            .labelsHidden()
            .onChange(of: parentColor) { newParentColor in
                myColorTheme.saveColor(color: newParentColor, forKey: "parent_color")
            }
    }
    // child color picker
    private var childColorPicker: some View {
        ColorPicker(selection: $childColor, supportsOpacity: true, label: { })
            .labelsHidden()
            .onChange(of: childColor) { newChildColor in
                myColorTheme.saveColor(color: newChildColor, forKey: "child_color")
            }
    }
    // default color theme
    private var defaultColorTheme: some View {
        Button(action: {
            myColorTheme.defaultColorTheme()
        }, label: {
            Text("default color theme")
                .font(.caption)
                .foregroundColor(Color.palette.child)
        })
    }
}

extension ProfileView {
    // orders
    private var orders: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 10) {
                ForEach(profileVM.orders) { order in
                    OrderPositionView(order: $profileVM.orders[profileVM.getOrderIndex(order: order)])
                        .onTapGesture {
                            selectedOrder = order
                        }
                }
            }
        }
        .onAppear {
            profileVM.getOrders()
        }
        .sheet(item: $selectedOrder) { order in
            OrderDetailsView(order: $profileVM.orders[profileVM.getOrderIndex(order: order)])
        }
    }
}
