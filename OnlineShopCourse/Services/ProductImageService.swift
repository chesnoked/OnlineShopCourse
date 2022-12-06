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
    
    // MARK: upload all product images
    func uploadAllProductImages(product: ProductModel, completion: @escaping (Result<ProductModel, Error>) -> Void) {
        uploadProductMainImage(product: product) { result in
            switch result {
            case .success(let product):
                self.uploadProductImages(product: product) { result in
                    switch result {
                    case .success(let product):
                        completion(.success(product))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: upload product main image to Firebase Storage
    func uploadProductMainImage(product: ProductModel, completion: @escaping (Result<ProductModel, Error>) -> Void) {
        guard let image = product.mainImage,
              let imageData = image.jpegData(compressionQuality: 0.12)
        else { return }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        images.child("main").child(product.id).putData(imageData, metadata: metadata) { metadata, error in
            guard let _ = metadata else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(product))
        }
    }
    
    // MARK: download product main image from Firebase Storage
    func downloadProductMainImage(product: ProductModel, completion: @escaping (Result<UIImage, Error>) -> Void) {
        images.child("main").child(product.id).getData(maxSize: 3 * 1024 * 1024) { data, error in
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
    
    // MARK: download product image from Firebase Storage
    func downloadProductImage(imageLink: StorageReference, completion: @escaping (Result<UIImage, Error>) -> Void) {
        imageLink.getData(maxSize: 3 * 1024 * 1024) { data, error in
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
    
    // MARK: download product all images links from Firebase Storage
    func downloadImagesLinks(product: ProductModel, completion: @escaping (Result<[StorageReference], Error>) -> Void) {
        images.child(product.id).listAll { storageListResult, error in
            guard let list = storageListResult else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(list.items))
        }
    }
    
    // MARK: upload product images to Firebase Storage
    func uploadProductImages(product: ProductModel, completion: @escaping (Result<ProductModel, Error>) -> Void) {
        guard !product.images.isEmpty else { return }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        product.images.forEach { image in
            guard let imageData = image.jpegData(compressionQuality: 0.12) else { return }
            images.child(product.id).child(UUID().uuidString).putData(imageData, metadata: metadata) { metadata, error in
                guard let _ = metadata else {
                    if let error = error {
                        completion(.failure(error))
                    }
                    return
                }
                completion(.success(product))
            }
        }
    }
    
    // MARK: delete all product images on Firebase Storage
    func deleteProductImages(product: ProductModel) {
        images.child("main").child(product.id).delete { _ in }
        downloadImagesLinks(product: product) { result in
            switch result {
            case .success(let links):
                links.forEach { link in
                    link.delete { _ in }
                }
            case .failure(_):
                break
            }
        }
    }
}
