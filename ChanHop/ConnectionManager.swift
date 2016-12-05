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
            let url = "\(FS_BASE_URL)client_id=\(FS_CLIENT_ID)&client_secret=\(FS_SECRET_KEY)&v=\(todayStr)&ll=\(coordination)&query=&limit=\(FS_QUERY_LIMIT)"
//            print(url)
            Alamofire.request(url, method: .get, parameters: nil)
                .responseJSON { response in
                    switch response.result {
                    case .success(let JSONData):
                        let data = JSON(JSONData)
//                        print(data["response","venues","0"])
                        var locations: [FourSquareLocation] = []
                        for i in 0..<data["response","venues"].count {
                            let locData = data["response","venues",i]
                            let location = FourSquareLocation(name: locData["name"].stringValue, longitude: locData["location","lng"].doubleValue, latitude: locData["location","lat"].doubleValue, distance: locData["location","distance"].intValue, address: locData["location","address"].stringValue, imageURL: "")
                        
                            locations.append(location)
                        }
                        completion(true, locations)
                    case .failure(let error):
                        print(error.localizedDescription)
                        completion(false, [])
                    }
                    
                }
//                .responseString { response in
//                    print(response.result)
//            }
        }
        
    }
    
    func getChannels(completion: @escaping(_ res: Bool, _ locations:[FourSquareLocation]) -> Void) {
        if let location: [String: Double] = UserDefaults.standard.dictionary(forKey: CURRENT_LOC) as? [String: Double] {
            let url = "http://chanhop-test.us-east-1.elasticbeanstalk.com/api/v1/getchannels/\(location["latitude"]!)/\(location["longitude"]!)"
            print(url)
            Alamofire.request(url, method: .get, parameters: nil)
                .responseJSON {response in
                    switch response.result {
                    case .success(let JSONData):
                        let data = JSON(JSONData)
//                        print("response code \(data["status"].intValue), total rev is \(data["channels"].count)")
                        var locations: [FourSquareLocation] = []
                        for i in 0..<data["channels"].count {
                            let locData = data["channels", i]
                            let location = FourSquareLocation(name: locData["name"].stringValue, longitude: locData["longitude"].doubleValue, latitude: locData["latitude"].doubleValue, distance: locData["distance"].intValue, address: "", imageURL: "")
                            
                            locations.append(location)
                        }
                        completion(true, locations)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                .responseString {response in
                    print("result is \(response.result.value)")
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
    var imageURL: String = ""
}
