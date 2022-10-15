//
//  ShopModel.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 16.10.2022.
//

import Foundation

struct ProductModel: Identifiable {
    let id: String
    let image: String
    
    init(id: String = UUID().uuidString, image: String) {
        self.id = id
        self.image = image
    }
}
