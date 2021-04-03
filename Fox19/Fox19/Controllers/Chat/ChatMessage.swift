//
//  ChatMessage.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 28.01.2021.
//

struct ChatMessage: Codable {
    
    let results: [Result]?
    
    struct Result: Codable {
        let id: Int?
        let text: String?
        let createdAt: CreatedAt?
        let user: User?
        
        struct CreatedAt: Codable {
            let locale: String?
        }
        
    }
}

//MARK: - Response Data
struct ResponseFromServer: Codable {
    let type: String
    let data: ResponseData
    
    struct ResponseData:Codable {
        let isRead: Bool
        let id: Int
        let userId: Int
        let chatId: Int
        let text: String
        let createdAt: String
    }
}
