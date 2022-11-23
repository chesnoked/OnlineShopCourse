//
//  UserDataService.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 30.10.2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserDataService {
    
    static let shared: UserDataService = UserDataService()
    
    private let auth = Auth.auth()
    private let database = Firestore.firestore()
    
    private var users: CollectionReference {
        return database.collection("users")
    }
    
    var currentUser: UserModel? {
        guard let user = auth.currentUser else { return nil }
        return UserModel(email: user.email!)
    }
    
    var isAdmin: Bool {
        guard let user = auth.currentUser,
              user.uid == "G2HHiI99oAQjQzrBsKGqAaq9fXo1"
        else { return false }
        return true
    }
    
    // MARK: download products favorite list from user personal account on Firebase Firestore
    func downloadFavoriteList(completion: @escaping (Result<[String], Error>) -> Void) {
        guard let user = currentUser else { return }
        let favoriteList = users.document(user.email).collection("favorites")
        favoriteList.getDocuments { querySnap, error in
            guard let querySnap = querySnap else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            var list: [String] = []
            for document in querySnap.documents {
                list.append(document.documentID)
            }
            completion(.success(list))
        }
    }
    
    // MARK: add favorite product to user personal account on Firebase Firestore
    func addProductToFavorites(product: ProductModel, completion: @escaping (Result<ProductModel, Error>) -> Void) {
        guard let user = currentUser else { return }
        let favoriteList = users.document(user.email).collection("favorites")
        if !product.isFavorites {
            favoriteList.document(product.id).setData([:]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(product))
                }
            }
        }
        else {
            favoriteList.document(product.id).delete { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(product))
                }
            }
        }
    }
    
    // MARK: upload user data to Firebase Firestore
    func uploadUserData(user: UserModel, completion: @escaping (Result<UserModel, Error>) -> Void) {
        users.document(user.email).setData(user.data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(user))
            }
        }
    }
    
    // MARK: sign up
    func signUp(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            guard let _ = result else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            self.uploadUserData(user: UserModel(email: email)) { result in
                switch result {
                case .success(let user):
                    completion(.success(user))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: download user data from Firebase Firestore
    func downloadUserData(user: UserModel, completion: @escaping (Result<UserModel, Error>) -> Void) {
        users.document(user.email).getDocument { docSnap, error in
            guard let docSnap = docSnap else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            guard let data = docSnap.data() else { return }
            let user = UserModel(email: data["email"] as? String ?? "",
                                 secondName: data["second_name"] as? String,
                                 firstName: data["first_name"] as? String,
                                 thirdName: data["third_name"] as? String,
                                 phone: data["phone"] as? String,
                                 index: data["index"] as? String,
                                 country: data["country"] as? String,
                                 city: data["city"] as? String,
                                 address: data["address"] as? String)
            completion(.success(user))
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
            self.downloadUserData(user: UserModel(email: email)) { result in
                switch result {
                case .success(let user):
                    completion(.success(user))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
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
