//
//  ChannelViewController.swift
//  ChanHop
//
//  Created by Rean Wen on 10/21/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit
import SVProgressHUD

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
//    var channelName: String! = ""

    let connectionManager = ConnectionManager.shared
    
    let userManager = UserManager.shared
    let singleton = Singleton.shared
    
    weak var joinChannelDelegate: JoinChannelDelegate? = nil // channelPagevc
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateAmountBtn), name: NSNotification.Name(rawValue: UPDATE_USER_COUNT), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(joinChannelNotification), name: NSNotification.Name(rawValue:JOIN_CHANNEL), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserCount), name: NSNotification.Name(rawValue:S_UPDATE_COUNT), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setChannelBtn()
        addMaskGesture()
        
        backgroundMask.isHidden = true
        enterBtn.setTitle("Update Name", for: .normal)
        
        if userManager.userID == 0 || userManager.userName == "" {
            self.showMenu(self)
            enterBtn.setTitle("Enter Room", for: .normal)
            cancelBtn.isHidden = true
            
        }
        
        roomVC?.removeFromParentViewController()
        roomVC = self.storyboard?.instantiateViewController(withIdentifier: "RoomPageVC") as? RoomPageVC
        if let vc = roomVC {
            roomView = vc.view
            self.addChildViewController(roomVC!)
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
        
        self.view.bringSubview(toFront: backgroundMask)
        
    }
    
    
    func moveToNextRoom(_ gesture: UISwipeGestureRecognizer) {
        if let vc = roomVC {
            vc.moveToNextRoom(gesture)
        }
    }
    
    func setChannelBtn() {
        if let channel = singleton.channel {
            channelBtn.setTitle(channel.channelName, for: .normal)
            memberBtn.setTitle(String(channel.userCount), for: .normal)
        } else {
            channelBtn.setTitle("Welcom to ChanHop", for: .normal)
        }
    }
    
    func updateUserCount(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let amount = userInfo["amount"] as? Int else {
                return
        }
        
        memberBtn.setTitle(String(amount), for: .normal)
    }
    
    func updateAmountBtn(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let amount = userInfo["amount"] as? Int else {
                return
        }
        
        memberBtn.setTitle(String(amount), for: .normal)
    }


    @IBAction func EnterRoomAct(_ sender: Any) {
        var name = nameTextField.text?.replacingOccurrences(of: " ", with: "")
        if name?.characters.count != 0 {
//            singleton.userName = name!
            if userManager.userID == 0 || userManager.userName == "" {
                print("Enter room")
                if let location = UserDefaults.standard.dictionary(forKey: CURRENT_LOC) {
                    let localHopInfo = ChannelInfo(name: "localHop", venueID: "", longitude: location["longitude"] as! Double, latitude: location["latitude"] as! Double, distance: 0, address: "", imageURL: "", channelType: 3, adURL: nil)
                    self.joinChannelAct(channelInfo: localHopInfo, userName: name!)
                } else {
                    // Popup an info to get user to allow location
                    SVProgressHUD.showError(withStatus: "Please allow location in setting")
                }
            } else {
                // todo: change name function
                print("Update name, \(name!)")
            }
        } else {
            // Popup to show user to enter a legal name
            SVProgressHUD.showError(withStatus: "Please input a legal name")
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
    // todo: it triggered twice, I have no idea why
    // but I think that would be a issue
    func joinChannelNotification(notification: Notification) {
        let userinfo = notification.userInfo
        if let name = userinfo?["name"] as? String, let password = userinfo?["password"] as? String {
            // todo: coordination, userName
            let userName = UserManager.shared.userName
            if let location = UserDefaults.standard.dictionary(forKey: CURRENT_LOC) {
                let channelinfo = ChannelInfo(name: name, venueID: "", longitude: location["longitude"] as! Double, latitude: location["latitude"] as! Double, distance: 0, address: "", imageURL: "", channelType: 4, adURL: nil)
                joinChannelAct(channelInfo: channelinfo, userName: userName, password: password, custom: true)
                print("notification join channel")
            }
        }
    }
    
    func joinChannelAct(channelInfo: ChannelInfo, userName: String = "", password: String = "", custom: Bool = false) {
        if let delegate = self.joinChannelDelegate {
            delegate.joinChannelAct(channelInfo: channelInfo, userName: userName, password: password, custom: custom)
        }
    }
}
