//
//  UserDetailsView.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 11.11.2022.
//

//struct UserDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserDetailsView()
//    }
//}

import SwiftUI

struct UserDetailsView: View {
    @Binding var order: OrderModel
    @Binding var showUserDetailsView: Bool
    var body: some View {
        VStack(spacing: 0) {
            // show details
            showDetails
                .padding(.top)
            VStack(spacing: 5) {
                secondName
                firstName
                thirdName
                email
                phone
                index
                country
                city
                address
            }
            .padding([.horizontal, .vertical])
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.palette.parent.cornerRadius(5))
    }
}

extension UserDetailsView {
    // show details
    private var showDetails: some View {
        Button(action: {
            showUserDetailsView.toggle()
        }, label: {
            Text("User details")
                .glassomorphismTextFieldStyle()
        })
    }
    // second name
    private var secondName: some View {
        Text(order.user.secondName ?? "")
            .userDetailsFieldStyle()
    }
    // first name
    private var firstName: some View {
        Text(order.user.firstName ?? "")
            .userDetailsFieldStyle()
    }
    // third name
    private var thirdName: some View {
        Text(order.user.thirdName ?? "")
            .userDetailsFieldStyle()
    }
    // email
    private var email: some View {
        Text(order.user.email)
            .userDetailsFieldStyle()
    }
    // phone
    private var phone: some View {
        Text(order.user.phone ?? "")
            .userDetailsFieldStyle()
    }
    // index
    private var index: some View {
        Text(order.user.index ?? "")
            .userDetailsFieldStyle()
    }
    // country
    private var country: some View {
        Text(order.user.country ?? "")
            .userDetailsFieldStyle()
    }
    // city
    private var city: some View {
        Text(order.user.city ?? "")
            .userDetailsFieldStyle()
    }
    // address
    private var address: some View {
        Text(order.user.address ?? "")
            .userDetailsFieldStyle()
    }
}
