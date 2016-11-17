//
//  ChannelViewController.swift
//  ChanHop
//
//  Created by Rean Wen on 10/21/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController {
    
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var channelBtn: UIButton!
    @IBOutlet weak var memberBtn: UIButton!
    
    var roomVC: RoomPageVC?
    var roomView: UIView!
    
    var channelID: Int! = 0
    var channelName: String! = ""

    let userManager = UserManager.shared
    let connectionManager = ConnectionManager.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(configureChannel), name: NSNotification.Name(rawValue: CHANNEL_NAME), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        roomVC?.removeFromParentViewController()
        roomVC = self.storyboard?.instantiateViewController(withIdentifier: "RoomPageVC") as? RoomPageVC
        if let vc = roomVC {
            roomView = vc.view
            self.addChildViewController(roomVC!)
            self.view.addSubview(roomView)
        }
        
        
        setChannelBtn()
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
    
    
    func handleGesture(_ gesture: UISwipeGestureRecognizer) {
        if let vc = roomVC {
            vc.moveToNextRoom(gesture)
        }
    }
    
    func setChannelBtn() {
        if channelName == "" {
            channelBtn.setTitle("Channel " + String(channelID), for: .normal)
        } else {
            channelBtn.setTitle(channelName, for: .normal)
        }
    }
    
    func configureChannel(notification: Notification) {
        let userInfo = notification.userInfo
        if let channelName:String = userInfo?["channelName"] as? String {
            self.channelName = channelName
            self.setChannelBtn()
        }
    }
    
    deinit {
//        self.removeno
        NotificationCenter.default.removeObserver(self)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
   

// MARK: - Defination of three buttons
    @IBAction func settingAct(_ sender: AnyObject) {
        print("Setting button pressed")
//        userManager.checkAndJoinRoomInChannel(latitude: 40.757309271122942, longitude: -73.983339379290399, channelName: "LocalHop") { channelName in
//            self.channelName = channelName
//        }
    }
    
    @IBAction func memberAct(_ sender: AnyObject) {
        print("Room member button pressed")
        
        
//        userManager.userLeaveRoom(channel: self.channelName)
    }
    
    @IBAction func showChannelListAct(_ sender: AnyObject) {
        print("Show channel list button pressed")
    }
}
