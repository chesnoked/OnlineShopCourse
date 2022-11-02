//
//  CartModel.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 25.10.2022.
//

import Foundation

// MARK: position
struct PositionModel: Identifiable {
    
    let id: String
    let product: ProductModel
    var amount: UInt8
    var cost: Double {
        return product.cost * Double(amount)
    }
    
    init(id: String = UUID().uuidString, product: ProductModel, amount: UInt8) {
        self.id = id
        self.product = product
        self.amount = amount
    }
}

// MARK: order
struct OrderDetails {
    var email: String = ""
    var secondName: String = ""
    var firstName: String = ""
    var thirdName: String = ""
    var phone: String = ""
    var index: String = ""
    var country: String = ""
    var city: String = ""
    var address: String = ""
    var notes: String = ""
}

struct OrderModel: Identifiable {
    let id: String
    let number: String
    let date: Date
    let user: UserModel
    let positions: [PositionModel]
    let notes: String
}
