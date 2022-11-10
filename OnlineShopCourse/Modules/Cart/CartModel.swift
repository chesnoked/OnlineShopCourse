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
    
    let id: String = UUID().uuidString
    let product: ProductModel
    var amount: UInt8
    var cost: Double {
        return product.cost * Double(amount)
    }
    
    init(product: ProductModel, amount: UInt8) {
        self.product = product
        self.amount = amount
    }
    
    init?(doc: QueryDocumentSnapshot) {
        let data = doc.data()
        
        guard let productArticle = data["product_article"] as? String,
              let productCost = data["product_cost"] as? Double,
              let amount = data["amount"] as? UInt8
        else { return nil }
        
        self.product = ProductModel(article: productArticle, cost: productCost)
        self.amount = amount
    }
    
    var data: [String:Any] {
        var data: [String:Any] = [:]
        data["product_article"] = product.id
        data["product_cost"] = product.cost
        data["amount"] = amount
        return data
    }
}

// MARK: order

enum OrderStatus: String, CaseIterable {
    // 1. Новый заказ. Ожидает подтверждения.
    case new = "На подтверждении."
    // 2. Заказ подтверждён и ожидает оплаты.
    case paying = "Подтвержден и ожидает оплаты."
    // 3. Оплачен.
    case paid = "Оплачен и готовится к отправке."
    // 4. Готовится к отправке (на сборке).
    case building = "Готовится к отправке. На сборке."
    // 5. Отправлен.
    case sent = "Отправлен."
    // 6. Доставлен (до пункта выдачи).
    case delivered = "Доставлен до пункта."
    // 7. Получен (абонентом).
    case get = "Получен."
    // 8. Выполнен.
    case completed = "Выполнен."
}

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
    let date: Date
    let user: UserModel
    var positions: [PositionModel] = []
    let notes: String
    var status: OrderStatus
    
    var total: Double {
        var total: Double = 0
        for position in positions {
            total = total + position.cost
        }
        return total
    }
    
    init(number: String = String((1000000...9999999).randomElement()!), date: Date = Date(), user: UserModel, positions: [PositionModel], notes: String, status: OrderStatus = OrderStatus.new) {
        self.id = number
        self.date = date
        self.user = user
        self.positions = positions
        self.notes = notes
        self.status = status
    }
    
    init?(doc: QueryDocumentSnapshot) {
        let data = doc.data()
        
        guard let id = data["number"] as? String,
              let date = data["date"] as? Timestamp,
              let userID = data["user_id"] as? String,
              let notes = data["notes"] as? String,
              let statusRawValue = data["status"] as? String,
              let status = OrderStatus.init(rawValue: statusRawValue)
        else { return nil }
        
        self.id = id
        self.date = date.dateValue()
        self.user = UserModel(email: userID)
        self.notes = notes
        self.status = status
    }
    
    var data: [String:Any] {
        var data: [String:Any] = [:]
        data["number"] = id
        data["date"] = Timestamp(date: date)
        data["user_id"] = user.email
        data["notes"] = notes
        data["status"] = status.rawValue
        return data
    }
    
}
