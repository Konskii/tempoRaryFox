//
//  ClubReviews.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 27.11.2020.
//

struct ClubReviews:Codable {
    
    let results: [Reviews]
}

struct Reviews:Codable {
    let date: String?
    let id: Int?
    let name: String?
    let description: String?
    let rate: Int?
}

