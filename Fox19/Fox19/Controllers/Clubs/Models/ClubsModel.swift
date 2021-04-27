//
//  ClubsModel.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 03.11.2020.
//
struct ClubsModel:Codable {
    
    var results: [Club]
}

struct Club:Codable, Hashable {
    var rate: Float?
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
    let city: City?
    
    //Данные получаются дополнительно
    var like: Bool? = false
    var likeId: Int?
    
    struct City:Codable {
        let id: Int?
        let countryId: Int?
        let name: String?
        
        
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Club, rhs: Club) -> Bool {
        return lhs.id == rhs.id
    }
    
    func contains(filter: String?) -> Bool {
        guard let filter = filter else {  return true }
        guard let name = name else {  return true }
        
        if filter.isEmpty { return true }
        let lowerCaseFiltere = filter.lowercased()
        return name.lowercased().contains(lowerCaseFiltere)
    }
    
}

struct Point:Codable {
   let lat: Float?
   let lon: Float?
}
