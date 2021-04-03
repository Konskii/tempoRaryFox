//
//  ClubReviews.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 27.11.2020.
//

struct ClubReviews:Codable {
    
    let results: [Review]?
}

struct Review:Codable, Hashable {
    let id: Int?
   // let name: String?
    let description: String?
    let dateOnly: String?
    let timeOnly: String?
    let answer: String?
    let fieldRate: Int?
    let infraRate: Int?
    let serviceRate: Int?
    let user: User?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct PostReview:Codable {
    let description: String
    let fieldRate: Float
    let infraRate: Float
    let serviceRate: Float
    
}
