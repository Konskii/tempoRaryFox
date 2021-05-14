//
//  MChat.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 28.01.2021.
//


struct MyChats: Codable {
    
    let results: [MChat]?
}

struct MChat: Codable {
    
    let id: Int?
    let user: User?
    let users: [User]?
}
