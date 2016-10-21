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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController {
            
//                        self.view.addSubview(roomNameView)
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
        
        print("here");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
