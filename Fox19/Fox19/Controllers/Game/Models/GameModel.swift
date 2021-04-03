//
//  GameModel.swift
//  Fox19
//
//  Created by Калинин Артем Валериевич on 04.11.2020.
//
import UIKit

// MARK: - GameStruct
struct GameModel: Codable {
    let count: Int?
    var results: [Game]
}

struct Game: Codable {
    let title: String?
    let id: Int?
    let description: String?
    let date, time: String?
    let holes, gamersCount: Int?
    let reserved: Bool?
    let memberPrice, guestPrice: Int?
    
    let user: USID
    let club: ClubID
}
struct ClubID: Codable {
    let id: Int?
}

struct USID: Codable {
    let id: Int?
}



//MARK: - Delete
struct UserInClubs {
    var image: UIImage
}

func getUserInGame() -> [UserInClubs] {
    
    let user = UserInClubs(image: UIImage(named: "user")!)
    
    return [user,user,user,user]
}


//MARK: Working Model.
struct GamesModel:Codable, Hashable {
    let count: Int?
    let results: [Game]
    
    struct Game:Codable,Hashable {
        let title: String?
        let date: String?
        let time: String?
        let holes: Int?
        let gamersCount: Int?
        let reserved: Bool?
        let memberPrice: Int?
        let guestPrice: Int?
        let description: String?
        let club: Club?
        let user: User?
        
        let id: Int?
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: Game, rhs: Game) -> Bool {
            return lhs.id == rhs.id
        }
//        
//        func contains(filter: String?) -> Bool {
//            guard let filter = filter else {  return true }
//            guard let name = name else {  return true }
//            
//            if filter.isEmpty { return true }
//            let lowerCaseFiltere = filter.lowercased()
//            return name.lowercased().contains(lowerCaseFiltere)
//        }
    }
}
