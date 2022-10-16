//
//  Double.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 16.10.2022.
//

import Foundation

extension Double {
    func twoDecimalPlaces() -> String {
        return String(format: "%.2f", self)
    }
}
