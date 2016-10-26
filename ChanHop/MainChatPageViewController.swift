//
//  MainChatPageViewController.swift
//  ChanHop
//
//  Created by Rean Wen on 10/20/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit

class MainChatPageViewController: UIPageViewController {
    
    let PAGE_COUNT = 4
    var currentIndex = 2

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = nil
        
        
        self.setViewControllers([getViewControllerAtIndex(0)] as [UIViewController], direction: .forward, animated: false, completion: nil)
        
        let doubleSwipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        doubleSwipeLeft.direction = .left
        doubleSwipeLeft.numberOfTouchesRequired = 2
        
        let doubleSwipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        doubleSwipeRight.direction = .right
        doubleSwipeRight.numberOfTouchesRequired = 2
        
        self.view.addGestureRecognizer(doubleSwipeLeft)
        self.view.addGestureRecognizer(doubleSwipeRight)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getViewControllerAtIndex(_ index: NSInteger) -> ViewController
    {
        let chatContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "main") as! ViewController
        chatContentViewController.pageIndex = index
        
        return chatContentViewController
    }
    // Todo achieve the logic of switch Channel and room
    func moveToNextRoom(){}
    
    func moveToNextChannel(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.left:
            print("left")
            self.setViewControllers([getViewControllerAtIndex(currentIndex)] as [UIViewController], direction: .forward, animated:true, completion: nil)
        case UISwipeGestureRecognizerDirection.right:
            print("right")
            self.setViewControllers([getViewControllerAtIndex(currentIndex)] as [UIViewController], direction: .reverse, animated:true, completion: nil)
        default:
            break
        }
    }
    
    func handleSwipe(_ gestureRecognizer: UIGestureRecognizer) {
        if let swipeGesture = gestureRecognizer as? UISwipeGestureRecognizer {
            print("the fingers you use is \(gestureRecognizer.numberOfTouches)")
//            print("the direction you swiped is \(swipeGesture.direction)")
            moveToNextChannel(swipeGesture)
            
        }
        
    }

}

extension MainChatPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let pageContent: ViewController = viewController as! ViewController
        var index = pageContent.pageIndex
        
        if (index == NSNotFound)
        {
            return nil;
        }
        index += 1
        if (index == PAGE_COUNT)
        {
            return nil;
        }
        return getViewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let pageContent: ViewController = viewController as! ViewController
        var index = pageContent.pageIndex
        
        if ((index == 0) || (index == NSNotFound))
        {
            return nil
        }
        index -= 1
        return getViewControllerAtIndex(index)
    }
}
