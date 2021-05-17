//
//  TournamentJoinModel.swift
//  Fox19
//
//  Created by Евгений Скрипкин on 17.05.2021.
//

import Foundation

struct TournamentJoinModel: Codable {
    let status: String
    let user, championship: UserID
}
