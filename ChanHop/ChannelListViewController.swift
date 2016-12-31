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
    let userManager: UserManager = UserManager.shared
    
    weak var joinChannelDelegate: JoinChannelDelegate? = nil // channelviewcontroller
    
    var locations:[ChannelInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        channelTable.dataSource = self
        channelTable.delegate = self
        channelTable.backgroundColor = UIColor.clear
        
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        connectionManager.getChannels { res,locations in
            //            print("Finish getting channels from four square")
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
        self.joinChannelDelegate = nil
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
        let row = indexPath.row - 1
        let cell: NearbyVenueTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NearbyVenueTableViewCell", for: indexPath) as! NearbyVenueTableViewCell
        if row < 0 {
            cell.nameLabel.text = "Local Hop"
            cell.distanceLabel.text = "0.0m"
            let color = UIColor(red: 147/255, green: 222/255, blue: 49/255, alpha: 1)
            cell.nameLabel.textColor = color
            cell.distanceLabel.textColor = color
        } else {
            let channelTypes = ["","PUBLIC CHANNEL", "FEATURED CHANNEL","","CUSTOM CHANNEL"]
            cell.nameLabel.text = "\(self.locations[row].name)"// (\(self.locations[row].address))"
            cell.distanceLabel.text = String(self.locations[row].distance) + "m"
            cell.nameLabel.textColor = UIColor.white
            cell.distanceLabel.textColor = UIColor.white
            
            if self.locations[row].channelType < 4{
                print(row, self.locations[row].channelType,channelTypes[self.locations[row].channelType])
                cell.categoryLabel.text = channelTypes[self.locations[row].channelType]
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.joinChannelDelegate?.joinChannelAct(channelInfo: locations[indexPath.row-1], userName: userManager.userName)
        self.backToMainAct(self)
    }
    
    // Todo: remove the responder on the search bar
}
