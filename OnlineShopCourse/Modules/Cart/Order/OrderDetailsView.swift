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
                        .disabled(true)
                    userPhone
                    userIndex
                    userCountry
                    userCity
                    userAddress
                }
                orderNotes
                checkout
                    .padding(.top)
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
        TextField("second name", text: $cartVM.orderDetails.secondName)
            .uploadDataTextFieldStyle()
            .overlay(alignment: .trailing) {
                checkmark
                    .foregroundColor(cartVM.orderDetails.secondName.isEmpty ? .clear : Color.palette.parent)
            }
    }
    // user first name
    private var firstName: some View {
        TextField("first name", text: $cartVM.orderDetails.firstName)
            .uploadDataTextFieldStyle()
            .overlay(alignment: .trailing) {
                checkmark
                    .foregroundColor(cartVM.orderDetails.firstName.isEmpty ? .clear : Color.palette.parent)
            }
    }
    // user third name
    private var thirdName: some View {
        TextField("third name", text: $cartVM.orderDetails.thirdName)
            .uploadDataTextFieldStyle()
            .overlay(alignment: .trailing) {
                checkmark
                    .foregroundColor(cartVM.orderDetails.thirdName.isEmpty ? .clear : Color.palette.parent)
            }
    }
    // user email
    private var userEmail: some View {
        TextField("email", text: $cartVM.orderDetails.email)
            .uploadDataTextFieldStyle()
            .overlay(alignment: .trailing) {
                checkmark
                    .foregroundColor(cartVM.orderDetails.email.isEmpty ? .clear : Color.palette.parent)
            }
    }
    // user phone
    private var userPhone: some View {
        TextField("phone", text: $cartVM.orderDetails.phone)
            .uploadDataTextFieldStyle()
            .overlay(alignment: .trailing) {
                checkmark
                    .foregroundColor(cartVM.orderDetails.phone.isEmpty ? .clear : Color.palette.parent)
            }
    }
    // user index
    private var userIndex: some View {
        TextField("index", text: $cartVM.orderDetails.index)
            .uploadDataTextFieldStyle()
            .overlay(alignment: .trailing) {
                checkmark
                    .foregroundColor(cartVM.orderDetails.index.isEmpty ? .clear : Color.palette.parent)
            }
    }
    // user country
    private var userCountry: some View {
        TextField("country", text: $cartVM.orderDetails.country)
            .uploadDataTextFieldStyle()
            .overlay(alignment: .trailing) {
                checkmark
                    .foregroundColor(cartVM.orderDetails.country.isEmpty ? .clear : Color.palette.parent)
            }
    }
    // user city
    private var userCity: some View {
        TextField("city", text: $cartVM.orderDetails.city)
            .uploadDataTextFieldStyle()
            .overlay(alignment: .trailing) {
                checkmark
                    .foregroundColor(cartVM.orderDetails.city.isEmpty ? .clear : Color.palette.parent)
            }
    }
    // user address
    private var userAddress: some View {
        TextField("address", text: $cartVM.orderDetails.address)
            .uploadDataTextFieldStyle()
            .overlay(alignment: .trailing) {
                checkmark
                    .foregroundColor(cartVM.orderDetails.address.isEmpty ? .clear : Color.palette.parent)
            }
    }
    // order notes
    private var orderNotes: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $cartVM.orderDetails.notes)
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
            if cartVM.orderDetails.notes.isEmpty {
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
    // checkout
    @ViewBuilder private var checkout: some View {
        if cartVM.orderValidity {
            Button(action: {
                cartVM.uploadOrder()
            }, label: {
                Text("Checkout: \(cartVM.total.twoDecimalPlaces()) ₽")
                    .font(.headline)
                    .foregroundColor(Color.palette.parent)
            })
        }
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
