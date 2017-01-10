//
//  TagListVC.swift
//  ChanHop
//
//  Created by Rean on 1/10/17.
//  Copyright © 2017 Rean Wen. All rights reserved.
//

import UIKit

class TagListVC: UIViewController {
    
    @IBOutlet weak var listTable: UITableView!
    
    let singleton = Singleton.shared
    let connectionManager = ConnectionManager.shared
    
    var list: [ChannelInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        listTable.delegate = self
        listTable.dataSource = self
        
        
        connectionManager.getChannels { res, locations in
            self.list = Singleton.shared.featuredChannelInfos + Singleton.shared.channelInfos + Singleton.shared.customChannelInfo
            self.listTable.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backToMainAct(_ sender: Any) {
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: CANCEL_TAG), object: nil)
    }
}

extension TagListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = list[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channelName = list[indexPath.row].name
        let longitude = list[indexPath.row].longitude
        let latitude = list[indexPath.row].latitude
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SELECT_TAG), object: nil, userInfo: ["channelName": channelName, "longitude": longitude, "latitude":latitude])
    }
}
