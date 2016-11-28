//
//  ChannelPageVC.swift
//  ChanHop
//
//  Created by Rean Wen on 10/21/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//


import UIKit

class ChannelPageVC: UIPageViewController {
    
    var currentIndex = 0
    weak var channelVC: ChannelViewController?
    
    let userManager = UserManager.shared
    let connectionManager = ConnectionManager.shared
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLocation), name: NSNotification.Name(UPDATE_LOC), object: nil)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setViewControllers([getViewControllerAtIndex(0)] as [UIViewController], direction: .forward, animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getViewControllerAtIndex(_ index: NSInteger) -> ChannelViewController
    {
        let channelContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChannelViewController") as! ChannelViewController
        channelContentViewController.channelID = index
        
        self.channelVC?.removeFromParentViewController()
        self.channelVC = channelContentViewController
        self.addChildViewController(channelVC!)
        
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

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
            currentIndex += 1
            UIView.animate(withDuration: 2, animations: {
                self.setViewControllers([self.getViewControllerAtIndex(self.currentIndex)], direction: .forward, animated:true, completion: nil)
            })
        case UISwipeGestureRecognizerDirection.right:
            print("Swiping to next channel")
            currentIndex -= 1
            UIView.animate(withDuration: 2, animations: {
                self.setViewControllers([self.getViewControllerAtIndex(self.currentIndex)], direction: .reverse, animated:true, completion: nil)
            })
            
        default:
            break
        }
    }
}

extension ChannelPageVC {
    func updateLocation(notification: Notification) {
        if let latitude = notification.userInfo?["latitude"] as? Double, let longitude = notification.userInfo?["longitude"] as? Double {
            // if user haven't join any room, then join a room
            // else update location
            if userManager.userID == 0 && false{
                // join local hop and get a user id
                userManager.checkAndJoinRoomInChannel(latitude: latitude, longitude: longitude, channelName: "LocalHop") { roomName in
                    print(roomName)
                }
            } else {
                userManager.updateLocation(latitude: latitude, longitude: longitude)
            }
            
        }
    }
}

//extension ChannelPageVC: CallMenusDelegate{
//    func callChannelMenu(channelName: String, roomName: String) {
//        print("call channel menu"+channelName, roomName)
//    }
//    
//    
//    
//    func callMemberMenu() {
//        print("call member menu")
//    }
//}
//
//@objc protocol CallMenusDelegate {
//    @objc optional func callChannelMenu(channelName: String, roomName: String)
//    
//    @objc optional func removeChannelMenu()
//    
//    @objc optional func callMemberMenu()
//    
//}
