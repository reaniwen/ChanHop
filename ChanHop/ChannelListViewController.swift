//
//  ChannelListViewController.swift
//  ChanHop
//
//  Created by Rean Wen on 11/1/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChannelListViewController: UIViewController {
    
    @IBOutlet weak var channelTable: UITableView!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let connectionManager = ConnectionManager.shared
    let userManager: UserManager = UserManager.shared
    
    weak var joinChannelDelegate: JoinChannelDelegate? = nil // channelviewcontroller
    
    var locations:[ChannelInfo] = []
    var filtered: [ChannelInfo] = []
    
    var inSearchMode = false
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        channelTable.dataSource = self
        channelTable.delegate = self
        channelTable.backgroundColor = UIColor.clear
        
        if let channel = Singleton.shared.channel {
            channelNameLabel.text = channel.channelName
            roomNameLabel.text = channel.roomName
        }
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        
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

extension ChannelListViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  {
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let amount = inSearchMode ? filtered.count : locations.count
        return amount+1 //locations.count
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
            let tempData = inSearchMode ? filtered : locations
            let channelTypes = ["","PUBLIC CHANNEL", "FEATURED CHANNEL","","CUSTOM CHANNEL"]
//            cell.nameLabel.text = "\(self.locations[row].name)"// (\(self.locations[row].address))"
//            cell.distanceLabel.text = String(self.locations[row].distance) + "m"
//            cell.nameLabel.textColor = UIColor.white
//            cell.distanceLabel.textColor = UIColor.white
//            
//            if self.locations[row].channelType < 4{
//                print(row, self.locations[row].channelType,channelTypes[self.locations[row].channelType])
//                cell.categoryLabel.text = channelTypes[self.locations[row].channelType]
//            }
            cell.nameLabel.text = "\(tempData[row].name)"// (\(self.locations[row].address))"
            cell.distanceLabel.text = String(tempData[row].distance) + "m"
            cell.nameLabel.textColor = UIColor.white
            cell.distanceLabel.textColor = UIColor.white
            
            if tempData[row].channelType < 4{
                print(row, tempData[row].channelType,channelTypes[tempData[row].channelType])
                cell.categoryLabel.text = channelTypes[tempData[row].channelType]
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let location = UserDefaults.standard.dictionary(forKey: CURRENT_LOC)
            let localHopInfo = ChannelInfo(name: "localHop", venueID: "", longitude: location!["longitude"] as! Double, latitude: location!["latitude"] as! Double, distance: 0, address: "", imageURL: "", channelType: 3, adURL: nil, hashPass: "")
            self.joinChannelDelegate?.joinChannelAct(channelInfo: localHopInfo, userName: userManager.userName, password: "", custom: false)
            self.backToMainAct(self)
        } else {
            let location = locations[indexPath.row - 1]
            if location.hashPass != "" {
                // custom channel w/ password
                if let channelVC = self.parent as? ChannelViewController {
                    self.removeFromParentViewController()
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PasswordVC") as? PasswordVC {
                        vc.joinChannelDelegate = self.joinChannelDelegate
                        vc.channelInfo = location
                        backToMainAct(self)
                        channelVC.addChildViewController(vc)
                        channelVC.view.addSubview(vc.view)
                    }
                } else {
                    SVProgressHUD.showError(withStatus: "Try later")
                }
            } else {
                var custom = false
                if locations[indexPath.row-1].channelType == 4 {
                    custom = true
                }
                self.joinChannelDelegate?.joinChannelAct(channelInfo: locations[indexPath.row-1], userName: userManager.userName, password: "", custom: custom)
                self.backToMainAct(self)
            }
            
        }
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            searchBar.text = nil
            //  self.preferredContentSize.height = 50
            //  self.dismiss(animated: true, completion: nil)
            
            //All public/featured channels (no private)
            locations = Singleton.shared.featuredChannelInfos + Singleton.shared.channelInfos
            channelTable.reloadData()
            
        } else {
            inSearchMode = true
            //   self.preferredContentSize.height = 90
            
            //All channels (including private)
            
            locations = Singleton.shared.featuredChannelInfos + Singleton.shared.channelInfos + Singleton.shared.customChannelInfo
            
            filtered = locations.filter { group in
                return group.name.lowercased().contains(searchText.lowercased())
                
                //group.groupName.lowercased().contains(searchText.lowercased())
            }
            
            channelTable.reloadData()
        }
    }
}
