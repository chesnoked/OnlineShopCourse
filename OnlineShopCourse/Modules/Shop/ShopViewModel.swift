//
//  ShopViewModel.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 16.10.2022.
//

import Foundation

class ShopViewModel: ObservableObject {
    
    private let productDataService = ProductDataService.shared
    private let productImageService = ProductImageService.shared
    
    @Published var newProduct: NewProduct = NewProduct()
    @Published var products: [ProductModel] = []
    
    init() {
//        getLocalProducts()
        getProducts()
    }
    
    // MARK: get products from Firebase
    func getProducts() {
        productDataService.downloadProductsID { result in
            switch result {
            case .success(let productsID):
                for productID in productsID {
                    self.getProduct(productID: productID)
                }
            case .failure(_):
                break
            }
        }
    }
    
    // MARK: get product from Firebase
    func getProduct(productID: String) {
        productDataService.downloadProductData(productID: productID) { result in
            switch result {
            case .success(let product):
                self.productImageService.downloadProductImage(product: product) { result in
                    switch result {
                    case .success(let image):
                        let product: ProductModel = ProductModel(product: product, productImage: image)
                        self.products.append(product)
                    case .failure(_):
                        break
                    }
                }
            case .failure(_):
                break
            }
        }
    }
    
    // MARK: upload product to Firebase
    func uploadProduct(product: ProductModel) {
        productImageService.uploadProductImage(product: product) { result in
            switch result {
            case .success(let product):
                self.productDataService.uploadProductData(product: product) { result in
                    switch result {
                    case .success(let product):
                        print("Successfully uploaded product: \(product.id)")
                    case .failure(let error):
                        print("Error uploading product: \(product.id) : \(error.localizedDescription)")
                        self.deleteProduct(product: product)
                    }
                }
            case .failure(_):
                break
            }
        }
    }
    
    // MARK: delete product on Firebase
    func deleteProduct(product: ProductModel) {
        productDataService.deleteProductData(product: product) { result in
            switch result {
            case .success(let product):
                self.productImageService.deleteProductImages(product: product)
            case .failure(_):
                break
            }
        }
    }
    
    // MARK: Reset product
    func resetProduct() {
        newProduct.brand = ""
        newProduct.article = ""
        newProduct.name = ""
        newProduct.cost = ""
        newProduct.description = ""
        newProduct.images.removeAll()
    }
    
    // MARK: Get local products
    private func getLocalProducts() {
        
        let product1 = ProductModel(article: "000001", brand: .brand1, name: "Product 1", description: "description", cost: 5432.32, imageFromAssets: "1")
        let product2 = ProductModel(article: "000002", brand: .brand2, name: "Product 2", description: "description", cost: 3432, imageFromAssets: "2")
        let product3 = ProductModel(article: "000003", brand: .brand2, name: "Product 3", description: "description", cost: 7811.12, imageFromAssets: "3")
        let product4 = ProductModel(article: "000004", brand: .brand3, name: "Product 4", description: "description", cost: 6000, imageFromAssets: "4")
        let product5 = ProductModel(article: "000005", brand: .brand1, name: "Product 5", description: "description", cost: 3100.00, imageFromAssets: "5")
        let product6 = ProductModel(article: "000006", brand: .brand5, name: "Product 6", description: "description", cost: 12333.00, imageFromAssets: "6")
        let product7 = ProductModel(article: "000007", brand: .brand3, name: "Product 7", description: "description", cost: 8900, imageFromAssets: "7")
        let product8 = ProductModel(article: "000008", brand: .brand3, name: "Product 8", description: "description", cost: 1200, imageFromAssets: "8")
        let product9 = ProductModel(article: "000009", brand: .brand4, name: "Product 9", description: "description", cost: 350, imageFromAssets: "9")
        let product10 = ProductModel(article: "0000010", brand: .brand2, name: "Product 10", description: "description", cost: 500, imageFromAssets: "10")
        
        
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
