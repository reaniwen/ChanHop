//
//  RoomViewController.swift
//  ChanHop
//
//  Created by Rean Wen on 10/21/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController {
    
    @IBOutlet weak var roomNameView: UIView!
    @IBOutlet weak var roomNameLabel: UILabel!
    
    var chatView: UIView!
    
    var roomID: Int! = 0
    
    var singleton: Singleton = Singleton.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let id = singleton.channel?.roomID{
            roomID = id
            roomNameLabel.text = singleton.channel?.roomName
        } else {
            roomNameLabel.text = "Room " + String(roomID)
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ChatViewController {
        
//            self.view.addSubview(roomNameView)
            self.addChildViewController(chatVC)
            chatView = chatVC.view
            self.view.addSubview(chatView)
        }
    }
    
    override func viewDidLayoutSubviews() {
        if chatView != nil {
            let frame = self.view.frame
            chatView.frame = CGRect(x: frame.origin.x, y: frame.origin.y + 30, width: frame.width, height: frame.height - 30)
            self.view.bringSubview(toFront: roomNameView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
