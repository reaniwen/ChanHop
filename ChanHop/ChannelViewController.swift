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
    @IBOutlet weak var backgroundMask: UIView!
//    @IBOutlet weak var settingMenuView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var enterBtn: UIButton!
    
    var roomVC: RoomPageVC?
    var roomView: UIView!
    
    var channelID: Int! = 0
    var channelName: String! = ""

    let userManager = UserManager.shared
    let connectionManager = ConnectionManager.shared
    let singleton = Singleton.shared
    
    weak var joinChannelDelegate: JoinChannelDelegate? = nil
    
    weak var menuViewController: UIViewController? = nil
    
    
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
        addMaskGesture()
        
        backgroundMask.isHidden = true
        enterBtn.setTitle("Update Name", for: .normal)
        if singleton.userID == 0 || singleton.user == nil {
            self.showMenu(self)
            enterBtn.setTitle("Enter Room", for: .normal)
            cancelBtn.isHidden = true
            
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
        
        self.view.bringSubview(toFront: backgroundMask)
        
    }
    
    
    func moveToNextRoom(_ gesture: UISwipeGestureRecognizer) {
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

    @IBAction func EnterRoomAct(_ sender: Any) {
        if singleton.userID == 0 || singleton.user == nil {
            print("enter room")
        } else {
            print("update name")
        }
    }

    // MARK: - Defination of three buttons
    @IBAction func showMenu(_ sender: AnyObject) {
        self.backgroundMask.isHidden = false
    }
    
    @IBAction func hideMenu() {
        self.backgroundMask.isHidden = true
    }
    
    @IBAction func memberAct(_ sender: AnyObject) {
        print("Room member button pressed")
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MemberListViewController") {
            self.addChildViewController(vc)
            self.view.addSubview(vc.view)
        }
    }
    
    @IBAction func showChannelListAct(_ sender: AnyObject) {
        print("Show channel list button pressed")
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChannelListViewController") as? ChannelListViewController {
            vc.joinChannelDelegate = self
            self.addChildViewController(vc)
            self.view.addSubview(vc.view)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension ChannelViewController {
    func addMaskGesture() {
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
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(hideMenu))
        
        backgroundMask.addGestureRecognizer(singleSwipeLeft)
        backgroundMask.addGestureRecognizer(singleSwipeRight)
        backgroundMask.addGestureRecognizer(doubleSwipeLeft)
        backgroundMask.addGestureRecognizer(doubleSwipeRight)
//        backgroundMask.addGestureRecognizer(tap)
    }
    
    func handleSwipe(_ gestureRecognizer: UIGestureRecognizer) {}
    func handleSingleSwipe(_ gestureRecognizer: UIGestureRecognizer) {}

}

extension ChannelViewController: JoinChannelDelegate {
    func joinChannelAct(channelInfo: ChannelInfo) {
        if let delegate = self.joinChannelDelegate {
            delegate.joinChannelAct(channelInfo: channelInfo)
        }
    }
}
