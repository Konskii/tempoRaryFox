//
//  LikedClubsModel.swift
//  Fox19
//
//  Created by Артём Скрипкин on 25.02.2021.
//

import Foundation

struct LikedClubsModel: Codable {
    let results: [LikedClubModel]
    
}

struct LikedClubId: Codable {
    let id: Int
}

struct LikedUserId: Codable {
    let id: Int
}
struct LikedClubModel: Codable {
    let id: Int
    let club: LikedClubId
    let user: LikedUserId
}
