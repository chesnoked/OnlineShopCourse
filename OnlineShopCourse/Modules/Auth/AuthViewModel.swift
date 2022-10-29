//
//  AuthViewModel.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 29.10.2022.
//

import Foundation

class AuthViewModel: ObservableObject {
    
    @Published var authMethod: AuthMethod = AuthMethod.signin
    
}
