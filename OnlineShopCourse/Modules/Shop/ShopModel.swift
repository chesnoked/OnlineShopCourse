//
//  ShopModel.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 16.10.2022.
//

import Foundation
import SwiftUI

enum Categories: String, CaseIterable {
    case category1 = "Category 1"
    case category2 = "Category 2"
    case category3 = "Category 3"
    case category4 = "Category 4"
    case category5 = "Category 5"
}

enum Brands: String, CaseIterable {
    case brand1 = "Brand 1"
    case brand2 = "Brand 2"
    case brand3 = "Brand 3"
    case brand4 = "Brand 4"
    case brand5 = "Brand 5"
}

struct ProductModel: Identifiable {
    
    let id: String
    var isFavorites: Bool
    let category: Categories?
    let brand: Brands?
    let name: String?
    let description: String?
    let cost: Double
    var images: [UIImage]
    let mainImage: UIImage?
    
    init(article: String, isFavorites: Bool = false, category: Categories? = nil, brand: Brands? = nil, name: String? = nil, description: String? = nil, cost: Double, images: [UIImage] = [], mainImage: UIImage? = nil) {
        self.id = article
        self.isFavorites = isFavorites
        self.category = category
        self.brand = brand
        self.name = name
        self.description = description
        self.cost = cost
        self.images = images
        self.mainImage = mainImage
    }
    
    init(product: ProductModel, productMainImage: UIImage) {
        self.init(article: product.id, isFavorites: product.isFavorites, category: product.category, brand: product.brand, name: product.name, description: product.description, cost: product.cost, images: product.images, mainImage: productMainImage)
    }
    
    var data: [String:Any] {
        var data: [String:Any] = [:]
        data["article"] = id
        data["category"] = category?.rawValue ?? ""
        data["brand"] = brand?.rawValue ?? ""
        data["name"] = name ?? ""
        data["description"] = description ?? ""
        data["cost"] = cost
        return data
    }
}

struct NewProduct {
    var category: String = ""
    var brand: String = ""
    var article: String = ""
    var name: String = ""
    var cost: String = ""
    var description: String = ""
    var images: [UIImage] = []
    var mainImage: UIImage? = nil
}
