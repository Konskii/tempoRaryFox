//
//  TournamentsModel.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 06.11.2020.
//
struct TournamentsModel: Codable {
    let results: [Tournament]?
}

struct Tournament: Codable {
    let title: String?
    let id: Int?
    let name: String?
    let description: String?
    let date: ChampDate?
    let memberPrice: Int?
    let guestPrice: Int?
    let club: Club?
}

struct ChampDate: Codable {
    let value: String?
}
