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
        
        // Do any additional setup after loading the view.
        dataSource = nil
        
        self.setViewControllers([getViewControllerAtIndex(0)] as [UIViewController], direction: .forward, animated: false, completion: nil)

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
        
        if UserDefaults.standard.bool(forKey: "com.chanhop.finishTutorial") == false{
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "TutorialViewController") as? TutorialViewController {
                self.present(vc, animated: false, completion: nil)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLocation), name: NSNotification.Name(UPDATE_LOC), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        connectionManager.checkServer {
            res, message in
            if res {
                // status == 200
                // get room
            } else {
                print(message)
            }
        }
//        userManager.checkAndJoinRoomInChannel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getViewControllerAtIndex(_ index: NSInteger) -> ChannelViewController
    {
        let channelContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChannelViewController") as! ChannelViewController
        channelContentViewController.channelID = index
        self.channelVC = channelContentViewController
        
        return channelContentViewController
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: - Handle swipe
extension ChannelPageVC {
    func handleSwipe(_ gestureRecognizer: UIGestureRecognizer) {
        if let swipeGesture = gestureRecognizer as? UISwipeGestureRecognizer {
            print("the fingers you use is \(gestureRecognizer.numberOfTouches)")
            moveToNextChannel(swipeGesture)
            
        }
        
    }
    
    func handleSingleSwipe(_ gestureRecognizer: UIGestureRecognizer) {
        if let swipeGesture = gestureRecognizer as? UISwipeGestureRecognizer {
            print("the fingers you use is \(gestureRecognizer.numberOfTouches)")
            if let vc = channelVC {
                vc.handleGesture(swipeGesture)
            }
            
        }
    }
    
    func moveToNextChannel(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.left:
            print("Swipe to previous channel")
            currentIndex += 1
            UIView.animate(withDuration: 2, animations: {
                self.setViewControllers([self.getViewControllerAtIndex(self.currentIndex)], direction: .forward, animated:true, completion: nil)
            })
        case UISwipeGestureRecognizerDirection.right:
            print("swipe to next channels")
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
        print(notification.userInfo)
        if let latitude = notification.userInfo?["latitude"] as? Double, let longitude = notification.userInfo?["longitude"] as? Double {
//            userManager.checkAndJoinRoomInChannel(latitude: latitude, longitude: longitude)
        }
    }
}
