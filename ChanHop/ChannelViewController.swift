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
        
//        NotificationCenter.default.addObserver(self, selector: #selector(configureChannel), name: NSNotification.Name(rawValue: CHANNEL_NAME), object: nil)
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
        } else {
            channelBtn.setTitle("Welcom to ChanHop", for: .normal)
        }
    }

    @IBAction func EnterRoomAct(_ sender: Any) {
        var name = nameTextField.text?.replacingOccurrences(of: " ", with: "")
        if name?.characters.count != 0 {
//            singleton.userName = name!
            if userManager.userID == 0 || userManager.userName == "" {
                print("Enter room")
                if let location = UserDefaults.standard.dictionary(forKey: CURRENT_LOC) {
                    let localHopInfo = ChannelInfo(name: "localHop", id: "", longitude: location["longitude"] as! Double, latitude: location["latitude"] as! Double, distance: 0, address: "", imageURL: "", channelType: 3)
                    self.joinChannelAct(channelInfo: localHopInfo)
                } else {
                    // Popup an info to get user to allow location
                    SVProgressHUD.showError(withStatus: "Please allow location in setting")
                }
                
            } else {
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
    func joinChannelAct(channelInfo: ChannelInfo) {
        if let delegate = self.joinChannelDelegate {
            delegate.joinChannelAct(channelInfo: channelInfo)
        }
    }
}
