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

class ConnectionManager: NSObject {
    
    static let shared = ConnectionManager()
    
    weak var userManager: UserManager? = UserManager.shared
    weak var messageManager: MessageManager? = MessageManager.shared
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
            let url = "http://chanhop-test.us-east-1.elasticbeanstalk.com/api/v1/getchannels/\(location["latitude"]!)/\(location["longitude"]!)"
            print(url)
            Alamofire.request(url, method: .get, parameters: nil)
                .responseJSON {response in
                    switch response.result {
                    case .success(let JSONData):
                        let data = JSON(JSONData)
//                        print("response code \(data["status"].intValue), total rev is \(data["channels"].count)")
                        var locations: [ChannelInfo] = []
                        // public channels
                        for i in 0..<data["channels"].count {
                            let locData = data["channels", i]
                            let location = ChannelInfo(name: locData["name"].stringValue, venueID: locData["venueID"].stringValue, longitude: locData["longitude"].doubleValue, latitude: locData["latitude"].doubleValue, distance: locData["distance"].intValue, address: "", imageURL: "", channelType: locData["channel_type_id"].intValue)
                            
                            locations.append(location)
                        }
                        
                        // todo: append the data structure of channel info and channel to support custom ad
                        // featured channels
                        for i in 0..<data["featuredChannels"].count {
                            let locData = data["channels", i]
                            let location = ChannelInfo(name: locData["name"].stringValue, venueID: locData["id"].stringValue, longitude: locData["longitude"].doubleValue, latitude: locData["latitude"].doubleValue, distance: locData["distance"].intValue, address: "", imageURL: "", channelType: 3)
                            
                            locations.append(location)
                        }
                        
                        // todo: talk with kailash about the data structure
                        // custom channels
                        for i in 0..<data["customChannels"].count {
                            let locData = data["channels", i]
                            let location = ChannelInfo(name: locData["name"].stringValue, venueID: locData["id"].stringValue, longitude: locData["longitude"].doubleValue, latitude: locData["latitude"].doubleValue, distance: locData["distance"].intValue, address: "", imageURL: "", channelType: 4)
                            
                            locations.append(location)
                            }
                        
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
    
    // todo: delete channel id
    func joinChannel(userName: String, userID: Int, channel: ChannelInfo, completion: @escaping (_ channel: ChannelModel)->Void) {
        self.joinChannel(userName: userName, userID: userID, channelName: channel.name, channelId: channel.venueID, longitude: channel.longitude, latitude: channel.latitude, channelType: channel.channelType, completion: completion)
        
    }
    
    func joinChannel(userName: String, userID: Int, channelName: String, channelId: String, longitude: Double, latitude: Double, channelType: Int, completion: @escaping (_ channel: ChannelModel)->Void) {
        if let _: [String: Double] = UserDefaults.standard.dictionary(forKey: CURRENT_LOC) as? [String: Double] {
            let url = "http://chanhop-test.us-east-1.elasticbeanstalk.com/api/v1/channel/join"
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
//                            print(roomName, backgroundURL, assignedColor)
                            
                            if let user = self.userManager {
                                user.userName = userName
                                user.userID = userID
                                user.colorHex = assignedColor
                                let channel = ChannelModel(channelName: channelName,roomID: roomID, longitude: longitude, latitude: latitude, backgroundImg: backgroundURL)
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
    // todo: parse create timestamp
    func getRoomInfo(roomId: Int, userId: Int, completion:@escaping ()->Void) {
        let url = "http://chanhop-test.us-east-1.elasticbeanstalk.com/api/v1/channel/room/\(roomId)/\(userId)"
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                switch response.result {
                case .success(let JSONData):
                    let data = JSON(JSONData)
                    if data["status"].string == "200" {
                        var messages: [Message] = []
                        for i in 0..<data["messages"].count {
                            let mData = data["messages",i]
                            let str = mData["created_at"].stringValue
                            if let interval = Double(str.substring(to: str.index(str.endIndex, offsetBy: -3))){
                                print("interval ", interval)
                                let message = Message(id: mData["id"].stringValue, content: mData["message"].stringValue, senderName: mData["username"].stringValue, senderId: mData["user_id"].intValue, color: mData["hex_color"].stringValue, date: interval)
                                
                                messages.append(message)
                            }
                        }
                        self.messageManager?.refreshMessage(messages: messages)
                        completion()
                    } else {
                        // todo:
                    }
                case .failure(let error):
                    // todo: 
                    print(error.localizedDescription)
                }
                
            }
            .responseString {response in
                print("result of get room infomation is \(response.result.value)")
                
        }
    }
    
    func getPreviousRoomInfo(direction: Int, channelID: Int = 44, roomId: Int, userId: Int, completion: @escaping ()->Void) {
        let url = "http://chanhop-test.us-east-1.elasticbeanstalk.com/api/v1/channel/room/switch"
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
                        self.messageManager?.refreshMessage(messages: [])
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
}
