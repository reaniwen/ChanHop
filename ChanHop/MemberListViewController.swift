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
    
    var members: [Member] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memberTable.dataSource = self
        memberTable.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // get memebers in the list
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backToMainAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        cell.textLabel?.textColor = UIColor.black
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
