//
//  OrderDetailsView.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 28.10.2022.
//

//struct OrderDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        OrderDetailsView()
//    }
//}

import SwiftUI

struct OrderDetailsView: View {
    @EnvironmentObject private var cartVM: CartViewModel
    @State private var trigger: Bool = false
    @Binding var showOrderDetailsView: Bool
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .center, spacing: 10) {
                orderDetails
                    .padding(.bottom, 15)
                Group {
                    secondName
                    firstName
                    thirdName
                    userEmail
                    userPhone
                    userIndex
                    userCountry
                    userCity
                    userAddress
                }
                orderNotes
            }
            .frame(width: UIScreen.main.bounds.width * 0.66)
            .padding(.top, 30)
            // drag button
            dragButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.palette.child.ignoresSafeArea())
    }
}

extension OrderDetailsView {
    // user second name
    private var secondName: some View {
        TextField("second name", text: $cartVM.newOrder.user.secondName)
            .uploadDataTextFieldStyle()
            .overlay(alignment: .trailing) {
                checkmark
                    .foregroundColor(cartVM.newOrder.user.secondName.isEmpty ? .clear : Color.palette.parent)
            }
    }
    // user first name
    private var firstName: some View {
        TextField("first name", text: $cartVM.newOrder.user.firstName)
            .uploadDataTextFieldStyle()
            .overlay(alignment: .trailing) {
                checkmark
                    .foregroundColor(cartVM.newOrder.user.firstName.isEmpty ? .clear : Color.palette.parent)
            }
    }
    // user third name
    private var thirdName: some View {
        TextField("third name", text: $cartVM.newOrder.user.thirdName)
            .uploadDataTextFieldStyle()
            .overlay(alignment: .trailing) {
                checkmark
                    .foregroundColor(cartVM.newOrder.user.thirdName.isEmpty ? .clear : Color.palette.parent)
            }
    }
    // user email
    private var userEmail: some View {
        TextField("email", text: $cartVM.newOrder.user.email)
            .uploadDataTextFieldStyle()
            .overlay(alignment: .trailing) {
                checkmark
                    .foregroundColor(cartVM.newOrder.user.email.isEmpty ? .clear : Color.palette.parent)
            }
    }
    // user phone
    private var userPhone: some View {
        TextField("phone", text: $cartVM.newOrder.user.phone)
            .uploadDataTextFieldStyle()
            .overlay(alignment: .trailing) {
                checkmark
                    .foregroundColor(cartVM.newOrder.user.phone.isEmpty ? .clear : Color.palette.parent)
            }
    }
    // user index
    private var userIndex: some View {
        TextField("index", text: $cartVM.newOrder.user.index)
            .uploadDataTextFieldStyle()
            .overlay(alignment: .trailing) {
                checkmark
                    .foregroundColor(cartVM.newOrder.user.index.isEmpty ? .clear : Color.palette.parent)
            }
    }
    // user country
    private var userCountry: some View {
        TextField("country", text: $cartVM.newOrder.user.country)
            .uploadDataTextFieldStyle()
            .overlay(alignment: .trailing) {
                checkmark
                    .foregroundColor(cartVM.newOrder.user.country.isEmpty ? .clear : Color.palette.parent)
            }
    }
    // user city
    private var userCity: some View {
        TextField("city", text: $cartVM.newOrder.user.city)
            .uploadDataTextFieldStyle()
            .overlay(alignment: .trailing) {
                checkmark
                    .foregroundColor(cartVM.newOrder.user.city.isEmpty ? .clear : Color.palette.parent)
            }
    }
    // user address
    private var userAddress: some View {
        TextField("address", text: $cartVM.newOrder.user.address)
            .uploadDataTextFieldStyle()
            .overlay(alignment: .trailing) {
                checkmark
                    .foregroundColor(cartVM.newOrder.user.address.isEmpty ? .clear : Color.palette.parent)
            }
    }
    // order notes
    private var orderNotes: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $cartVM.newOrder.notes)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(Color.palette.parent.opacity(0.88))
                .cornerRadius(5)
                .frame(height: 88)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(
                            Color.palette.parent
                            ,
                            lineWidth: 1.0
                        )
                }
            if cartVM.newOrder.notes.isEmpty {
                Text("notes")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(Color.gray.opacity(0.55))
                    .padding(EdgeInsets(top: 7, leading: 5, bottom: 5, trailing: 5))
            }
        }
    }
}

extension OrderDetailsView {
    // order details
    private var orderDetails: some View {
        Text("Order details")
            .font(.headline)
            .foregroundColor(Color.palette.child)
            .padding()
            .background(Color.palette.parent.cornerRadius(5))
    }
    // checkmark
    private var checkmark: some View {
        Image(systemName: "checkmark")
            .font(.caption)
            .bold()
            .padding(.trailing, 5)
    }
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
                                showOrderDetailsView.toggle()
                            }
                        })
                )
        }
    }
}
