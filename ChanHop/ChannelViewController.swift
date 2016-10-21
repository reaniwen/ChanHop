//
//  ChannelViewController.swift
//  ChanHop
//
//  Created by Rean Wen on 10/21/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController {
    
    var roomVC: RoomPageVC?
    var roomView: UIView!
    
    var channelID: Int! = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }
    
    override func viewWillAppear(_ animated: Bool) {
        roomVC = self.storyboard?.instantiateViewController(withIdentifier: "RoomPageVC") as? RoomPageVC
        if let vc = roomVC {
            roomView = vc.view
            self.view.addSubview(roomView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        if roomView != nil {
            let frame = self.view.frame
            roomView.frame = CGRect(x: frame.origin.x, y: frame.origin.y + 90, width: frame.width, height: frame.height - 90)
        }
    }
    
    
    func handleGesture(gesture: UISwipeGestureRecognizer) {
        if let vc = roomVC {
            vc.moveToNextRoom(gesture: gesture)
        }
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
