//
//  MSender.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 28.01.2021.
//

import MessageKit

struct MSender: SenderType {
    var senderId: String
    var displayName: String
    
    init(user: User) {
        senderId = String(user.id ?? 0)
        displayName = user.name ?? ""
    }
}
