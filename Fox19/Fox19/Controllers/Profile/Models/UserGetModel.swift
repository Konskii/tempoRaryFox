//
//  UserGetModel.swift
//  Fox19
//
//  Created by Артём Скрипкин on 04.11.2020.
//
// MARK: - GetUserResponse. Данную модель не изменять!
struct GetUserResponse: Codable {
    let results: [User]?
}

// MARK: - User
struct User: Codable {
    let id: Int?
    let phone, email, golfRegistryIdRU, about, name: String?
    let handicap: Double?
    let isAdmin, isReferee, isGamer, isTrainer: Bool?
    let avatar: Avatar?
    
    struct Avatar: Codable {
        let filename, url: String?
    }
}
