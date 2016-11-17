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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memberTable.dataSource = self
        memberTable.delegate = self
        // Do any additional setup after loading the view.
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
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
}
