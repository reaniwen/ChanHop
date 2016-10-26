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
    
    func checkAndJoinRoomInChannel(latitude: Float, longitude: Float) {
        if UserDefaults.standard.dictionary(forKey: CURRENT_LOC) != nil {
            let parameters = ["channelName":"LocalHop",
                              "locationCoordinate":String(format: "%f,%f", arguments: [latitude, longitude]),
                              "username":"aaa"]
            Alamofire.request(CHANHOP_URL + "/checkandjoinroominchannel", method: .post, parameters: parameters)
                .responseJSON { response in
                    switch response.result {
                    case .success(let JSONdata):
                        let data = JSON(JSONdata)
                        print(data)
                    case .failure(let error):
                        print(error)
                    }
            }
        } else {
            // nil
            print("location data is nil")
        }
        
    }
    
    func updateLocation() {
        
    }
}
