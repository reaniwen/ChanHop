//
//  ConnectionManager.swift
//  ChanHop
//
//  Created by Rean Wen on 10/26/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import CoreLocation

class ConnectionManager: NSObject {
    
    static let shared = ConnectionManager()
    
    weak var userManager: UserManager? = UserManager.shared
    weak var messageManager: MessageManager? = MessageManager.shared
    var socketIOManager = SocketIOManager.shared
    var singleton: Singleton = Singleton.shared
    
    func checkServer(completion: @escaping (_ status: Bool, _ info: String) -> Void) {
        Alamofire.request(CHANHOP_URL + "/checkserver", method: .get, parameters: nil)
            .responseJSON { response in
                switch response.result{
                case .success(let JSONdata):
                    let data = JSON(JSONdata)
                    if data["status"].stringValue == "200" {
                        completion(true, data["message"].stringValue)
                    } else {
                        completion(false, data["message"].stringValue)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(false, error.localizedDescription)
                }
        }
    }
    
    func getChannels(completion: @escaping(_ res: Bool, _ locations:[ChannelInfo]) -> Void) {
        if let location: [String: Double] = UserDefaults.standard.dictionary(forKey: CURRENT_LOC) as? [String: Double] {
            let url = CHANHOP_URL+"/getchannels/\(location["latitude"]!)/\(location["longitude"]!)"
            print(url)
            Alamofire.request(url, method: .get, parameters: nil)
                .responseJSON {response in
                    switch response.result {
                    case .success(let JSONData):
                        let data = JSON(JSONData)
//                        print("response code \(data["status"].intValue), total rev is \(data["channels"].count)")
                        var locations: [ChannelInfo] = []
                        var featuredLocations: [ChannelInfo] = []
                        var publicLocations: [ChannelInfo] = []
                        var customLocations: [ChannelInfo] = []
                        
                        // todo: append the data structure of channel info and channel to support custom ad
                        // featured channels
                        for i in 0..<data["featuredChannels"].count {
                            let locData = data["featuredChannels", i]
                            let adURL: String? = locData["custom_ad"].stringValue == "" ? nil : AD_BASE_URL+locData["custom_ad"].stringValue
                            let location = ChannelInfo(name: locData["name"].stringValue, venueID: "", longitude: locData["longitude"].doubleValue, latitude: locData["latitude"].doubleValue, distance: 0, address: "", imageURL: locData["custom_ad"].stringValue, channelType: 2, adURL: adURL, hashPass: "")
                            featuredLocations.append(location)
                        }
                        self.singleton.featuredChannelInfos = featuredLocations
                        locations += featuredLocations
                        
                        // public channels
                        for i in 0..<data["channels"].count {
                            let locData = data["channels", i]
                            let location = ChannelInfo(name: locData["name"].stringValue, venueID: locData["venueID"].stringValue, longitude: locData["longitude"].doubleValue, latitude: locData["latitude"].doubleValue, distance: locData["distance"].intValue, address: "", imageURL: "", channelType: locData["channel_type_id"].intValue, adURL: nil, hashPass: "")
                            
                            publicLocations.append(location)
                        }
                        self.singleton.channelInfos = publicLocations
                        locations += publicLocations
                        
                        // todo: talk with kailash about the data structure
                        // custom channels
                        for i in 0..<data["customChannels"].count {
                            let locData = data["customChannels", i]
                            let location = ChannelInfo(name: locData["name"].stringValue, venueID: locData["id"].stringValue, longitude: locData["longitude"].doubleValue, latitude: locData["latitude"].doubleValue, distance: locData["distance"].intValue, address: "", imageURL: "", channelType: 4, adURL: nil, hashPass: locData["custom_password"].stringValue)
                            print("hashed password is", locData["custom_password"].stringValue)
//                            {\"id\":115,\"name\":\"hkghk\",\"channel_type_id\":4,\"latitude\":\"000000\",\"longitude\":\"000000\",\"custom_ad\":null,\"custom_password\":null,\"channel_photo\":\"\",\"channel_type_name\":\"Custom\"}
                            customLocations.append(location)
                        }
                        self.singleton.customChannelInfo = customLocations
                        locations += customLocations
                        
                        
                        self.singleton.lastRequestLocation = CLLocation(latitude: location["latitude"]!, longitude: location["longitude"]!)
                        completion(true, locations)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                .responseString {response in
                    print("result is \(response.result.value)")
                }
            
        } else {
            // todo: show an alert to tell user to open location
        }
    }
    
    
    func joinChannel(userName: String, userID: Int, channel: ChannelInfo, completion: @escaping (_ channel: ChannelModel)->Void) {
        self.joinChannel(userName: userName, userID: userID, channelName: channel.name, channelId: channel.venueID, longitude: channel.longitude, latitude: channel.latitude, channelType: channel.channelType, adURL: channel.adURL, completion: completion)
    }
    
    func joinChannel(userName: String, userID: Int, channelName: String, channelId: String, longitude: Double, latitude: Double, channelType: Int, adURL: String?, completion: @escaping (_ channel: ChannelModel)->Void) {
        if let _: [String: Double] = UserDefaults.standard.dictionary(forKey: CURRENT_LOC) as? [String: Double] {
            let url = CHANHOP_URL+"/channel/join"
            let parameters = [
                "username": userName,
                "userid": userID,
                "name": channelName,
                "venueid": channelId,
                "latitude": latitude,
                "longitude": longitude,
                "type": channelType
            ] as [String : Any]
            print("calling join channel \(parameters)")
            Alamofire.request(url, method: .post, parameters: parameters)
                .responseJSON { response in
                    switch response.result {
                    case .success(let JSONData):
                        let data = JSON(JSONData)
                        if data["status"].stringValue == "200" {
                            let roomID = data["room"].intValue
                            let userID = data["user"].intValue
                            let backgroundURL = data["photo"].stringValue
                            let assignedColor = data["assignedColor"].stringValue
                            let userCount = data["user_count"].intValue
                            let createTime = data["channelTimeStamp"].doubleValue
//                            print(roomName, backgroundURL, assignedColor)
                            
                            if let user = self.userManager {
                                user.userName = userName
                                user.userID = userID
                                user.colorHex = assignedColor
                                let channel = ChannelModel(channelName: channelName, roomID: roomID, userCount: userCount, createTime: createTime, longitude: longitude, latitude: latitude, backgroundImg: backgroundURL, adURL: adURL)
                                completion(channel)
                            }
                        } else {
                            // error
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                .responseString { response in
                    print("result of join channel is \(response.result.value)")
                }
        }
    }
    
    func joinPrivateChannel(userName: String, userID: Int, channel: ChannelInfo, password: String, completion: @escaping (_ channel: ChannelModel)->Void) {
        self.joinPrivateChannel(userName: userName, userID: userID, channelName: channel.name, longitude: channel.longitude, latitude: channel.latitude, password: password, adURL: channel.adURL, completion: completion)
    }
    
    func joinPrivateChannel(userName: String, userID: Int, channelName: String, longitude: Double, latitude: Double, password: String, adURL: String?, completion: @escaping (_ channel: ChannelModel)->Void) {
        if let _: [String: Double] = UserDefaults.standard.dictionary(forKey: CURRENT_LOC) as? [String: Double] {
            let url = CHANHOP_URL+"/channel/join"
            var parameters = [
                "username": userName,
                "userid": userID,
                "name": channelName,
//                "venueid": channelId,
                "latitude": latitude,
                "longitude": longitude,
                "type": 4
                ] as [String : Any]
            if password != "" {
                parameters["password"] = password
            }
            print("calling join channel \(parameters)")
            Alamofire.request(url, method: .post, parameters: parameters)
                .responseJSON { response in
                    switch response.result {
                    case .success(let JSONData):
                        let data = JSON(JSONData)
                        if data["status"].stringValue == "200" {
                            let roomID = data["room"].intValue
                            let userID = data["user"].intValue
                            let backgroundURL = data["photo"].stringValue
                            let assignedColor = data["assignedColor"].stringValue
                            let userCount = data["user_count"].intValue
                            let createTime = data["channelTimeStamp"].doubleValue
                            //                            print(roomName, backgroundURL, assignedColor)
                            
                            if let user = self.userManager {
                                user.userName = userName
                                user.userID = userID
                                user.colorHex = assignedColor
                                let channel = ChannelModel(channelName: channelName, roomID: roomID, userCount: userCount, createTime: createTime, longitude: longitude, latitude: latitude, backgroundImg: backgroundURL, adURL: adURL)
                                completion(channel)
                            }
                        } else {
                            // error
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                .responseString { response in
                    print("result of join channel is \(response.result.value)")
            }
        }
    }
    
    // Mark: not only room info, but also chat history
    func getRoomInfo(roomId: Int, userId: Int, userName: String, completion:@escaping ()->Void) {
        let url = CHANHOP_URL+"/channel/room/\(roomId)/\(userId)"
        print("get room info from \(url)")
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                switch response.result {
                case .success(let JSONData):
                    let data = JSON(JSONData)
                    if data["status"].string == "200" {
//                        var messages: [Message] = []
//                        for i in 0..<data["messages"].count {
//                            let mData = data["messages",i]
//                            let str = mData["created_at"].stringValue
//                            if let interval = Double(str.substring(to: str.index(str.endIndex, offsetBy: -3))){
////                                print("interval ", interval)
//                                let message = Message(id: mData["id"].stringValue, content: mData["message"].stringValue, senderName: mData["username"].stringValue, senderId: mData["user_id"].intValue, color: mData["hex_color"].stringValue, date: interval)
//                                
//                                messages.append(message)
//                            }
//                        }
                        var messages: [ChanhopMessage] = []
                        for i in 0..<data["messages"].count {
                            let mData = data["messages",i]
                            let interval = mData["created_at"].doubleValue/1000
                            let sendDate = Date(timeIntervalSince1970: interval)
                            
                            let message = ChanhopMessage(senderId: mData["user_id"].stringValue, senderDisplayName: mData["username"].stringValue, date: sendDate, text: mData["message"].stringValue, color: mData["hex_color"].stringValue, messageId: mData[""].stringValue, isTagged: false, taggedChannel: nil)
                            messages.append(message)
                            // todo: adjust istagged
                        }
                        self.singleton.channel?.roomName = data["roomName"].stringValue
                        self.singleton.channel?.createTime = data["channelTimestamp"].doubleValue
                        
                        let userCount = data["user_count"].intValue
                        // Send a notification for amount
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: UPDATE_USER_COUNT), object: nil, userInfo: ["amount": userCount])
                        
//                        self.messageManager?.refreshMessage(messages: messages)
                        self.messageManager?.messages = messages
                        completion()
                    } else {
                        // todo:
                    }
                case .failure(let error):
                    // todo: 
                    print(error.localizedDescription)
                }
                
            }
//            .responseString {response in
//                print("result of get room infomation is \(response.result.value)")
//                
//        }
    }
    
    // previous -1, next 1
    func getPreviousChannel(direction: Int, channelName: String, completion: @escaping (_ channel: ChannelModel)-> Void) {
        if singleton.channelInfos.count == 0 {
            self.getChannels() {_,_ in 
                self.getChannelCompletion(direction: direction, channelName: channelName, completion: completion)
            }
        } else {
            self.getChannelCompletion(direction: direction, channelName: channelName, completion: completion)
        }
    }
    
    func getChannelCompletion(direction: Int, channelName: String, completion: @escaping (_ channel: ChannelModel)-> Void) {
        var nextInfo: ChannelInfo? = nil
        if channelName == "localhop" {
            nextInfo = direction == -1 ? nil : singleton.channelInfos[0]
        } else {
            for i in 0..<singleton.channelInfos.count {
                if channelName == singleton.channelInfos[i].name {
                    if (i + direction < 0) || (i + direction >= singleton.channelInfos.count) {
                        nextInfo = nil
                    } else {
                        nextInfo = singleton.channelInfos[i+direction]
                    }
                    break
                }
            }
        }
        
        if nextInfo != nil {
            // leave previous channel
            if let roomId: Int = singleton.channel?.roomID, let user = userManager {
                leaveRoom(roomId: roomId, userId: user.userID) {
                    // join new Channnel
                    self.joinChannel(userName: user.userName, userID: user.userID, channel: nextInfo!) { channel in
                        completion(channel)
                    }
                }
            }
        } else {
            // toco: pop up error info
            SVProgressHUD.showError(withStatus: "No more Channel")
        }
    }
    
    // Mark: switch room
    // previous 0, next 1
    func getPreviousRoomInfo(direction: Int, channelID: Int = 44, roomId: Int, userId: Int, completion: @escaping ()->Void) {
        let url = CHANHOP_URL+"/channel/room/switch"
        let parameters = ["status": direction, // 0 previous, 1 next
                          "channelid": channelID,
                          "roomid": roomId,
                          "userid": userId
            ] as [String: Any]
        print(parameters)
        Alamofire.request(url, method: .post, parameters: parameters)
            .responseJSON { response in
                switch response.result {
                case .success(let JSONData):
                    let data = JSON(JSONData)
                    if data["status"].string == "200" {
                        self.singleton.channel?.roomID = data["room"].intValue
//                        self.messageManager?.messages = []
//                        self.messageManager?.refreshMessage(messages: [])
                        // todo: optimize here to use the data
                        completion()
                    } else {
                        SVProgressHUD.showError(withStatus: data["Reason"].stringValue)
                    }
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                }
            }
            .responseString { response in
                print("result of switching room is \(response.result.value)")
        }
    }
    
    func getUserList(roomId: Int, completion: @escaping (_ users:[Member]) -> Void) {
        let url = CHANHOP_URL+"/channel/list/\(roomId)"
        print("Getting User List from "+url)
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                switch response.result {
                case .success(let JSONData):
                    let data = JSON(JSONData)
                    if data["status"].string == "200" {
                        var users:[Member] = []
                        for i in 0..<data["userlist"].count {
                            users.append(Member(name: data["userlist",i,"username"].stringValue, color: data["userlist",i,"hex_color"].stringValue))
//                            users.append((name: data["userlist",i,"username"].stringValue, color: data["userlist",i,"hex_color"].stringValue))
                        }
                        completion(users)
                    } else {
                        SVProgressHUD.showError(withStatus: "Get users failed")
                    }
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                }
        }
    }
    
    func updateName(userId: Int, userName: String, completion: @escaping (Bool)->Void) {
        let url = CHANHOP_URL + "/user/username/update"
        let parameters = [
            "userid": userId,
            "username": userName
        ] as [String: Any]
        Alamofire.request(url, method: .post, parameters: parameters)
            .responseJSON { response in
                switch response.result {
                case .success(let JSONData):
                    let data = JSON(JSONData)
                    if data["status"].string == "200" {
                        completion(true)
                    } else {
                        SVProgressHUD.showError(withStatus: "Change Room Failed")
                    }
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                }
        }
    }
    
    func updateLocation(userId: Int, longitude: Double, latitude: Double, completion: @escaping (Bool)->Void) {
        let url = CHANHOP_URL + "/user/location/update"
        let parameters = [
            "userid": userId,
            "longitude": longitude,
            "latitude": latitude
            ] as [String: Any]
        Alamofire.request(url, method: .post, parameters: parameters)
            .responseJSON { response in
                switch response.result {
                case .success(let JSONData):
                    let data = JSON(JSONData)
                    if data["status"].string == "200" {
                        completion(true)
                    } else {
                        SVProgressHUD.showError(withStatus: "Change Room Failed")
                    }
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                }
        }
    }
    
    func updateDeviceToken(userId: Int, deviceToken: String, completion: @escaping (Bool)->Void) {
        let url = CHANHOP_URL + "/user/devicetoken/update"
        let parameters = [
            "userid": userId,
            "devicetoken": deviceToken
            ] as [String: Any]
        Alamofire.request(url, method: .post, parameters: parameters)
            .responseJSON { response in
                switch response.result {
                case .success(let JSONData):
                    let data = JSON(JSONData)
                    if data["status"].string == "200" {
                        completion(true)
                    } else {
                        SVProgressHUD.showError(withStatus: "Change Room Failed")
                    }
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                }
        }
    }
    
    
    func leaveRoom(roomId: Int, userId: Int, completion: @escaping ()->Void) {
        let url = CHANHOP_URL+"/channel/room/leave"
        let parameters = [
            "roomid": roomId,
            "userid": userId
        ] as [String: Any]
        Alamofire.request(url, method: .post, parameters: parameters)
            .responseJSON { response in
                switch response.result {
                case .success(let JSONData):
                    let data = JSON(JSONData)
                    if data["status"].string == "200" {
                        completion()
                    } else {
                        SVProgressHUD.showError(withStatus: "Leave room failed")
                    }
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    print(error.localizedDescription)
                }
                
        }
    }
}
