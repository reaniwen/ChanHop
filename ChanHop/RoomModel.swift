//
//  RoomModel.swift
//  ChanHop
//
//  Created by Rean Wen on 10/24/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import Foundation

class RoomModel: NSObject {
    
    var roomIndex: Int = 0
    var userName:String = ""
    var channelName:String = ""
    var roomName: String = ""
    var roomSize: Int = 25
    
    
    func configureRoom (_ response: NSDictionary) {
        if let roomIndex = response.value(forKey: "roomIndex") {
            self.roomIndex = roomIndex as! Int
        }
        if let userName = response.value(forKey: "userName") {
            self.userName = userName as! String
        }
        if let channelName = response.value(forKey: "channelName") {
            self.channelName = channelName as! String
        }
        if let roomName = response.value(forKey: "roomName") {
            self.roomName = roomName as! String
        }
        if let size = response.value(forKey: "roomSize") {
            self.roomSize = size as! Int
        }
    }
}
