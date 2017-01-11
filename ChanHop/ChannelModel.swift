//
//  ChannelModel.swift
//  ChanHop
//
//  Created by Rean Wen on 10/24/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import Foundation

class ChannelModel: NSObject {
    
    var channelID: Int = 0
    var channelName: String = "0"
    
    var channelType: ChannelType = .pub
    var createTime: Double = 0  // ms
    var hashPass: String = ""
    
    var roomID: Int = 0
    var userCount: Int = 0
    var roomName: String = ""
    
    var longitude: Double = 0
    var latitude: Double = 0
    
    var backGroundImgURL: String = ""
    var adURL: String? = ""

    
    init(channelID: Int = 0, channelName: String, roomID: Int, roomName: String = "", userCount: Int = 0, createTime: Double = 0, longitude: Double, latitude: Double, channelType: Int = 1, backgroundImg: String, hashPass: String = "", adURL: String? = "") {
        self.channelID = channelID
        self.channelName = channelName
        self.roomID = roomID
        self.roomName = roomName
        self.userCount = userCount
        
        self.createTime = createTime
        
        self.longitude = longitude
        self.latitude = latitude
        
//        self.channelIndex = channelIndex
        self.channelType = ChannelType(rawValue: channelType)!
        
        self.backGroundImgURL = backgroundImg
        self.adURL = adURL
        
        
        self.hashPass = hashPass
    }
}


enum ChannelType: Int {
    case pub = 1, featured = 2, custom = 4
}


struct ChannelInfo {
    var name: String
    var venueID: String = ""
    var longitude: Double
    var latitude: Double
    var distance: Int
    var address: String = ""
    var imageURL: String = ""
    var channelType: Int = 1
    var adURL: String?
    var hashPass: String = ""
}
