//
//  Constants.swift
//  ChanHop
//
//  Created by Rean Wen on 10/26/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import Foundation
import UIKit

let CHANHOP_URL = "http://chanhop-test.us-east-1.elasticbeanstalk.com/api/v1"
let SOCKETIO_URL = "http://chanhop-test.us-east-1.elasticbeanstalk.com/"
let AD_BASE_URL = "https://s3.amazonaws.com/chanhop-ad/"

let CURRENT_LOC = "com.chanhop.currentLocation"         // for userdefault
let FINISH_TUTORIAL = "com.chanhop.finishTutorial"      // for userdefault

let UPDATE_USER_COUNT = "com.chanhop.updateusercount"

//let UPDATE_LOC = "com.chanhop.updateLocation"           // for notification
//let CHANNEL_NAME = "com.chanhop.getChannelName"         // for notification

let JOIN_CHANNEL = "com.chanhop.joinChannel"              // notification

let S_UPDATE_COUNT = Notification.Name("com.chanhop.newUserJoin")                  // notification
let S_NEW_MESSAGE = Notification.Name("com.chanhop.newMessage")                // notification
let S_USER_LEAVE = Notification.Name("com.chanhop.userLeaves")                    // notification

let SELECT_TAG = "com.chanhop.selectTag"
let CANCEL_TAG = "com.chanhop.cancelTag"



