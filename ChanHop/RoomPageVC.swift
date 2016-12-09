//
//  RoomPageVC.swift
//  ChanHop
//
//  Created by Rean Wen on 10/21/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit

class RoomPageVC: UIPageViewController {
    
    
    var currentIndex = 0
    weak var roomVC: RoomViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataSource = nil
        self.setViewControllers([getViewControllerAtIndex(0)] as [UIViewController], direction: .forward, animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
//        let singleSwipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
//        singleSwipeLeft.direction = .left
//        singleSwipeLeft.numberOfTouchesRequired = 1
//        
//        let singleSwipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
//        singleSwipeRight.direction = .right
//        singleSwipeRight.numberOfTouchesRequired = 1
//        
//        self.view.addGestureRecognizer(singleSwipeLeft)
//        self.view.addGestureRecognizer(singleSwipeRight)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleSwipe(_ gestureRecognizer: UIGestureRecognizer) {
        if let swipeGesture = gestureRecognizer as? UISwipeGestureRecognizer {
            print("the fingers you use is \(gestureRecognizer.numberOfTouches)")
            //            print("the direction you swiped is \(swipeGesture.direction)")
            moveToNextRoom(swipeGesture)
            
        }
        
    }
    
    func moveToNextRoom(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.left:
            print("swipe to previous room")
            currentIndex += 1
            self.setViewControllers([getViewControllerAtIndex(currentIndex)], direction: .forward, animated:true, completion: nil)
        case UISwipeGestureRecognizerDirection.right:
            print("swipe to next room")
            currentIndex -= 1
            self.setViewControllers([getViewControllerAtIndex(currentIndex)], direction: .reverse, animated:true, completion: nil)
        default:
            break
        }
    }
    
    func getViewControllerAtIndex(_ index: NSInteger) -> RoomViewController
    {
        let roomContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "RoomViewController") as! RoomViewController
        roomContentViewController.roomID = index
        
        self.roomVC?.removeFromParentViewController()
        self.roomVC = roomContentViewController
        self.addChildViewController(roomVC!)
        
        return roomContentViewController
    }
}
