//
//  GetHandicapForServer.swift
//  Fox19
//
//  Created by Артём Скрипкин on 23.04.2021.
//

import Foundation

class GetHandicapForServer {
    func callAsFunction(handicapToShow: String) -> Double? {
        guard var doubleHandicap = Double(handicapToShow) else { return nil }
        if handicapToShow.contains("+") {
            doubleHandicap = doubleHandicap * -1
        }
        return doubleHandicap
    }
}
