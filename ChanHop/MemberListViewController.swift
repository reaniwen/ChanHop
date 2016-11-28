//
//  MemberListViewController.swift
//  ChanHop
//
//  Created by Rean Wen on 11/17/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit

class MemberListViewController: UIViewController {

    @IBOutlet weak var memberTable: UITableView!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var memberAmountLabel: UILabel!
    
    var members: [Member] = [Member(name: "abdc", color:"000000")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memberTable.dataSource = self
        memberTable.delegate = self
        memberTable.backgroundColor = UIColor.clear
        memberTable.tableFooterView = UIView()
        
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
        // todo: get memebers in the list
        
        memberAmountLabel.text = "\(members.count)/25"
    }
    
    func handleSwipe(){}
    func handleSingleSwipe(){}

    @IBAction func backToMainAct(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
}


extension MemberListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = members[indexPath.row].name
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
}

class Member {
    var name: String
    var color: String
    init(name: String, color: String) {
        self.name = name
        self.color = color
    }
}
