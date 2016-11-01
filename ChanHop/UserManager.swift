//
//  UserManager.swift
//  ChanHop
//
//  Created by Rean Wen on 10/26/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserManager: NSObject {
    
    static let shared = UserManager()
    
    var userID: Int = 0
    var userName: String = ""
    var colorHex: String = ""
    
    func checkAndJoinRoomInChannel(latitude: Double, longitude: Double, channelName: String, completion: @escaping (_ roomName: String)-> Void) {
        let parameters = ["channelName":"LocalHop",
                            "locationCoordinate": String(format: "%f,%f", arguments: [Float(latitude), Float(longitude)]),
                            "username":"aaa"]
        print("joining channel:", parameters)
        Alamofire.request(CHANHOP_URL + "/checkandjoinroominchannel", method: .post, parameters: parameters)
            .responseJSON { response in
                switch response.result {
                case .success(let JSONdata):
                    let data = JSON(JSONdata)
                    self.userID = data["id"].intValue
                    self.colorHex = data["colorHex"].stringValue
                    print("the result of first join room is: ", data)
                    completion(data["roomName"].stringValue)
                case .failure(let error):
                    print("the result of first join room is: ", error.localizedDescription)
                }
        }
        
    }
    
    func updateLocation(latitude: Double, longitude: Double) {
        let parameters: [String: Any] = ["userID": userID,
                          "locationCoordinate": String(format: "%f,%f", arguments: [Float(latitude), Float(longitude)])
        ]
        print("parameters for updateLocation are: ",parameters)
        Alamofire.request(CHANHOP_URL + "/updatelocation", method: .post, parameters: parameters)
            .responseJSON { response in
                switch response.result {
                case .success(let JSONdata):
                    let data = JSON(JSONdata)
                    print("the result of update location is: ", data)
                case .failure(let error):
                    print("the result of update location is: ", error.localizedDescription)
                }
            }
        
    }
    
    func userLeaveRoom(room: String) {
        let parameters: [String: Any] = ["userID": userID,
                          "roomName": room
                          ]
        print("parameters for leaving room are: ", parameters)
        Alamofire.request(CHANHOP_URL + "/userleavesroom", method: .post, parameters: parameters)
            .responseJSON { response in
                switch response.result {
                case .success(let JSONdata):
                    let data = JSON(JSONdata)
                    print("the result of leave room is: ", data)
                case .failure(let error):
                    print("the result of leave room is: ", error.localizedDescription)
                }
        }
    }
}
