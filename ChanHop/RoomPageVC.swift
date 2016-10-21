//
//  RoomPageVC.swift
//  ChanHop
//
//  Created by Rean Wen on 10/21/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit

class RoomPageVC: UIPageViewController {
    
    
    var currentIndex = 2

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataSource = nil
        self.setViewControllers([getViewControllerAtIndex(index: 0)] as [UIViewController], direction: .forward, animated: false, completion: nil)
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
    
    func moveToNextRoom(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.left:
            print("left")
            self.setViewControllers([getViewControllerAtIndex(index: currentIndex)], direction: .forward, animated:true, completion: nil)
        case UISwipeGestureRecognizerDirection.right:
            print("right")
            self.setViewControllers([getViewControllerAtIndex(index: currentIndex)], direction: .reverse, animated:true, completion: nil)
        default:
            break
        }
    }
    
    func handleSwipe(gestureRecognizer: UIGestureRecognizer) {
        if let swipeGesture = gestureRecognizer as? UISwipeGestureRecognizer {
            print("the fingers you use is \(gestureRecognizer.numberOfTouches)")
            //            print("the direction you swiped is \(swipeGesture.direction)")
            moveToNextRoom(gesture: swipeGesture)
            
        }
        
    }
    
    func getViewControllerAtIndex(index: NSInteger) -> RoomViewController
    {
        let roomContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "RoomViewController") as! RoomViewController
        roomContentViewController.roomID = index
        
        return roomContentViewController
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
