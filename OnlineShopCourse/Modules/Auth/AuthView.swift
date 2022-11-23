//
//  AuthView.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 29.10.2022.
//

//struct AuthView_Previews: PreviewProvider {
//    static var previews: some View {
//        AuthView()
//    }
//}

import SwiftUI

struct AuthView: View {
    @EnvironmentObject private var authVM: AuthViewModel
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                AppLogoView()
                    .padding(.bottom, 15)
                email
                password
                confirmPassword
                authMethodPicker
                    .padding(.top, 10)
                Group {
                    if authVM.isLoading {
                        statusLoading
                    } else {
                        authButton
                    }
                }
                .padding(.top, 10)
            }
            .frame(width: UIScreen.main.bounds.width * 0.6)
            .animation(.linear(duration: 0.44).delay(0.33))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.palette.parent.ignoresSafeArea())
    }
}

extension AuthView {
    // user email
    private var email: some View {
        TextField("email", text: $authVM.authFields.email)
            .glassomorphismTextFieldStyle()
    }
    // password
    private var password: some View {
        SecureField("password", text: $authVM.authFields.password)
            .glassomorphismTextFieldStyle()
    }
    // confirm password
    @ViewBuilder private var confirmPassword: some View {
        if authVM.authMethod == .signup {
            SecureField("confirm password", text: $authVM.authFields.confirmPassword)
                .glassomorphismTextFieldStyle()
        }
    }
    // auth method picker
    private var authMethodPicker: some View {
        ZStack(alignment: authVM.authMethod == .signin ? .leading : .trailing) {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.palette.child)
                .frame(width: 55)
                .onTapGesture {
                    switchAuthMethod()
                }
            Circle()
                .fill(Color.palette.parent)
                .frame(width: 30)
        }
        .frame(height: 30.0)
    }
    // swith auth method
    private func switchAuthMethod() {
        switch authVM.authMethod {
        case .signin:
            authVM.authMethod = .signup
        case .signup:
            authVM.authMethod = .signin
        }
    }
    // auth button
    @ViewBuilder private var authButton: some View {
        if authVM.authFieldsValidity {
            Button(action: {
                authVM.authUser()
            }, label: {
                Text(authVM.authMethod.rawValue)
                    .font(.caption)
                    .bold()
                    .foregroundColor(Color.palette.child)
                    .scaleEffect(1.2)
            })
        }
    }
    // status loading
    private var statusLoading: some View {
        ProgressView()
            .tint(Color.palette.child)
    }
}
