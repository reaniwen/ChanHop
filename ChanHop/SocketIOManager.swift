//
//  SocketIOManager.swift
//  ChanHop
//
//  Created by Rean on 10/25/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//


import UIKit
import SocketIO
import SwiftyJSON

class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    
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

    func listenForOtherMessages() {
        socket.on("testEmitReturns") { (dataArray, socketAck) -> Void in
            print(dataArray)
            //            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasConnectedNotification"), object: dataArray[0] as! [String: AnyObject])
        }
        socket.on("newUser") { (dataArray, socketAck) -> Void in
            print(dataArray)
            
            let data = JSON(dataArray[0])
//            let created_at: Double = data["created_at"].doubleValue/1000
            let user_count = data["user_count"].intValue
//            let userName: String = data["username"].stringValue
            NotificationCenter.default.post(name: Notification.Name(S_UPDATE_COUNT), object: nil, userInfo: ["amount": user_count])
            
        }
        
        socket.on("newMessage") { (dataArray, socketAck) -> Void in
            print(dataArray)
            NotificationCenter.default.post(name: NSNotification.Name(S_NEW_MESSAGE), object: dataArray[0] as! String)
            // todo: finish receive message
//            let newMessage = ChanhopMessage(senderId: String(UserManager.shared.userID), senderDisplayName: userName, date: Date(), text: message, color: color_hex, messageId: "", isTagged: isTagged, taggedChannel: taggedChannel)
//            MessageManager.shared.messages.append(newMessage)
        }
        
        socket.on("userLeaves") { (dataArray, socketAck) -> Void in
            print(dataArray)
            let data = JSON(dataArray[0])
            let user_count = data["user_count"].intValue
//            let userName: String = data["username"].stringValue
            NotificationCenter.default.post(name: Notification.Name(S_UPDATE_COUNT), object: nil, userInfo: ["amount": user_count])
        }
        
        self.socket.onAny {print("Got event: \($0.event), with items: \($0.items)")}

    }
    
    // deprecated
//    func testEmit() {
//        //        let parameters = "{\"string\":\"abc\",\"integer\":123}"
//        let parameters = ["string":"abc", "integer":123] as [String : Any]
//        listenForOtherMessages()
//        
//        print("emit data for userSendsMessage is \(parameters)")
//        socket.emit("testEmit", parameters)
//    }
    
   func sendTestEmit(_ sender: Any) {
        let parameters = ["string":"abc", "integer":"123"]
        
        print("emit data for testEmit is \(parameters)")
        socket.emit("testEmit", parameters)
    }
    
    func joinRoom(roomName: String, userName: String, created_at: TimeInterval) {
        let parameters:[String: Any] = ["roomName":roomName, "username":userName, "created_at": Int(created_at)*1000]
        print("emit data for userJoinsRoom is \(parameters)")
        socket.emit("userJoinsRoom", parameters)
        
        listenForOtherMessages()
    }
    
    func sendMessage(userID: Int, roomID: Int, userName: String, message: String, is_tagged: Int, channelName: String, longitude: Double, latitude: Double, channelType: Int = 0, hasPassword: Int = 0, completion: @escaping (ChanhopMessage)->Void) {

        let parameters:[String: Any] = ["userid": userID, "roomid": roomID, "username": userName, "message": message, "is_tagged": is_tagged, "channelName": channelName, "longitude": longitude, "latitude": latitude, "channel_type_id": channelType, "has_password": hasPassword]
        
        print("emit data for userSendsMessage is \(parameters)")
        socket.emitWithAck("userSendsMessage", parameters).timingOut(after: 3, callback: { JSONData in
            let data = JSON(JSONData[0])
            print("CONNECTED FOR SURE \(data)")

            let color_hex = data["color_hex"].stringValue
//            let created_at = data["created_at"].doubleValue/1000
//            let is_tagged = data["is_tagged"].intValue
            let message = data["message"].stringValue
//            let roomName = data["roomName"].stringValue
            let userName = data["username"].stringValue
            
            
            let tagValue = data["is_tagged"].intValue
            let isTagged = tagValue == 0 ? false : true
            var taggedChannel: ChannelInfo? = nil
            if isTagged {
                // todo: optimize here
                taggedChannel = ChannelInfo(name: "", venueID: "", longitude: 0, latitude: 0, distance: 0, address: "", imageURL: "", channelType: 0, adURL: "", hashPass: "")
            }
            
            let newMessage = ChanhopMessage(senderId: String(UserManager.shared.userID), senderDisplayName: userName, date: Date(), text: message, color: color_hex, messageId: "", isTagged: isTagged, taggedChannel: taggedChannel)
            MessageManager.shared.messages.append(newMessage)
            
            completion(newMessage)
        })
    }
    
    func leaveRoom(roomName: String, userName: String, created_at: TimeInterval) {
        let parameters:[String: Any] = ["oldRoomName":roomName,"username":userName,"created_at":Int(created_at)*1000]
        print("emit data for userLeavesRoom is \(parameters)")
        socket.emit("userLeavesRoom", parameters)
    }
    
}
