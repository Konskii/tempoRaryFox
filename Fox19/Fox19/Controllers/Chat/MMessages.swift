//
//  MMessages.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 28.01.2021.
//

import MessageKit

struct MMessage: MessageType {
    
    var sender: SenderType
    
    var messageId: String {
        return String(id ?? 0)
    }
    
    var sentDate: Date
    
    let text: String
    
    var kind: MessageKind {
        return .text(text)
    }
    
    let id: Int?
    
    init(chat: ChatMessage.Result) {
        text = chat.text ?? ""
     //   sender = MSender(user: user)
        sender = MSender(user: chat.user!)
            var date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yy"
        date = dateFormatter.date(from: chat.createdAt?.locale ?? "") ?? Date()
        sentDate = date
        id = chat.id
    }
    
    init(message: ResponseFromServer, friend: User) {
        text = message.data.text
        sender = MSender(user: friend)
            var date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yy"
        date = dateFormatter.date(from: message.data.createdAt) ?? Date()
        sentDate = date
        id = message.data.id
    }
}

extension MMessage: Comparable {
    static func == (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.messageId == rhs.messageId
    }
    
    static func < (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}
