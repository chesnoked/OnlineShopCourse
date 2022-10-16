//
//  ProductDataService.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 16.10.2022.
//

import Foundation
import FirebaseFirestore

class ProductDataService {
    
    static let shared: ProductDataService = ProductDataService()
    
    private let database = Firestore.firestore()
    
    private var productsID: CollectionReference {
        return database.collection("products_id")
    }
    
    private var products: CollectionReference {
        return database.collection("products")
    }
    
    // upload product data
    func uploadProductData(product: ProductModel, completion: @escaping (Result<ProductModel, Error>) -> Void) {
        productsID.document(product.id).setData([:]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.products.document(product.id).setData(product.data) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(product))
                    }
                }
            }
        }
    }
    
    
}
