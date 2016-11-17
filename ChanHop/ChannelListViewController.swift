//
//  ChannelListViewController.swift
//  ChanHop
//
//  Created by Rean Wen on 11/1/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit

class ChannelListViewController: UIViewController {
    
    @IBOutlet weak var channelTable: UITableView!
    
    let connectionManager = ConnectionManager.shared
    
    var locations:[FourSquareLocation] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        channelTable.dataSource = self
        channelTable.delegate = self
        
        connectionManager.getFourSquareRoom { res,locations in
            print("finished")
            weak var weakSelf = self
            weakSelf?.locations = locations
            weakSelf?.channelTable.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backToMainAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ChannelListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NearbyVenueTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NearbyVenueTableViewCell", for: indexPath) as! NearbyVenueTableViewCell
        cell.nameLabel.text = "\(self.locations[indexPath.row].name) (\(self.locations[indexPath.row].address))"
        cell.distanceLabel.text = String(self.locations[indexPath.row].distance) + "m"
        
        return cell
    }
    
    // Todo: remove the responder on the search bar
}
