//
//  CartModel.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 25.10.2022.
//

import Foundation
import FirebaseFirestore

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
    
    var data: [String:Any] {
        var data: [String:Any] = [:]
        data["product_article"] = product.article
        data["product_name"] = product.name
        data["product_cost"] = product.cost
        data["amount"] = amount
        data["cost"] = cost
        return data
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

struct OrderModel {
    
    let number: String
    let date: Date
    let user: UserModel
    let positions: [PositionModel]
    let notes: String
    
    init(number: String = String((1000000...9999999).randomElement()!), date: Date = Date(), user: UserModel, positions: [PositionModel], notes: String) {
        self.number = number
        self.date = date
        self.user = user
        self.positions = positions
        self.notes = notes
    }
    
    var total: Double {
        var total: Double = 0
        for position in positions {
            total = total + position.cost
        }
        return total
    }
    
    var data: [String:Any] {
        var data: [String:Any] = [:]
        data["number"] = number
        data["date"] = Timestamp(date: date)
        data["user_id"] = user.email
        data["total"] = total
        data["notes"] = notes
        return data
    }
    
}
