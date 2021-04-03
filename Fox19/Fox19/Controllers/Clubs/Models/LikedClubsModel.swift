//
//  LikedClubsModel.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 26.02.2021.
//

struct LikedClubsModel:Codable {
    let results: [LikedClubs]?
    
    struct LikedClubs:Codable {
        let userName: String?
        let clubName: String?
        let id: Int?
        let club: Club?
    }
    
}
