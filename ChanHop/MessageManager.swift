//
//  MessageManager.swift
//  ChanHop
//
//  Created by Rean Wen on 12/16/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import Foundation
import JSQMessagesViewController

class ChanhopMessage: JSQMessage {
    var id: String
    var color: String
    var isTagged: Bool
    var taggedChannel: ChannelInfo?
    
    init(senderId: String!, senderDisplayName: String!, date: Date!, text: String!, color: String, messageId: String, isTagged: Bool, taggedChannel: ChannelInfo?) {
        
        self.color = color
        self.id = messageId
        self.isTagged = isTagged
        self.taggedChannel = taggedChannel
        
        super.init(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
        self.messages.append(message)
    }
}
