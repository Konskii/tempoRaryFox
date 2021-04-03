//
//  ClubImageStruct.swift
//  Fox19
//
//  Created by Калинин Артем Валериевич on 04.11.2020.
//
// MARK: - GameMember
struct GameMembers: Codable {
    var results: [GameMember]?
}

struct GameMember: Codable {
    let id: Int?
    let status: String?
    var user: User?
}
