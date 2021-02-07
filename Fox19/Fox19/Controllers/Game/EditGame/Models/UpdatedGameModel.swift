//
//  UpdatedGameModel.swift
//  Fox19
//
//  Created by Артём Скрипкин on 26.11.2020.
//

import Foundation
struct UpdatedGameModel: Codable {
    let club: UpdatedGameClubId?
    let date: String?
    let description: String?
    let gamersCount: String?
    let guestPrice: String?
    let holes: String?
    let id: Int?
    let memberPrice: String?
    let reserved: Bool?
    let title: String?
    let user: ClubID?
}

struct UpdatedGameClubId: Codable {
    let id: String?
}
