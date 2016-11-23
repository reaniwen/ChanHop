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
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    
    let connectionManager = ConnectionManager.shared
    
    var locations:[FourSquareLocation] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        channelTable.dataSource = self
        channelTable.delegate = self
        channelTable.backgroundColor = UIColor.clear
        
        connectionManager.getFourSquareRoom { res,locations in
            print("finished")
            weak var weakSelf = self
            weakSelf?.locations = locations
            weakSelf?.channelTable.reloadData()
        }
        
        let singleSwipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSingleSwipe))
        singleSwipeLeft.direction = .left
        singleSwipeLeft.numberOfTouchesRequired = 1
        
        let singleSwipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSingleSwipe))
        singleSwipeRight.direction = .right
        singleSwipeRight.numberOfTouchesRequired = 1
        
        let doubleSwipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        doubleSwipeLeft.direction = .left
        doubleSwipeLeft.numberOfTouchesRequired = 2
        
        let doubleSwipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        doubleSwipeRight.direction = .right
        doubleSwipeRight.numberOfTouchesRequired = 2
        
        self.view.addGestureRecognizer(singleSwipeLeft)
        self.view.addGestureRecognizer(singleSwipeRight)
        
        self.view.addGestureRecognizer(doubleSwipeLeft)
        self.view.addGestureRecognizer(doubleSwipeRight)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backToMainAct(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    func handleSwipe(){}
    func handleSingleSwipe(){}
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(locations[indexPath.row].name)
        
    }
    
    // Todo: remove the responder on the search bar
}
