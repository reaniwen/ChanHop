//
//  ChannelViewController.swift
//  ChanHop
//
//  Created by Rean Wen on 10/21/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class ChannelViewController: UIViewController {
    
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var channelBtn: UIButton!
    @IBOutlet weak var memberBtn: UIButton!
    @IBOutlet weak var backgroundMask: UIView!
//    @IBOutlet weak var settingMenuView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var enterBtn: UIButton!
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adImage: UIImageView!
    
    var roomVC: RoomPageVC?
    var roomView: UIView!
    
    var channelID: Int! = 0
//    var channelName: String! = ""

    let connectionManager = ConnectionManager.shared
    
    let userManager = UserManager.shared
    let singleton = Singleton.shared
    
    var createdAt: Double = 0
    var timeLeft = 0
    var timer = Timer()
    
    weak var joinChannelDelegate: JoinChannelDelegate? = nil // channelPagevc
    
    
    // expiration group
    var expBackground: UIView!
    var expChannelLabel: UILabel!
    var expChannelNameLabel: UILabel!
    var expLastLabel: UILabel!
    var expOKBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateAmountBtn), name: NSNotification.Name(rawValue: UPDATE_USER_COUNT), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(joinChannelNotification), name: NSNotification.Name(rawValue:JOIN_CHANNEL), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserCount), name: S_UPDATE_COUNT, object: nil)
        
        adView.isHidden = true
        
        setExpirationView()
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
        
        if let url = singleton.channel?.adURL {
            adView.isHidden = false
            adImage.sd_setImage(with: URL(string: url))
        }
        
        if singleton.channel?.channelType.rawValue == 4 {
            createdAt = singleton.channel?.createTime ?? Double(Int.max)
            let channelEnd = createdAt/1000 + 24*60*60
            let date = Date()
            let currentTime = date.timeIntervalSince1970
            if channelEnd < currentTime {
                // show expired page directly
                self.expBackground.isHidden = false
            } else {
                let timeL = channelEnd - currentTime
                self.timeLeft = Int(timeL)
//                self.timeLeft = 5
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
            }
        }
        
    }
    
    func updateCounter() {
        if timeLeft > 0 {
            print("\(timeLeft) seconds until channel expired")
            timeLeft -= 1
        }else {
            print("no time left")
            self.expBackground.isHidden = false
            timer.invalidate()
        }
        
    }
    
    func setExpirationView() {
        // expriration group
        expBackground = UIView()
        expBackground.backgroundColor = UIColor(red: 5/255, green: 15/255, blue: 30/255, alpha: 0.86)
        expBackground.frame = self.view.frame
        expChannelLabel = UILabel()
        expChannelLabel.text = "-- YOUR CHANNEL --"
        expChannelLabel.textColor = UIColor.white
        expChannelLabel.textAlignment = .center
        expChannelNameLabel = UILabel()
        expChannelNameLabel.text = singleton.channel?.channelName ?? ""
        expChannelNameLabel.textColor = UIColor.white
        expChannelNameLabel.textAlignment = .center
        expChannelNameLabel.font = UIFont.boldSystemFont(ofSize: 31)
        expLastLabel = UILabel()
        expLastLabel.text = "HAS EXPIRED"
        expLastLabel.textColor = UIColor(red: 158/255, green: 228/255, blue: 74/255, alpha: 1)
        expLastLabel.textAlignment = .center
        expOKBtn = UIButton()
        expOKBtn.setBackgroundImage(UIImage(named: "LargeEnterBtn"), for: .normal)
        expOKBtn.setTitle("OKAY", for: .normal)
        expOKBtn.setTitleColor(UIColor.white, for: .normal)
        expOKBtn.addTarget(self, action: #selector(backToLocalhop), for: .touchUpInside)
        
        expBackground.addSubview(expChannelLabel)
        expBackground.addSubview(expChannelNameLabel)
        expBackground.addSubview(expLastLabel)
        expBackground.addSubview(expOKBtn)
        
        self.view.addSubview(expBackground)
    }
    
    override func viewDidLayoutSubviews() {
        if roomView != nil {
            let frame = self.view.frame
            roomView.frame = CGRect(x: frame.origin.x, y: frame.origin.y + 90, width: frame.width, height: frame.height - 90)
        }
        
        self.view.bringSubview(toFront: adView)
        self.view.bringSubview(toFront: backgroundMask)
        
        expChannelLabel.translatesAutoresizingMaskIntoConstraints = false
        expChannelNameLabel.translatesAutoresizingMaskIntoConstraints = false
        expLastLabel.translatesAutoresizingMaskIntoConstraints = false
        expOKBtn.translatesAutoresizingMaskIntoConstraints = false
        
        var par: UIView, son: UIView
        par = expBackground
        son = expChannelLabel
        applyX(son: son, par: par)
        var up = NSLayoutConstraint(item: son, attribute: .top, relatedBy: .equal, toItem: par, attribute: .top, multiplier: 1, constant: 150)
        par.addConstraint(up)

        son = expChannelNameLabel
        applyX(son: son, par: par)
        par = expChannelLabel
        up = NSLayoutConstraint(item: son, attribute: .top, relatedBy: .equal, toItem: par, attribute: .bottom, multiplier: 1, constant: 8)
        expBackground.addConstraint(up)
        
        son = expLastLabel
        par = expBackground
        applyX(son: son, par: par)
        par = expChannelNameLabel
        up = NSLayoutConstraint(item: son, attribute: .top, relatedBy: .equal, toItem: par, attribute: .bottom, multiplier: 1, constant: 8)
        expBackground.addConstraint(up)

        son = expOKBtn
        par = expBackground
        applyX(son: son, par: par)
        par = expLastLabel
        
        up = NSLayoutConstraint(item: son, attribute: .top, relatedBy: .equal, toItem: par, attribute: .bottom, multiplier: 1, constant: 30)
        expBackground.addConstraint(up)
        
        let height = NSLayoutConstraint(item: son, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        son.addConstraint(height)
        
        self.view.bringSubview(toFront: expBackground)
        self.expBackground.isHidden = true
        
    }
    
    func applyX(son: UIView, par: UIView) {
        let left = NSLayoutConstraint(item: son, attribute: .leading, relatedBy: .equal, toItem: par, attribute: .leading, multiplier: 1, constant: 10)
        let x = NSLayoutConstraint(item: son, attribute: .centerX, relatedBy: .equal, toItem: par, attribute: .centerX, multiplier: 1, constant: 0)
        par.addConstraints([left, x])
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
                print("Enter room button pressed")
                if let location = UserDefaults.standard.dictionary(forKey: CURRENT_LOC) {
                    let localHopInfo = ChannelInfo(name: "localHop", venueID: "", longitude: location["longitude"] as! Double, latitude: location["latitude"] as! Double, distance: 0, address: "", imageURL: "", channelType: 3, adURL: nil, hashPass: "")
                    self.joinChannelAct(channelInfo: localHopInfo, userName: name!)
                } else {
                    // Popup an info to get user to allow location
                    SVProgressHUD.showError(withStatus: "Please allow location in setting")
                }
            } else {
//                print("Update name, \(name!)")
                connectionManager.updateName(userId: userManager.userID, userName: name!) { _ in
                    self.userManager.userName = name!
                }
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
        nameTextField.resignFirstResponder()
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
    @IBAction func closeAdAct(_ sender: Any) {
        self.adView.isHidden = true
    }
    
    func backToLocalhop() {
        let location = UserDefaults.standard.dictionary(forKey: CURRENT_LOC)
        let localhop = ChannelInfo(name: "localHop", venueID: "", longitude: location!["longitude"] as! Double, latitude: location!["latitude"] as! Double, distance: 0, address: "", imageURL: "", channelType: 3, adURL: nil, hashPass: "")
        self.joinChannelAct(channelInfo: localhop, userName: userManager.userName, password: "", custom: false)
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
        if let channelName = userinfo?["name"] as? String, let password = userinfo?["password"] as? String, let longitude = userinfo?["longitude"] as? Double, let latitude = userinfo?["latitude"] as? Double, let channelType = userinfo?["channelType"] as? Int{
            let userName = UserManager.shared.userName
//            if let location = UserDefaults.standard.dictionary(forKey: CURRENT_LOC) {
            let channelinfo = ChannelInfo(name: channelName, venueID: "", longitude: longitude, latitude: latitude, distance: 0, address: "", imageURL: "", channelType: channelType, adURL: nil, hashPass: password)
                joinChannelAct(channelInfo: channelinfo, userName: userName, password: password, custom: true)
                print("notification join channel")
//            }
        }
    }
    
    func joinChannelAct(channelInfo: ChannelInfo, userName: String = "", password: String = "", custom: Bool = false) {
        if let delegate = self.joinChannelDelegate {
            delegate.joinChannelAct(channelInfo: channelInfo, userName: userName, password: password, custom: custom)
        }
    }
}
