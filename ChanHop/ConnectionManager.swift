//
//  ConnectionManager.swift
//  ChanHop
//
//  Created by Rean Wen on 10/26/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ConnectionManager: NSObject {
    
    static let shared = ConnectionManager()
    
//    weak let userManager 
    
    func checkServer(completion: @escaping (_ status: Bool, _ info: String) -> Void) {
        Alamofire.request(CHANHOP_URL + "/checkserver", method: .get, parameters: nil)
            .responseJSON { response in
                switch response.result{
                case .success(let JSONdata):
                    let data = JSON(JSONdata)
                    if data["status"].stringValue == "200" {
                        completion(true, data["message"].stringValue)
                    } else {
                        completion(false, data["message"].stringValue)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(false, error.localizedDescription)
                }
        }
    }
    
    func getFourSquareRoom(completion: @escaping(_ res: Bool, _ locations:[FourSquareLocation]) -> Void) {
        if let location: [String: Double] = UserDefaults.standard.dictionary(forKey: CURRENT_LOC) as? [String: Double] {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            let todayStr = dateFormatter.string(from: Date())
            let coordination: String = "\(location["latitude"]!),\(location["longitude"]!)"
            Alamofire.request("\(FS_BASE_URL)client_id=\(FS_CLIENT_ID)&client_secret=\(FS_SECRET_KEY)&v=\(todayStr)&ll=\(coordination)&query=&limit=\(FS_QUERY_LIMIT)", method: .get, parameters: nil)
                .responseJSON { response in
                    switch response.result {
                    case .success(let JSONData):
                        let data = JSON(JSONData)
                        var locations: [FourSquareLocation] = []
                        for i in 0..<data["response","venues"].count {
                            let locData = data["response","venues",i]
                            let location = FourSquareLocation(name: locData["name"].stringValue, longitude: locData["location","lng"].doubleValue, latitude: locData["location","lat"].doubleValue, distance: locData["location","distance"].intValue, address: locData["location","address"].stringValue)
                        
                            locations.append(location)
                        }
                        completion(true, locations)
                    case .failure(let error):
                        print(error.localizedDescription)
                        completion(false, [])
                    }
                    
                }
                .responseString { response in
                    print(response.result)
            }
        }
        
    }
}

struct FourSquareLocation {
    var name: String
    var longitude: Double
    var latitude: Double
    var distance: Int
    var address: String = ""
}