//
//  ChannelPageVC.swift
//  ChanHop
//
//  Created by Rean Wen on 10/21/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//


import UIKit

class ChannelPageVC: UIPageViewController {
    
//    var currentIndex = 0
    weak var channelVC: ChannelViewController?
    
    let singleton = Singleton.shared
    let connectionManager = ConnectionManager.shared
    let userManager = UserManager.shared
    let socketIOManager = SocketIOManager.shared
    var channel: ChannelModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // jump to tutorial at the first time
        if UserDefaults.standard.bool(forKey: FINISH_TUTORIAL) == false{
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "TutorialViewController") as? TutorialViewController {
                self.present(vc, animated: false, completion: nil)
            }
        }
        
        // set data source to nil to set it without page
        dataSource = nil
        
        initGesture()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(updateLocation), name: NSNotification.Name(UPDATE_LOC), object: nil)s
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setViewControllers([getViewController()] as [UIViewController], direction: .forward, animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getViewController(name: String = "") -> ChannelViewController
    {
        let channelContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChannelViewController") as! ChannelViewController
        channelContentViewController.channelID = 0
        
        self.channelVC?.joinChannelDelegate = nil
        self.channelVC?.removeFromParentViewController()
        self.channelVC = channelContentViewController
        self.channelVC?.joinChannelDelegate = self
        self.addChildViewController(channelVC!)
        
//        channelContentViewController.channelName = name
        
        return channelContentViewController
    }
    
    // add gesture to the view controller
    func initGesture() {
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
        
        self.view.addGestureRecognizer(singleSwipeLeft)
        self.view.addGestureRecognizer(singleSwipeRight)
        
        self.view.addGestureRecognizer(doubleSwipeLeft)
        self.view.addGestureRecognizer(doubleSwipeRight)
    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }

}

// MARK: - Handle swipe
extension ChannelPageVC {
    func handleSwipe(_ gestureRecognizer: UIGestureRecognizer) {
        if let swipeGesture = gestureRecognizer as? UISwipeGestureRecognizer {
            print("Use \(gestureRecognizer.numberOfTouches) to swipe")
            moveToNextChannel(swipeGesture)
        }
    }
    
    func handleSingleSwipe(_ gestureRecognizer: UIGestureRecognizer) {
        if let swipeGesture = gestureRecognizer as? UISwipeGestureRecognizer {
            print("Use \(gestureRecognizer.numberOfTouches) to swipe")
            if let vc = channelVC {
                vc.moveToNextRoom(swipeGesture)
            }
        }
    }
    
    func moveToNextChannel(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.left:
            print("Swiping to previous channel")
            connectionManager.getPreviousChannel(direction: -1, channelName: (singleton.channel?.channelName)!) { channel in
                self.singleton.channel = channel
                self.setViewControllers([self.getViewController()] as [UIViewController], direction: .forward, animated: true, completion: nil)
                self.setViewControllers([self.getViewController()] as [UIViewController], direction: .forward, animated: true, completion: nil)
            }

            
        case UISwipeGestureRecognizerDirection.right:
            print("Swiping to next channel")
            connectionManager.getPreviousChannel(direction: 1, channelName: (singleton.channel?.channelName)!) { channel in
                self.singleton.channel = channel
                self.setViewControllers([self.getViewController()] as [UIViewController], direction: .forward, animated: true, completion: nil)
//                UIView.animate(withDuration: 2, animations: {
                self.setViewControllers([self.getViewController()] as [UIViewController], direction: .reverse, animated: true, completion: nil)
//                })
            }
//            UIView.animate(withDuration: 2, animations: {
//                self.setViewControllers([self.getViewController()], direction: .reverse, animated:true, completion: nil)
//            })
            
        default:
            break
        }
    }
}

extension ChannelPageVC: JoinChannelDelegate {
    func joinChannelAct(channelInfo: ChannelInfo, userName: String = "", password: String = "", custom: Bool = false) {
        print("channel Page vc got the command of change channel to \(channelInfo.name)")
        if let channel = singleton.channel {
            let userID = userManager.userID
            print(userID)
            if custom == false {
                connectionManager.leaveRoom(roomId: channel.roomID, userId: userID) {
                    // todo: send a notification to inform socket io
                    self.connectionManager.joinChannel(userName: userName, userID: userID, channel: channelInfo) { channel in
                        self.singleton.channel = channel
                        self.setViewControllers([self.getViewController()] as [UIViewController], direction: .forward, animated: true, completion: nil)
                        // todo: switch room
                    }
                }
            } else {
                // customer channel
                connectionManager.leaveRoom(roomId: channel.roomID, userId: userID) {
                    self.connectionManager.joinPrivateChannel(userName: userName, userID: userID, channel: channelInfo, password: password) { channel in
                        print("lalala")
                        self.singleton.channel = channel
                        self.setViewControllers([self.getViewController()] as [UIViewController], direction: .forward, animated: true, completion: nil)
                    }
                }
            }
            
        } else {
            connectionManager.joinChannel(userName: userName, userID: 0, channel: channelInfo) { channel in
                self.singleton.channel = channel
                self.setViewControllers([self.getViewController()] as [UIViewController], direction: .forward, animated: true, completion: nil)
            }
        }
    }
}

// Mark: Deprecated
extension ChannelPageVC {
    //    func updateLocation(notification: Notification) {
    //        if let latitude = notification.userInfo?["latitude"] as? Double, let longitude = notification.userInfo?["longitude"] as? Double {
    //            // if user haven't join any room, then join a room
    //            // else update location
    //            // Todo: here
    //        }
    //    }
}

protocol JoinChannelDelegate: class {
    func joinChannelAct(channelInfo: ChannelInfo, userName: String, password: String, custom: Bool)
}
