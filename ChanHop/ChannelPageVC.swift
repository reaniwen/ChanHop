//
//  ChannelPageVC.swift
//  ChanHop
//
//  Created by Rean Wen on 10/21/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit

class ChannelPageVC: UIPageViewController {
    
    var currentIndex = 2
    weak var channelVC: ChannelViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        dataSource = nil
        
        self.setViewControllers([getViewControllerAtIndex(index: 0)] as [UIViewController], direction: .forward, animated: false, completion: nil)
        
        let doubleSwipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        doubleSwipeLeft.direction = .left
        doubleSwipeLeft.numberOfTouchesRequired = 2
        
        let doubleSwipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        doubleSwipeRight.direction = .right
        doubleSwipeRight.numberOfTouchesRequired = 2
        
        self.view.addGestureRecognizer(doubleSwipeLeft)
        self.view.addGestureRecognizer(doubleSwipeRight)
        
        let singleSwipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSingleSwipe))
        singleSwipeLeft.direction = .left
        singleSwipeLeft.numberOfTouchesRequired = 1
        
        let singleSwipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSingleSwipe))
        singleSwipeRight.direction = .right
        singleSwipeRight.numberOfTouchesRequired = 1
        
        self.view.addGestureRecognizer(singleSwipeLeft)
        self.view.addGestureRecognizer(singleSwipeRight)
        
        if UserDefaults.standard.bool(forKey: "com.chanhop.finishTutorial") == false{
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "TutorialViewController") as? TutorialViewController {
                self.present(vc, animated: false, completion: nil)
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveToNextChannel(gesture: UISwipeGestureRecognizer) {
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
            moveToNextChannel(gesture: swipeGesture)
            
        }
        
    }
    
    func handleSingleSwipe(gestureRecognizer: UIGestureRecognizer) {
        if let swipeGesture = gestureRecognizer as? UISwipeGestureRecognizer {
            print("the fingers you use is \(gestureRecognizer.numberOfTouches)")
            //            print("the direction you swiped is \(swipeGesture.direction)")
//            moveToNextChannel(gesture: swipeGesture)
            if let vc = channelVC {
                vc.handleGesture(gesture: swipeGesture)
            }
            
        }
    }
    
    func getViewControllerAtIndex(index: NSInteger) -> ChannelViewController
    {
        let channelContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChannelViewController") as! ChannelViewController
        channelContentViewController.channelID = index
        self.channelVC = channelContentViewController
        
        return channelContentViewController
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
