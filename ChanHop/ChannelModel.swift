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
    
    var roomID: Int = 0
//    var roomName: String = ""
    
    var longitude: Double = 0
    var latitude: Double = 0
    
    var backGroundImgURL: String = ""

    
    init(channelID: Int = 0, channelName: String, roomID: Int, roomName: String = "", longitude: Double, latitude: Double, channelType: Int = 1, backgroundImg: String) {
        self.channelID = channelID
        self.channelName = channelName
        self.roomID = roomID
//        self.roomName = roomName
        self.longitude = longitude
        self.latitude = latitude
        
//        self.channelIndex = channelIndex
        self.channelType = ChannelType(rawValue: channelType)!
        
        self.backGroundImgURL = backgroundImg
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
    
}
