//
//  GetHandicapToShow.swift
//  Fox19
//
//  Created by Артём Скрипкин on 23.04.2021.
//

import Foundation

class GetHandicapToShow {
    func callAsFunction(handicapFromServer: Double?) -> String? {
        guard let handicapFromServer = handicapFromServer else { return nil }
        guard handicapFromServer >= -10.0 && handicapFromServer <= 54.0 else { return nil }
        if handicapFromServer < 0 { return "+\(String(handicapFromServer * -1))" }
        return String(handicapFromServer)
    }
}
