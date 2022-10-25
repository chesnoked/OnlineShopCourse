//
//  CartViewModel.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 25.10.2022.
//

import Foundation

class CartViewModel: ObservableObject {
    
    @Published var order: [PositionModel] = []
    
    // add to cart
    func addToCart(product: ProductModel, amount: UInt8) {
        let position = PositionModel(product: product, amount: amount)
        order.append(position)
    }
}
