//
//  ShopViewModel.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 16.10.2022.
//

import Foundation

class ShopViewModel: ObservableObject {
    
    @Published var products: [ProductModel] = []
    
    init() {
        getProducts()
    }
    
    private func getProducts() {
        
        let product1 = ProductModel(image: "1")
        let product2 = ProductModel(image: "2")
        let product3 = ProductModel(image: "3")
        let product4 = ProductModel(image: "4")
        let product5 = ProductModel(image: "5")
        let product6 = ProductModel(image: "6")
        let product7 = ProductModel(image: "7")
        let product8 = ProductModel(image: "8")
        let product9 = ProductModel(image: "9")
        let product10 = ProductModel(image: "10")
        
        products.append(contentsOf: [
            product1,
            product2,
            product3,
            product4,
            product5,
            product6,
            product7,
            product8,
            product9,
            product10
        ])
    }
}
