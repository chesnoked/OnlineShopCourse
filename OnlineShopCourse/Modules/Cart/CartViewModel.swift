//
//  CartViewModel.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 25.10.2022.
//

import Foundation
import Combine

class CartViewModel: ObservableObject {
    
    private let userDataService = UserDataService.shared
    private let orderDataService = OrderDataService.shared
    
    @Published var orderDetails: OrderDetails = OrderDetails()
    @Published var positions: [PositionModel] = []
    
    private var subscription: AnyCancellable?
    @Published var uploadOrderStatus: ImageStatus = ImageStatus.none
    @Published var progressViewIsLoading: Bool = false
    @Published var showStatusAnimation: Bool = false
    
    // MARK: Loader
    private func loader(deadLine: Double) {
        progressViewLoader(deadLine: deadLine)
        subscription = $uploadOrderStatus
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
            self.uploadOrderStatus = ImageStatus.none
        }
    }
    
    // MARK: order total cost
    var total: Double {
        var total: Double = 0
        for position in positions {
            total = total + position.cost
        }
        return total
    }
    
    // MARK: check on order is valid
    var orderValidity: Bool {
        guard !orderDetails.secondName.isEmpty,
              !orderDetails.firstName.isEmpty,
              !orderDetails.thirdName.isEmpty,
              !orderDetails.email.isEmpty,
              !orderDetails.phone.isEmpty,
              !orderDetails.index.isEmpty,
              !orderDetails.country.isEmpty,
              !orderDetails.city.isEmpty,
              !orderDetails.address.isEmpty
        else { return false }
        return true
    }
    
    // MARK: add to cart
    func addToCart(product: ProductModel, amount: UInt8) {
        let position = PositionModel(product: product, amount: amount)
        positions.append(position)
    }
    
    // MARK: get position index in positions
    func getPositionIndex(position: PositionModel) -> Int {
        guard let index = positions.firstIndex(where: { onePosition in position.id == onePosition.id })
        else { return 0 }
        return index
    }
    
    // MARK: get user details
    private func getUser() -> UserModel? {
        guard orderValidity else { return nil }
        return UserModel(email: orderDetails.email,
                         secondName: orderDetails.secondName,
                         firstName: orderDetails.firstName,
                         thirdName: orderDetails.thirdName,
                         phone: orderDetails.phone,
                         index: orderDetails.index,
                         country: orderDetails.country,
                         city: orderDetails.city,
                         address: orderDetails.address)
    }
    
    // MARK: upload order
    func uploadOrder() {
        loader(deadLine: 30.0)
        guard let user = getUser() else { return }
        userDataService.uploadUserData(user: user) { result in
            switch result {
            case .success(let user):
                let order = OrderModel(user: user, positions: self.positions, notes: self.orderDetails.notes)
                self.orderDataService.uploadOrder(order: order) { result in
                    switch result {
                    case .success(let order):
                        self.uploadOrderStatus = ImageStatus.ok
                        self.positions.removeAll()
                        print("Successfully uploaded order: \(order.id)")
                    case .failure(_):
                        break
                    }
                }
            case .failure(_):
                break
            }
        }
    }
    
}
