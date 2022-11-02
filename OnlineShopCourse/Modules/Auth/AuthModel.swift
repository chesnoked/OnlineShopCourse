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
}

struct AuthFields {
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
}

struct UserModel {
    
    let email: String
    let secondName: String?
    let firstName: String?
    let thirdName: String?
    let phone: String?
    let index: String?
    let country: String?
    let city: String?
    let address: String?
    
    init(email: String, secondName: String? = nil, firstName: String? = nil, thirdName: String? = nil, phone: String? = nil, index: String? = nil, country: String? = nil, city: String? = nil, address: String? = nil) {
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
    
    var data: [String:Any] {
        var data: [String:Any] = [:]
        data["email"] = email
        data["second_name"] = secondName ?? ""
        data["first_name"] = firstName ?? ""
        data["third_name"] = thirdName ?? ""
        data["phone"] = phone ?? ""
        data["index"] = index ?? ""
        data["country"] = country ?? ""
        data["city"] = city ?? ""
        data["address"] = address ?? ""
        return data
    }
}
