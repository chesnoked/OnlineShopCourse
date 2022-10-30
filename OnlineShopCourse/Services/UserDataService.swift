//
//  UserDataService.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 30.10.2022.
//

import Foundation
import FirebaseAuth

class UserDataService {
    
    static let shared: UserDataService = UserDataService()
    
    private let auth = Auth.auth()
    
    // MARK: sign up
    func signUp(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            guard let _ = result else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(UserModel(email: email)))
        }
    }
    
    // MARK: sign in
    func signIn(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            guard let _ = result else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(UserModel(email: email)))
        }
    }
    
    // MARK: sign out
    func signOut() {
        do {
            try auth.signOut()
        } catch _ {
            //
        }
    }
}
