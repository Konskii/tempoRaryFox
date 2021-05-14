//
//  ArrayGetElementSafelyExtension.swift
//  Fox19
//
//  Created by Артём Скрипкин on 08.04.2021.
//

import Foundation

extension Array {
    func getElement(index: Int) -> Element? {
        guard index < count else { return nil }
        return self[index]
    }
}
