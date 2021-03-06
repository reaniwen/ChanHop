//
//  AppDelegate.swift
//  ChanHop
//
//  Created by Rean Wen on 10/18/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit
import CoreLocation
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var locationManager: CLLocationManager!
    
    lazy var singleton: Singleton = Singleton.shared
    lazy var connectionManager: ConnectionManager = ConnectionManager.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
//        SocketIOManager.shared.establishConnection()
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        locationManager.stopUpdatingLocation()
        let interval = NSDate().timeIntervalSince1970
        if let channel = Singleton.shared.channel {
            SocketIOManager.shared.leaveRoom(roomName: channel.roomName, userName: UserManager.shared.userName, created_at: interval)
        }
        SocketIOManager.shared.closeConnection();
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        locationManager.startUpdatingLocation()
        SocketIOManager.shared.establishConnection()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Got token data! (deviceToken)")
        let characterSet: CharacterSet = CharacterSet(charactersIn: "<>")
        
        let deviceTokenString:String = (deviceToken.description as NSString )
            .trimmingCharacters(in: characterSet)
            .replacingOccurrences(of: " ", with: "")
        
        print(deviceTokenString)
    }


}

extension AppDelegate: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedAlways {
//            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
//                if CLLocationManager.isRangingAvailable() {
//                    // do stuff
//                }
//            }
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if UIApplication.shared.applicationState == .background {
            
        } else {
            if let coordinate = manager.location?.coordinate {
                if singleton.lastRequestLocation == nil {
                    singleton.lastRequestLocation = manager.location
                }
                let location = ["latitude": coordinate.latitude as Double, "longitude": coordinate.longitude as Double]
//                NotificationCenter.default.post(name: NSNotification.Name(UPDATE_LOC), object: self, userInfo: location)
                UserDefaults.standard.set(location, forKey: CURRENT_LOC)
//                print(UserDefaults.standard.dictionary(forKey: CURRENT_LOC))
                let distance = manager.location?.distance(from: singleton.lastRequestLocation!)
                if Double(distance!) > Double(5000) {
                    connectionManager.getChannels() { _ in
                        
                    }
                }
            } else {
                print("get location error")
                // Todo: get location error
            }
        }
    }
}

