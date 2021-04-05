//
//  MemberedClubsModel.swift
//  Fox19
//
//  Created by Артём Скрипкин on 05.04.2021.
//

struct MemberedClubsModel: Codable {
    let results: [MemberedClub]
}

struct MemberedClub: Codable {
    let club: Club
    let userName: String
}
