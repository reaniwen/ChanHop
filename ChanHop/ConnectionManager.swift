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

class ConnectionManager: NSObject {
    
    static let shared = ConnectionManager()
    
    weak var userManager: UserManager? = UserManager.shared
    
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
                        for i in 0..<data["channels"].count {
                            let locData = data["channels", i]
                            let location = ChannelInfo(name: locData["name"].stringValue, id: locData["venueID"].stringValue, longitude: locData["longitude"].doubleValue, latitude: locData["latitude"].doubleValue, distance: locData["distance"].intValue, address: "", imageURL: "")
                            
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
    
    func joinChannel(userName: String, userID: Int, channel: ChannelInfo, completion: @escaping (_ channel: ChannelModel)->Void) {
        self.joinChannel(userName: userName, userID: userID, channelName: channel.name, channelId: channel.id, longitude: channel.longitude, latitude: channel.latitude, completion: completion)
        
    }
    
    func joinChannel(userName: String, userID: Int, channelName: String, channelId: String, longitude: Double, latitude: Double, completion: @escaping (_ channel: ChannelModel)->Void) {
        if let _: [String: Double] = UserDefaults.standard.dictionary(forKey: CURRENT_LOC) as? [String: Double] {
            let url = "http://chanhop-test.us-east-1.elasticbeanstalk.com/api/v1/channel/add"
            let parameters = [
                "username": userName,
                "userid": userID,
                "name": channelName,
                "venueid": channelId,
                "latitude": latitude,
                "longitude": longitude
            ] as [String : Any]
            Alamofire.request(url, method: .post, parameters: parameters)
                .responseJSON { response in
                    switch response.result {
                    case .success(let JSONData):
                        let data = JSON(JSONData)
                        if data["status"].stringValue == "200" {
                            let roomName = data["room"].stringValue
                            let userID = data["user"].intValue
                            // userName
                            let backgroundURL = data["photo"].stringValue
                            let assignedColor = data["assignedColor"].stringValue
//                            print(roomName, backgroundURL, assignedColor)
                            
                            if let user = self.userManager {
                                user.userName = userName
                                user.userID = userID
                                user.colorHex = assignedColor
                                let channel = ChannelModel()
                                channel.configureChannel(channelID: channelId, channelName: channelName, longitude: longitude, latitude: latitude)
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
}

// Mark: Deprecated method
extension ConnectionManager {

    //    func getFourSquareRoom(completion: @escaping(_ res: Bool, _ locations:[FourSquareLocation]) -> Void) {
    //        if let location: [String: Double] = UserDefaults.standard.dictionary(forKey: CURRENT_LOC) as? [String: Double] {
    //            let dateFormatter = DateFormatter()
    //            dateFormatter.dateFormat = "yyyyMMdd"
    //            let todayStr = dateFormatter.string(from: Date())
    //            let coordination: String = "\(location["latitude"]!),\(location["longitude"]!)"
    //            let url = "\(FS_BASE_URL)client_id=\(FS_CLIENT_ID)&client_secret=\(FS_SECRET_KEY)&v=\(todayStr)&ll=\(coordination)&query=&limit=\(FS_QUERY_LIMIT)"
    ////            print(url)
    //            Alamofire.request(url, method: .get, parameters: nil)
    //                .responseJSON { response in
    //                    switch response.result {
    //                    case .success(let JSONData):
    //                        let data = JSON(JSONData)
    ////                        print(data["response","venues","0"])
    //                        var locations: [FourSquareLocation] = []
    //                        for i in 0..<data["response","venues"].count {
    //                            let locData = data["response","venues",i]
    //                            let location = FourSquareLocation(name: locData["name"].stringValue, longitude: locData["location","lng"].doubleValue, latitude: locData["location","lat"].doubleValue, distance: locData["location","distance"].intValue, address: locData["location","address"].stringValue, imageURL: "")
    //
    //                            locations.append(location)
    //                        }
    //                        completion(true, locations)
    //                    case .failure(let error):
    //                        print(error.localizedDescription)
    //                        completion(false, [])
    //                    }
    //
    //                }
    ////                .responseString { response in
    ////                    print(response.result)
    ////            }
    //        }
    //        
    //    }
}
