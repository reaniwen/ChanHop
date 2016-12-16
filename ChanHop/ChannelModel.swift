//
//  ChannelModel.swift
//  ChanHop
//
//  Created by Rean Wen on 10/24/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import Foundation

class ChannelModel: NSObject {
    var channelType: ChannelType = .pub
    var channelIndex: Int = 0
    var channelID: String = ""
    var channelName: String = ""
    
    var longitude: Double = 0
    var latitude: Double = 0
    
    var backGroundImgURL: String = ""
    
    var rooms: [RoomModel] = []
    
    
//    func configureChannel (_ response: NSDictionary) {
//        if let channelIndex = response.value(forKey: "channelIndex") {
//            self.channelIndex = channelIndex as! Int
//        }
//        if let channelName = response.value(forKey: "channelName") {
//            self.channelName = channelName as! String
//        }
//        // todo: set rooms
//    }
    
    init(channelID: String, channelName: String, longitude: Double, latitude: Double, channelIndex: Int = 0, channelType: Int = 1, backgroundImg: String) {
        self.channelID = channelID
        
        self.channelName = channelName
        self.longitude = longitude
        self.latitude = latitude
        
        self.channelIndex = channelIndex
        self.channelType = ChannelType(rawValue: channelType)!
        
        self.backGroundImgURL = backgroundImg
    }
    
    func configureChannel(channelID: String, channelName: String, longitude: Double, latitude: Double, channelIndex: Int = 0, channelType: Int = 1) {
        self.channelID = channelID
        
        self.channelName = channelName
        self.longitude = longitude
        self.latitude = latitude
        
        self.channelIndex = channelIndex
        self.channelType = ChannelType(rawValue: channelType)!
    }
}


enum ChannelType: Int {
    case pub = 1, featured = 2, custom = 4
}


struct ChannelInfo {
    var name: String
    var id: String = ""
    var longitude: Double
    var latitude: Double
    var distance: Int
    var address: String = ""
    var imageURL: String = ""
    var channelType: Int = 1
    
}
