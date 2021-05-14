//
//  UserGetModel.swift
//  Fox19
//
//  Created by Артём Скрипкин on 04.11.2020.
//
// MARK: - GetUserResponse. Данную модель не изменять!
struct GetUserResponse: Codable {
    let results: [User]?
}

// MARK: - User
struct User: Codable, Hashable {
    let id: Int?
    var phone, email, golfRegistryIdRU, about, name, lastName: String?
    var handicap: Double?
    var isAdmin, isReferee, isGamer, isTrainer: Bool?
    let avatar: Avatar?
    
    struct Avatar: Codable {
        let filename, url: String?
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: User, rhs: User) -> Bool {
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
