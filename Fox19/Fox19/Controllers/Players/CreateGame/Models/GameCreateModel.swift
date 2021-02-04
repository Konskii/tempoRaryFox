//
//  GameCreateModel.swift
//  Fox19
//
//  Created by Артём Скрипкин on 17.11.2020.

struct GameCreateModel: Codable {
    let date, description, time, name: String
    let guestPrice, memberPrice, userId, clubId, holes, gamersCount: Int
    let reserved: Bool
}
