//
//  Singleton.swift
//  ChanHop
//
//  Created by Rean Wen on 10/27/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit

class Singleton: NSObject {
    
    static let shared = Singleton()
    
//    var userID: Int = 0
//    var userName: String = ""
//    var user: UserManager? = nil
    
    
    var channel: ChannelModel? = nil
    
    var roomName: String = ""
}
