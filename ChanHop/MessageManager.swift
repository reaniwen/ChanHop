//
//  MessageManager.swift
//  ChanHop
//
//  Created by Rean Wen on 12/16/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import Foundation

struct Message {
    let id: String
    let content: String
    let senderName: String
    let senderId: Int
    let color: String
    let date: Double
}

class MessageManager {
    static let shared: MessageManager = MessageManager()
    var messages: [Message] = []
    
    func refreshMessage(messages: [Message]) {
        self.messages = messages
    }
    
    func addMessage(message: Message) {
//        self.messages.insert(message, at: 0)
        self.messages.append(message)
    }
}
