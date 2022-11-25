//
//  OrderPositionView.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 04.11.2022.
//

//struct OrderPositionView_Previews: PreviewProvider {
//    static var previews: some View {
//        OrderPositionView()
//    }
//}

import SwiftUI

struct OrderPositionView: View {
    @Binding var order: OrderModel
    @State private var showUserDetailsView: Bool = false
    var body: some View {
        ZStack {
            // user details
            userDetails
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    number
                    Spacer()
                    total
                }
                status
                    .padding(.vertical, 10)
                VStack(alignment: .leading, spacing: 3) {
                    userID
                    date
                    notes
                        .padding(.top, 5)
                }
            }
        }
        .padding()
        .background(Color.palette.child.cornerRadius(5))
    }
}

extension OrderPositionView {
    // user details
    @ViewBuilder private var userDetails: some View {
        if showUserDetailsView {
            UserDetailsView(order: $order, showUserDetailsView: $showUserDetailsView)
                .transition(.opacity.animation(.linear(duration: 0.88)))
                .zIndex(1)
                .onAppear {
                    getUserDetails()
                }
        }
    }
    // get user details
    private func getUserDetails() {
        UserDataService.shared.downloadUserData(user: UserModel(email: order.user.email)) { result in
            switch result {
            case .success(let user):
                order.user = user
            case .failure(_):
                break
            }
        }
    }
}

extension OrderPositionView {
    // order number
    private var number: some View {
        Text("№: \(order.id)")
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(Color.palette.parent)
    }
    // order total
    private var total: some View {
        Text("\(order.total.twoDecimalPlaces()) ₽")
            .font(.callout)
            .foregroundColor(Color.palette.parent)
    }
    // order status
    private var status: some View {
        Group {
            if UserDataService.shared.isAdmin {
                Picker("", selection: $order.status) {
                    ForEach(OrderStatus.allCases, id: \.self) { status in
                        Text(status.rawValue)
                            .tag(status.rawValue)
                    }
                }
                .accentColor(Color.palette.child)
            } else {
                Text(order.status.rawValue)
                    .font(.caption2)
                    .bold()
                    .foregroundColor(Color.palette.child)
                    .padding(5)
            }
        }
        .background(Color.palette.parent.cornerRadius(5))
        .onChange(of: order.status) { _ in
            OrderDataService.shared.changeOrderStatus(order: order)
        }
    }
    // order user id
    @ViewBuilder private var userID: some View {
        if UserDataService.shared.isAdmin {
            Button(action: {
                showUserDetailsView.toggle()
            }, label: {
                Text(order.user.email)
                    .font(.caption2)
                    .bold()
                    .foregroundColor(Color.palette.parent)
            })
        } else {
            Text(order.user.email)
                .font(.caption2)
                .bold()
                .foregroundColor(Color.palette.parent)
        }
    }
    // order date
    private var date: some View {
        Text(order.date.shortFormat)
            .font(.caption)
            .bold()
            .foregroundColor(Color.palette.parent)
    }
    // order notes
    private var notes: some View {
        Text(order.notes)
            .font(.footnote)
            .foregroundColor(Color.palette.parent)
    }
}


