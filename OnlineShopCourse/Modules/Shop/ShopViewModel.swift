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
    
    @Published var uploadProductStatus: ImageStatus = ImageStatus.none
    @Published var progressViewIsLoading: Bool = false
    @Published var showStatusAnimation: Bool = false
    
    init() {
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
                self.productImageService.downloadProductMainImage(product: product) { result in
                    switch result {
                    case .success(let image):
                        let product = ProductModel(product: product, productMainImage: image)
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
    
    // MARK: get product index in products
    func getIndex(product: ProductModel) -> Int {
        guard let index = products.firstIndex(where: { oneProduct in product.id == oneProduct.id })
        else { return 0 }
        return index
    }
    
    // MARK: get product images
    func getProductImages(product: ProductModel) {
        productImageService.downloadImagesLinks(product: product) { result in
            switch result {
            case .success(let links):
                links.forEach { link in
                    self.productImageService.downloadProductImage(imageLink: link) { result in
                        switch result {
                        case .success(let image):
                            self.products[self.getIndex(product: product)].images.append(image)
                        case .failure(_):
                            break
                        }
                    }
                }
            case .failure(_):
                break
            }
        }
    }
    
    // MARK: progress view loader
    private func progressViewLoader(deadLine: Double) {
        progressViewIsLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + deadLine) {
            if self.progressViewIsLoading { self.statusAnimationLoader() }
        }
    }
    
    // MARK: status animation loader
    private func statusAnimationLoader() {
        progressViewIsLoading = false
        showStatusAnimation = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.showStatusAnimation = false
            self.uploadProductStatus = ImageStatus.none
        }
    }
    
    // MARK: upload product to Firebase
    func uploadProduct(product: ProductModel) {
        progressViewLoader(deadLine: 60.0)
        productDataService.uploadProductData(product: product) { result in
            switch result {
            case .success(let product):
                self.productImageService.uploadAllProductImages(product: product) { result in
                    switch result {
                    case .success(_):
                        self.uploadProductStatus = ImageStatus.ok
                        self.statusAnimationLoader()
                    case .failure(_):
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
    
    // MARK: refresh shop
    func refreshShop() {
        resetProduct()
        products.removeAll()
        getProducts()
    }
    
    // MARK: check on product is valid
    var productValidity: Bool {
        guard let _ = Brands.init(rawValue: newProduct.brand),
              !newProduct.article.isEmpty,
              !newProduct.name.isEmpty,
              let _ = Double(newProduct.cost),
              !newProduct.description.isEmpty,
              !newProduct.images.isEmpty, let _ = newProduct.mainImage
        else { return false }
        return true
    }
    
    // MARK: set product
    func setProduct() -> ProductModel? {
        guard productValidity else { return nil }
        return ProductModel(
            article: newProduct.article,
            brand: Brands.init(rawValue: newProduct.brand)!,
            name: newProduct.name,
            description: newProduct.description,
            cost: Double(newProduct.cost)!,
            images: newProduct.images,
            mainImage: newProduct.mainImage)
    }
    
    // MARK: reset product
    func resetProduct() {
        newProduct.brand = ""
        newProduct.article = ""
        newProduct.name = ""
        newProduct.cost = ""
        newProduct.description = ""
        newProduct.mainImage = nil
        newProduct.images.removeAll()
    }
    
}
