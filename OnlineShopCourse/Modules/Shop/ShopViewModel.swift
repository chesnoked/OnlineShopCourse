//
//  ShopViewModel.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 16.10.2022.
//

import Foundation
import Combine

class ShopViewModel: ObservableObject {
    
    init() {
        getProducts()
        shopBarActions()
    }
    
    private let productDataService = ProductDataService.shared
    private let productImageService = ProductImageService.shared
    private let userDataService = UserDataService.shared
    
    @Published var newProduct: NewProduct = NewProduct()
    @Published var originalProducts: [ProductModel] = []
    private var favoriteList: [String] = []
    
    private var subscription: AnyCancellable?
    @Published var uploadProductStatus: ImageStatus = ImageStatus.none
    @Published var progressViewIsLoading: Bool = false
    @Published var showStatusAnimation: Bool = false
    
    @Published var shopBarSelectedOption: ShopBarOptions = .byName
    @Published var searchText: String = ""
    @Published var currentProducts: [ProductModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    private var categoriesSubscription: AnyCancellable?
    @Published var selectedCategory: Categories? = nil
    
    private var brandsSubscription: AnyCancellable?
    @Published var selectedBrand: Brands? = nil
    
    // MARK: filter by category
    private func filterByCategory() {
        categoriesSubscription = $selectedCategory
            .combineLatest($originalProducts)
            .map({ (category, products) -> [ProductModel] in
                guard let selectedCategory = category else { return self.sortedByCategories(products: products) }
                return products.filter { product in
                    guard let productCategory = product.category else { return false }
                    return productCategory == selectedCategory
                }
            })
            .sink(receiveValue: { filteredProducts in
                self.currentProducts = filteredProducts
            })
    }
    
    // MARK: filter by brand
    private func filterByBrand() {
        brandsSubscription = $selectedBrand
            .combineLatest($originalProducts)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map { (brand, products) -> [ProductModel] in
                guard let selectedBrand = brand else { return self.sortedByBrands(products: products) }
                return products.filter { product in
                    guard let productBrand = product.brand else { return false }
                    return productBrand == selectedBrand
                }
            }
            .sink { filteredProducts in
                self.currentProducts = filteredProducts
            }
    }
    
    // MARK: shop bar actions
    private func shopBarActions() {
        $shopBarSelectedOption
            .combineLatest($searchText, $originalProducts)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map { (option, searchText, products) -> [ProductModel] in
                if option != .byCategory { self.categoriesSubscription?.cancel() }
                if option != .byBrand { self.brandsSubscription?.cancel() }
                switch option {
                case .byFavorites:
                    return self.filterByFavorites(products: products)
                case .byName:
                    return self.sortedByName(products: products)
                case .byCategory:
                    self.filterByCategory()
                    return self.currentProducts
                case .byBrand:
                    self.filterByBrand()
                    return self.currentProducts
                case .news:
                    return self.sortedByDate(products: products)
                case .search:
                    return self.searchProducts(searchText: searchText, products: products)
                }
            }
            .sink { filteredProducts in
                self.currentProducts = filteredProducts
            }
            .store(in: &cancellables)
    }
    
    // MARK: filter by favorites
    private func filterByFavorites(products: [ProductModel]) -> [ProductModel] {
        return products.filter { product in product.isFavorites }
    }
    
    // MARK: sorted by name
    private func sortedByName(products: [ProductModel]) -> [ProductModel] {
        return products.sorted { lastProduct, nextProduct in
            guard let nameLastProduct = lastProduct.name,
                  let nameNextProduct = nextProduct.name
            else { return false }
            return nameLastProduct < nameNextProduct
        }
    }
    
    // MARK: sorted by brands
    private func sortedByBrands(products: [ProductModel]) -> [ProductModel] {
        return products.sorted { lastProduct, nextProduct in
            guard let brandLastProduct = lastProduct.brand?.rawValue,
                  let brandNextProduct = nextProduct.brand?.rawValue
            else { return false }
            return brandLastProduct < brandNextProduct
        }
    }
    
    // MARK: sorted by categories
    private func sortedByCategories(products: [ProductModel]) -> [ProductModel] {
        return products.sorted { lastProduct, nextProduct in
            guard let categoryLastProduct = lastProduct.category?.rawValue,
                  let categoryNextProduct = nextProduct.category?.rawValue
            else { return false }
            return categoryLastProduct < categoryNextProduct
        }
    }
    
    // MARK: sorted by date
    private func sortedByDate(products: [ProductModel]) -> [ProductModel] {
        return products.sorted { lastProduct, nextProduct in
            lastProduct.date > nextProduct.date
        }
    }
    
    // MARK: search products
    private func searchProducts(searchText: String, products: [ProductModel]) -> [ProductModel] {
        guard !searchText.isEmpty else { return products }
        var foundProducts = products
        let keyWords = getSeparateWordsFromString(text: searchText)
        for keyWord in keyWords {
            foundProducts = foundProducts.filter({ product in
                guard let name = product.name,
                      let description = product.description
                else { return false }
                return name.lowercased().contains(keyWord.lowercased()) || description.lowercased().contains(keyWord.lowercased())
            })
        }
        return foundProducts
    }
    
    // MARK: get separate words from string
    private func getSeparateWordsFromString(text: String) -> [String] {
        var tempString = text
        var keyWord: String
        var keyWords: [String] = []
        while !tempString.isEmpty {
            let firstCharIndexOfString = tempString.startIndex
            if let spaceSymbolIndexOfString = tempString.firstIndex(of: " ") {
                keyWord = String(tempString[firstCharIndexOfString..<spaceSymbolIndexOfString])
                tempString = String(tempString[tempString.index(after: spaceSymbolIndexOfString)...])
                if !keyWord.isEmpty { keyWords.append(keyWord) }
            } else {
                keyWord = tempString
                keyWords.append(keyWord)
                tempString.removeAll()
            }
        }
        return keyWords
    }
    
    // MARK: Loader
    private func loader(deadLine: Double) {
        progressViewLoader(deadLine: deadLine)
        subscription = $uploadProductStatus
            .sink { status in
                if status == .ok {
                    self.statusAnimationLoader()
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
        subscription?.cancel()
        progressViewIsLoading = false
        showStatusAnimation = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.showStatusAnimation = false
            self.uploadProductStatus = ImageStatus.none
        }
    }
    
    // MARK: upload product to Firebase
    func uploadProduct(product: ProductModel) {
        loader(deadLine: 30.0)
        productDataService.uploadProductData(product: product) { result in
            switch result {
            case .success(let product):
                self.productImageService.uploadAllProductImages(product: product) { result in
                    switch result {
                    case .success(_):
                        self.uploadProductStatus = ImageStatus.ok
                    case .failure(_):
                        self.deleteProduct(product: product)
                    }
                }
            case .failure(_):
                break
            }
        }
    }
    
    // MARK: get products from Firebase
    func getProducts() {
        userDataService.downloadFavoriteList { result in
            switch result {
            case .success(let list):
                self.favoriteList = list
                self.productDataService.downloadProductsID { result in
                    switch result {
                    case .success(let productsID):
                        for productID in productsID {
                            self.getProduct(productID: productID)
                        }
                    case .failure(_):
                        break
                    }
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
                        var product = ProductModel(product: product, productMainImage: image)
                        if self.favoriteList.contains(product.id) { product.isFavorites = true }
                        self.originalProducts.append(product)
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
    func getProductIndex(product: ProductModel) -> Int {
        guard let index = originalProducts.firstIndex(where: { oneProduct in product.id == oneProduct.id })
        else { return 0 }
        return index
    }
    
    // MARK: add product to favorites
    func addToFavorites(product: ProductModel) {
        userDataService.addProductToFavorites(product: product) { result in
            switch result {
            case .success(let product):
                self.originalProducts[self.getProductIndex(product: product)].isFavorites.toggle()
            case .failure(_):
                break
            }
        }
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
                            self.originalProducts[self.getProductIndex(product: product)].images.append(image)
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
        originalProducts.removeAll()
        getProducts()
    }
    
    // MARK: check on product is valid
    var productValidity: Bool {
        guard let _ = Categories.init(rawValue: newProduct.category),
              let _ = Brands.init(rawValue: newProduct.brand),
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
            category: Categories.init(rawValue: newProduct.category)!,
            brand: Brands.init(rawValue: newProduct.brand)!,
            name: newProduct.name,
            description: newProduct.description,
            cost: Double(newProduct.cost)!,
            images: newProduct.images,
            mainImage: newProduct.mainImage)
    }
    
    // MARK: reset product
    func resetProduct() {
        newProduct.category = ""
        newProduct.brand = ""
        newProduct.article = ""
        newProduct.name = ""
        newProduct.cost = ""
        newProduct.description = ""
        newProduct.mainImage = nil
        newProduct.images.removeAll()
    }
    
}
