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
    
}
