//
//  SocketIOManager.swift
//  ChanHop
//
//  Created by Rean on 10/25/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    var socket: SocketIOClient!
    
    override init() {
        super.init()
        socket = SocketIOClient(socketURL: URL(string: "http://chanhop.elasticbeanstalk.com")!)
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    
    func closeConnection() {
        socket.disconnect()
    }
    
    
    func connectToServerWithNickname(_ nickname: String, completionHandler: @escaping (_ userList: [[String: AnyObject]]?) -> Void) {
        socket.emit("connectUser", nickname)
        
        socket.on("userList") { ( dataArray, ack) -> Void in
            completionHandler(dataArray[0] as? [[String: AnyObject]])
        }
        
        listenForOtherMessages()
    }
    
    
    func exitChatWithNickname(_ nickname: String, completionHandler: () -> Void) {
        socket.emit("exitUser", nickname)
        completionHandler()
    }
    
    
    func sendMessage(_ message: String, withNickname nickname: String) {
        socket.emit("chatMessage", nickname, message)
    }
    
    
    func getChatMessage(_ completionHandler: @escaping (_ messageInfo: [String: AnyObject]) -> Void) {
        socket.on("newChatMessage") { (dataArray, socketAck) -> Void in
            var messageDictionary = [String: String?]()
            messageDictionary["nickname"] = dataArray[0] as? String
            messageDictionary["message"] = dataArray[1] as? String
            messageDictionary["date"] = dataArray[2] as? String
            
            completionHandler(messageDictionary as [String : AnyObject])
        }
    }
    
    
    fileprivate func listenForOtherMessages() {
        socket.on("userConnectUpdate") { (dataArray, socketAck) -> Void in            
            NotificationCenter.default.post(name: Notification.Name("userWasConnectedNotification"), object: dataArray[0])
        }
        
        socket.on("userExitUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name("userWasDisconnectedNotification"), object: dataArray[0] as! String)
        }
        
        socket.on("userTypingUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name("userTypingNotification"), object: dataArray[0] as? [String: AnyObject])
        }
    }
}
