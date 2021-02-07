//
//  EditGameUpdateModel.swift
//  Fox19
//
//  Created by Артём Скрипкин on 26.11.2020.
//

struct EditGameUpdateModel: Codable {
    let date, description, time: String
    let guestPrice, memberPrice, club, holes, gamersCount: Int
}
