//
//  MemberedClubsModel.swift
//  Fox19
//
//  Created by Артём Скрипкин on 05.04.2021.
//

struct MemberedClubsModel: Codable {
    let results: [MemberedClubModel]
}

struct MemberedClubModel: Codable {
    let club: Club
    let userName: String
}

struct JoinClubModel: Codable {
    let club: Int
}
