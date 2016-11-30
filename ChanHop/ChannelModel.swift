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
    var channelName: String = ""
    var rooms: [RoomModel] = []
    
    
    func configureChannel (_ response: NSDictionary) {
        if let channelIndex = response.value(forKey: "channelIndex") {
            self.channelIndex = channelIndex as! Int
        }
        if let channelName = response.value(forKey: "channelName") {
            self.channelName = channelName as! String
        }
        // todo: set rooms
    }
}


enum ChannelType: Int {
    case pub = 0, custom, priv
}
