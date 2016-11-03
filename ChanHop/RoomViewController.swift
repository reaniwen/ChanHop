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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        roomNameLabel.text = "Room" + String(roomID)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
        
            self.view.addSubview(roomNameView)
            self.addChildViewController(chatVC)
            chatView = chatVC.view
            self.view.addSubview(chatView)
//            self.present(chatVC, animated: true, completion: nil)
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
