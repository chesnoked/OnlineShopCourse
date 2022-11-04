//
//  OrderDataService.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 02.11.2022.
//

import Foundation
import FirebaseFirestore

class OrderDataService {
    
    static let shared: OrderDataService = OrderDataService()
    
    private let database = Firestore.firestore()
    
    private var orders: CollectionReference {
        return database.collection("orders")
    }
    
    // MARK: download all orders from Firebase Firestore
    func downloadOrders(user: UserModel, completion: @escaping (Result<[OrderModel], Error>) -> Void) {
        orders.getDocuments { querySnap, error in
            guard let querySnap = querySnap else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            var orders: [OrderModel] = []
            for document in querySnap.documents {
                if let order = OrderModel(doc: document) {
                    orders.append(order)
                }
            }
            completion(.success(orders))
        }
    }
    
    // MARK: upload order to Firebase Firestore
    func uploadOrder(order: OrderModel, completion: @escaping (Result<OrderModel, Error>) -> Void) {
        uploadOrderData(order: order) { result in
            switch result {
            case .success(let order):
                self.uploadOrderPositions(order: order) { result in
                    switch result {
                    case .success(let order):
                        completion(.success(order))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: upload order data to Firebase Firestore
    private func uploadOrderData(order: OrderModel, completion: @escaping (Result<OrderModel, Error>) -> Void) {
        orders.document(order.id).setData(order.data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(order))
            }
        }
    }
    
    // MARK: upload order positions to Firebase Firestore
    private func uploadOrderPositions(order: OrderModel, completion: @escaping (Result<OrderModel, Error>) -> Void) {
        let positions = orders.document(order.id).collection("positions")
        for position in order.positions {
            positions.document(position.id).setData(position.data) { error in
                if let error = error {
                    completion(.failure(error))
                }
            }
        }
        completion(.success(order))
    }
    
}
