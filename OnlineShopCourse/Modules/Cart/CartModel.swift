//
//  CartModel.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 25.10.2022.
//

import Foundation

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
