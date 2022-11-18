//
//  AuthViewModel.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 29.10.2022.
//

import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    
    init() {
        getUser()
    }
    
    private let userDataService = UserDataService.shared
    
    @AppStorage("current_user") private var currentUser: String?
    
    @Published var user: UserModel?
    @Published var authMethod: AuthMethod = AuthMethod.signin
    @Published var authFields: AuthFields = AuthFields()
    @Published var isLoading: Bool = false
    
    // MARK: check on auth fields is valid
    var authFieldsValidity: Bool {
        guard !authFields.email.isEmpty,
              !authFields.password.isEmpty
        else { return false }
        switch authMethod {
        case .signin: return true
        case .signup: guard authFields.confirmPassword == authFields.password else { return false }
        }
        return true
    }
    
    // MARK: get user when app at start
    private func getUser() {
        guard let user = userDataService.currentUser else {
            authFields.email = currentUser ?? ""
            return
        }
        userDataService.downloadUserData(user: user) { result in
            switch result {
            case .success(let user):
                print("user start as: \(user.email)")
                self.user = user
            case .failure(_):
                break
            }
        }
    }
    
    // MARK: loader
    private func loader(deadline: Double) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + deadline) {
            self.isLoading = false
        }
    }
    
    // MARK: auth user
    func authUser() {
        guard authFieldsValidity else { return }
        loader(deadline: 15.0)
        switch authMethod {
        case .signin: signIn()
        case .signup: signUp()
        }
    }
    
    // MARK: sign in
    private func signIn() {
        userDataService.signIn(email: authFields.email, password: authFields.password) { result in
            switch result {
            case .success(let user):
                print("Successfully logged user: \(user.email)")
                self.user = user
                self.currentUser = user.email
                self.isLoading = false
            case .failure(_):
                break
            }
        }
    }
    
    // MARK: sign up
    private func signUp() {
        userDataService.signUp(email: authFields.email, password: authFields.password) { result in
            switch result {
            case .success(let user):
                print("Successfully registered user: \(user.email)")
                self.signOut()
                self.isLoading = false
                self.authMethod = .signin
            case .failure(_):
                break
            }
        }
    }
    
    // MARK: sign out
    func signOut() {
        userDataService.signOut()
        user = nil
    }

}
