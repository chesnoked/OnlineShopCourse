//
//  CartViewModel.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 25.10.2022.
//

import Foundation

class CartViewModel: ObservableObject {
    
    @Published var order: [PositionModel] = []
    
    // MARK: order total cost
    var total: Double {
        var total: Double = 0
        for position in order {
            total = total + position.cost
        }
        return total
    }
    
    // MARK: check on order is valid
    var orderValidity: Bool {
        return !order.isEmpty
    }
    
    // MARK: add to cart
    func addToCart(product: ProductModel, amount: UInt8) {
        let position = PositionModel(product: product, amount: amount)
        order.append(position)
    }
    
    // MARK: get position index in order
    func getPositionIndex(position: PositionModel) -> Int {
        guard let index = order.firstIndex(where: { onePosition in position.id == onePosition.id })
        else { return 0 }
        return index
    }
    
    // MARK: reset order
    func resetOrder() {
        order.removeAll()
    }
}
