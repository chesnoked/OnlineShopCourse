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
    
    // upload product image
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
    
    // delete product images
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
