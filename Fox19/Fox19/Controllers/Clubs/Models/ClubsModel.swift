//
//  ClubsModel.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 03.11.2020.
//
struct ClubsModel:Codable {
    
    let results: [Club]
}

struct Club:Codable {
    let title: String?
    let geoPoint: Point?
    let id: Int?
    let name: String?
    let gpsLat: Float?
    let gpsLon: Float?
    let description: String?
    let holes: Int?
    let address: String?
    let phone1: String?
    let phone2: String?
    let site: String?
    let ordering: Int?
    
}

struct Point:Codable {
   let lat: Float?
   let lon: Float?
}
