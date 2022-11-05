//
//  Date.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 05.11.2022.
//

import Foundation

extension Date {
    var shortFormat: String {
        self.formatted(
            .dateTime
                .day(.twoDigits)
                .month(.abbreviated)
//                .year(.twoDigits)
                .minute(.twoDigits)
                .hour(.conversationalDefaultDigits(amPM: .omitted))
        )
    }
}
