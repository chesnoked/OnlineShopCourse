//
//  Date.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 05.11.2022.
//

import Foundation

extension Date {
    var shortFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM HH:mm"
        return dateFormatter.string(from: self)
    }
}
