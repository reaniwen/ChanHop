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
        socket = SocketIOClient(socketURL: URL(string: SOCKETIO_URL)!)
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    
    func closeConnection() {
        socket.disconnect()
    }
    
    
//    func connectToServerWithNickname(_ nickname: String, completionHandler: @escaping (_ userList: [[String: AnyObject]]?) -> Void) {
//        socket.emit("connectUser", nickname)
//        
//        socket.on("userList") { ( dataArray, ack) -> Void in
//            completionHandler(dataArray[0] as? [[String: AnyObject]])
//        }
//        
//        listenForOtherMessages()
//    }
//    
//    
//    func exitChatWithNickname(_ nickname: String, completionHandler: () -> Void) {
//        socket.emit("exitUser", nickname)
//        completionHandler()
//    }
//    
//    
//    func sendMessage(_ message: String, withNickname nickname: String) {
//        socket.emit("chatMessage", nickname, message)
//    }
//    
//    
//    func getChatMessage(_ completionHandler: @escaping (_ messageInfo: [String: AnyObject]) -> Void) {
//        socket.on("newChatMessage") { (dataArray, socketAck) -> Void in
//            var messageDictionary = [String: String?]()
//            messageDictionary["nickname"] = dataArray[0] as? String
//            messageDictionary["message"] = dataArray[1] as? String
//            messageDictionary["date"] = dataArray[2] as? String
//            
//            completionHandler(messageDictionary as [String : AnyObject])
//        }
//    }
    
    func joinRoom(_ userName: String, roomName: String, created_at: Double) {
        let parameters = ["data":[
            "username": userName,
            "roomName": roomName,
            "created_at": created_at
        ]] as [String: Any]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            let JSONText = NSString(data: jsonData,
                                       encoding: String.Encoding.ascii.rawValue) as! String
            print("emit data is" + JSONText)
            
            socket.emit("userJoinsRoom", JSONText)
            
            listenForOtherMessages()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addMessage(roomId: Int, userid:Int, userName: String, message: String, completion:()->Void) {
        let parameters = ["data":[
            "userid": userid,
            "roomid": roomId,
            "username": userName,
            "message": message
            ]] as [String: Any]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            let JSONText = NSString(data: jsonData,
                                    encoding: String.Encoding.ascii.rawValue) as! String
            print("emit data for userSendsMessage is" + JSONText)
            
            socket.emit("userSendsMessage", JSONText)
            completion()
            
//            listenForOtherMessages()
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
    func listenForOtherMessages() {
        socket.on("newUser") { (dataArray, socketAck) -> Void in
            print(dataArray)
            NotificationCenter.default.post(name: Notification.Name("com.chanhop.newUserJoin"), object: dataArray[0])
        }
        
        socket.on("newMessage") { (dataArray, socketAck) -> Void in
            print(dataArray)
            NotificationCenter.default.post(name: NSNotification.Name("com.chanhop.newMessage"), object: dataArray[0] as! String)
        }
        
        socket.on("userLeaves") { (dataArray, socketAck) -> Void in
            print(dataArray)
            NotificationCenter.default.post(name: NSNotification.Name("userTypingNotification"), object: dataArray[0] as? [String: AnyObject])
        }
    }
}
