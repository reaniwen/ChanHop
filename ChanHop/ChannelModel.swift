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
    
    func configureChannel(channelID: String, channelName: String, longitude: Double, latitude: Double, channelIndex: Int = 0) {
        self.channelID = channelID
        
        self.channelName = channelName
        self.longitude = longitude
        self.latitude = latitude
        
        self.channelIndex = channelIndex
        // Todo: set room
        
    }
}


enum ChannelType: Int {
    case pub = 0, custom, priv
}
