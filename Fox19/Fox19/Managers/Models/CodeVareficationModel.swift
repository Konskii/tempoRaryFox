//
//  CodeVareficationModel.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 01.11.2020.
//
import Foundation

struct CodeVareficationModel: Codable {
    let id: Int
    let className: String
    let createdAt: CreatedAt
    let updateAt: UpdateAt
    let phone: String
    
    struct CreatedAt: Codable {
        let type: Date
        let value: String
        
        private enum CodingKeys: String, CodingKey {
            case type = "__type"
            case value = "value"
        }
    }
    
    struct UpdateAt: Codable {
        let type: Date
        let value: String
        
        private enum CodingKeys: String, CodingKey {
            case type = "__type"
            case value = "value"
        }
    }
}
