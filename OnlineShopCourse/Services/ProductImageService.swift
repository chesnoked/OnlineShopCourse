//
//  ProductImageService.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 17.10.2022.
//

import Foundation
import FirebaseStorage

class ProductImageService {
    
    static let shared: ProductImageService = ProductImageService()
    
    private let storage = Storage.storage().reference()
    
    private var images: StorageReference {
        return storage.child("products")
    }
    
    // MARK: download product image from Firebase Storage
    func downloadProductImage(product: ProductModel, completion: @escaping (Result<UIImage, Error>) -> Void) {
        images.child(product.id).child(product.id).getData(maxSize: 3 * 1024 * 1024) { data, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            guard let image = UIImage(data: data) else { return }
            completion(.success(image))
        }
    }
    
    // MARK: upload product image to Firebase Storage
    func uploadProductImage(product: ProductModel, completion: @escaping (Result<ProductModel, Error>) -> Void) {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        images.child(product.id).child(product.id).putData(product.imageData, metadata: metadata) { metadata, error in
            guard let _ = metadata else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(product))
        }
    }
    
    // MARK: delete product images on Firebase Storage
    func deleteProductImages(product: ProductModel) {
        images.child(product.id).listAll { storageListResult, error in
            guard let list = storageListResult else {
                if let _ = error {
                    // print
                }
                return
            }
            list.items.forEach { link in
                link.delete { error in
                    if let _ = error {
                        // print
                    }
                }
            }
        }
    }
    
    
}
