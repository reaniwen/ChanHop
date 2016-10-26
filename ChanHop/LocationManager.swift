//
//  LocationManager.swift
//  ChanHop
//
//  Created by Rean Wen on 10/26/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class LocationManager: NSObject {
//    let center = NSNotificationCenter.defaultCenter
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if UIApplication.shared.applicationState == .background {
            
        } else {
            NSNotificationCenter.default.
        }
    }
}
