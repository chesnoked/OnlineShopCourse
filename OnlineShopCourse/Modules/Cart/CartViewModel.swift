//
//  CartViewModel.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 25.10.2022.
//

import Foundation

class CartViewModel: ObservableObject {
    
    private let userDataService = UserDataService.shared
    private let orderDataService = OrderDataService.shared
    
    @Published var orderDetails: OrderDetails = OrderDetails()
    @Published var positions: [PositionModel] = []
    
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
    
    // MARK: get position index in order
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
        guard let user = getUser() else { return }
        userDataService.uploadUserData(user: user) { result in
            switch result {
            case .success(let user):
                let order = OrderModel(user: user, positions: self.positions, notes: self.orderDetails.notes)
                self.orderDataService.uploadOrder(order: order) { result in
                    switch result {
                    case .success(let order):
                        print("Successfully uploaded order: \(order.number)")
                    case .failure(_):
                        break
                    }
                }
            case .failure(_):
                break
            }
        }
    }
    
    // MARK: reset order
    func resetOrder() {
        positions.removeAll()
    }
}
