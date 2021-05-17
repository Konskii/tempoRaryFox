//
//  ChampioshipmembersModel.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 30.11.2020.
//

struct ChampioshipmembersModel: Codable {
    let results: [member]?
}

struct member: Codable {
    let id: Int?
    let status: String?
    let user: unserInfo
}

struct unserInfo: Codable {
   let id: Int?
}
