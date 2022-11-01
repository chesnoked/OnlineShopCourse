//
//  AuthViewModel.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 29.10.2022.
//

import Foundation

class AuthViewModel: ObservableObject {
    
    init() {
        getUser()
    }
    
    private let userDataService = UserDataService.shared
    
    @Published var user: UserModel?
    @Published var authMethod: AuthMethod = AuthMethod.signin
    @Published var authFields: AuthFields = AuthFields()
    
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
        guard let user = userDataService.currentUser else { return }
        userDataService.downloadUserData(user: user) { result in
            switch result {
            case .success(let user):
                print("user start as: \(user.email)")
                print("user start as: \(user.id)")
                self.user = user
            case .failure(_):
                break
            }
        }
    }
    
    // MARK: auth user
    func authUser() {
        guard authFieldsValidity else { return }
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
            case .failure(_):
                break
            }
        }
    }
    
    // MARK: sign out
    func signOut() {
        userDataService.signOut()
    }

}
