//
//  ShopModel.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 16.10.2022.
//

import Foundation
import SwiftUI

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
    let imageFromAssets: String
    let image: UIImage?
    
    init(id: String = UUID().uuidString, article: String, brand: Brands, name: String, description: String, cost: Double, imageFromAssets: String, image: UIImage? = nil) {
        self.id = id
        self.article = article
        self.brand = brand
        self.name = name
        self.description = description
        self.cost = cost
        self.imageFromAssets = imageFromAssets
        self.image = image
    }
    
    init(product: ProductModel, productImage: UIImage) {
        self.init(id: product.id, article: product.article, brand: product.brand, name: product.name, description: product.description, cost: product.cost, imageFromAssets: product.imageFromAssets, image: productImage)
    }
    
    var data: [String:Any] {
        var data: [String:Any] = [:]
        data["id"] = id
        data["article"] = article
        data["brand"] = brand.rawValue
        data["name"] = name
        data["description"] = description
        data["cost"] = cost
        data["imageFromAssets"] = imageFromAssets
        return data
    }
    
    var imageData: Data {
        return UIImage(named: imageFromAssets)!.jpegData(compressionQuality: 0.5)!
    }
    
}
