//
//  ProfileViewModel.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 11.11.2022.
//

import Foundation

class ProfileViewModel: ObservableObject {
    
    init() {
        getOrders()
    }
    
    private let userDataService = UserDataService.shared
    private let orderDataService = OrderDataService.shared
    
    @Published var orders: [OrderModel] = []
    
    // MARK: download orders
    func getOrders() {
        guard let user = userDataService.currentUser else { return }
        orderDataService.downloadOrders(user: user) { result in
            switch result {
            case .success(let orders):
                self.orders = orders
                for (index, order) in self.orders.enumerated() {
                    self.orderDataService.downloadOrderPositions(order: order) { result in
                        switch result {
                        case .success(let positions):
                            self.orders[index].positions = positions
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
    
    // MARK: get order index in orders
    func getOrderIndex(order: OrderModel) -> Int {
        guard let index = orders.firstIndex(where: { oneOrder in order.id == oneOrder.id })
        else { return 0 }
        return index
    }
}
