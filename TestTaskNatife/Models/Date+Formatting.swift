//
//  CustomDateFormatter.swift
//  TestTaskNatife
//
//  Created by Ilya Tovstokory on 05.09.2023.
//

import Foundation

extension Date {
    var dateFormat: String {
        let dayText = formatted(.dateTime.day().month(.wide).year(.defaultDigits))
        let dayFormat = "%@"
        return String(format: dayFormat, dayText)
    }
}
