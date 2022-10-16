//
//  ShopModel.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 16.10.2022.
//

import Foundation

enum Brands: String {
    case brand1 = "Brand 1"
    case brand2 = "Brand 2"
    case brand3 = "Brand 3"
    case brand4 = "Brand 4"
    case brand5 = "Brand 5"
}

struct ProductModel: Identifiable {
    let id: String
    let article: String
    let brand: Brands
    let name: String
    let description: String
    let cost: Double
    let image: String
    
    init(id: String = UUID().uuidString, article: String, brand: Brands, name: String, description: String, cost: Double, image: String) {
        self.id = id
        self.article = article
        self.brand = brand
        self.name = name
        self.description = description
        self.cost = cost
        self.image = image
    }
    
}
