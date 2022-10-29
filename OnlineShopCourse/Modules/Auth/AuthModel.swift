//
//  AuthModel.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 29.10.2022.
//

import Foundation

enum AuthMethod: String {
    case signin = "Sign In"
    case signup = "Sign Up"
    case signout = "Sign Out"
}

struct UserModel: Identifiable {
    
    let id: String
    let email: String
    let secondName: String?
    let firstName: String?
    let thirdName: String?
    let phone: String?
    let index: String?
    let country: String?
    let city: String?
    let address: String?
    
    init(id: String, email: String, secondName: String? = nil, firstName: String? = nil, thirdName: String? = nil, phone: String? = nil, index: String? = nil, country: String? = nil, city: String? = nil, address: String? = nil) {
        self.id = id
        self.email = email
        self.secondName = secondName
        self.firstName = firstName
        self.thirdName = thirdName
        self.phone = phone
        self.index = index
        self.country = country
        self.city = city
        self.address = address
    }
}

struct NewUser {
    var email: String = ""
    var secondName: String = ""
    var firstName: String = ""
    var thirdName: String = ""
    var phone: String = ""
    var index: String = ""
    var country: String = ""
    var city: String = ""
    var address: String = ""
}
