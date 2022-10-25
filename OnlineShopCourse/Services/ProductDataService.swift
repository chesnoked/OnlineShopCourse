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
    
    // MARK: download all products id from Firebase Firestore
    func downloadProductsID(completion: @escaping (Result<[String], Error>) -> Void) {
        productsID.getDocuments { querySnapshot, error in
            guard let querySnapshot = querySnapshot else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            var productsID: [String] = []
            let documents = querySnapshot.documents
            for document in documents {
                productsID.append(document.documentID)
            }
            completion(.success(productsID))
        }
    }
    
    // MARK: download product data from Firebase Firestore
    func downloadProductData(productID: String, completion: @escaping (Result<ProductModel, Error>) -> Void) {
        products.document(productID).getDocument { docSnapshot, error in
            guard let docSnapshot = docSnapshot else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            guard let data = docSnapshot.data() else { return }
            
            guard let id: String = data["id"] as? String,
                  let article: String = data["article"] as? String,
                  let categoryRawValue: String = data["category"] as? String,
                  let category: Categories = Categories.init(rawValue: categoryRawValue),
                  let brandRawValue: String = data["brand"] as? String,
                  let brand: Brands = Brands.init(rawValue: brandRawValue),
                  let name: String = data["name"] as? String,
                  let description: String = data["description"] as? String,
                  let cost: Double = data["cost"] as? Double
            else { return }
            
            let product: ProductModel = ProductModel(id: id, article: article, category: category, brand: brand, name: name, description: description, cost: cost)
            completion(.success(product))
        }
    }
    
    // MARK: upload product data to Firebase Firestore
    func uploadProductData(product: ProductModel, completion: @escaping (Result<ProductModel, Error>) -> Void) {
        products.document(product.id).setData(product.data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.productsID.document(product.id).setData([:]) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(product))
                    }
                }
            }
        }
    }
    
    // MARK: delete product data on Firebase Firestore
    func deleteProductData(product: ProductModel, completion: @escaping (Result<ProductModel, Error>) -> Void) {
        productsID.document(product.id).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.products.document(product.id).delete { error in
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
