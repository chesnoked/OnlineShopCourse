//
//  CartViewModel.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 25.10.2022.
//

import Foundation

class CartViewModel: ObservableObject {
    
    @Published var order: [PositionModel] = []
    
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
}
