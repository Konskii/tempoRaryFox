//
//  Double+extension.swift
//  Fox19
//
//  Created by Артём Скрипкин on 12.03.2021.
//

import Foundation

extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        return String(formatter.string(from: number) ?? "")
    }
}
