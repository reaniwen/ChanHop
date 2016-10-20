//
//  TutorialViewController.swift
//  ChanHop
//
//  Created by Rean Wen on 10/18/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit

class TutorialViewController: UIPageViewController {
    
    var arrPageTitle: NSArray = NSArray()
    var arrPagePhoto: NSArray = NSArray()
    var arrPageDes: [String] = [String]()
    
    var indicator: UIPageControl!
    let PAGE_COUNT = 4
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataSource = self
        delegate = self
        
        arrPageTitle = ["", "USERNAME", "HOPSWIPE", "CHANNEL HOPPING"];
        arrPageDes = [
            "Welcome to ChanHop, your \n gateway to get connected to \n everyone around you.",
            "Enter any username before \n entering a room to identify yourself \n amongst the crowed",
            "Single finger swipe switches rooms \n in the same channel. Double finger \n swipe switches channel",
            "Switch to different channels based \n on your location and events \n around you."
        ]
        arrPagePhoto = ["1.jpg", "2.jpg", "3.jpg", "3.jpg"];
        self.dataSource = self
        self.setViewControllers([getViewControllerAtIndex(index: 0)] as [UIViewController], direction: .forward, animated: false, completion: nil)
        
        indicator = UIPageControl(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        indicator.numberOfPages = PAGE_COUNT
        indicator.currentPage = 0
        indicator.pageIndicatorTintColor = UIColor.white
        indicator.currentPageIndicatorTintColor = UIColor.init(red: 2/255, green: 33/255, blue: 60/255, alpha: 1)
//        indicator.backgroundColor = UIColor.clear
        self.view.addSubview(indicator)
        self.view.bringSubview(toFront: indicator)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        self.indicator.translatesAutoresizingMaskIntoConstraints = false
        
        let midX = NSLayoutConstraint(item: self.view, attribute: .centerX, relatedBy: .equal, toItem: self.indicator, attribute: .centerX, multiplier: 1, constant: 0)
        let y = NSLayoutConstraint(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: self.indicator, attribute: .bottom, multiplier: 1, constant: 100)
        
        self.view.addConstraint(midX)
        self.view.addConstraint(y)
    }
    
    func getViewControllerAtIndex(index: NSInteger) -> TutorialContentViewController
    {
        let tutorialContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "tutorialContent") as! TutorialContentViewController
        tutorialContentViewController.strTitle = "TUTORIAL \(index)"//"\(arrPageTitle[index])"
        tutorialContentViewController.strPhotoName = "\(arrPagePhoto[index])"
        tutorialContentViewController.titleStr = "\(arrPageTitle[index])"
        tutorialContentViewController.desStr = arrPageDes[index]
        tutorialContentViewController.pageIndex = index
        
        return tutorialContentViewController
    }

}

extension TutorialViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let pageContent: TutorialContentViewController = viewController as! TutorialContentViewController
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
        return getViewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let pageContent: TutorialContentViewController = viewController as! TutorialContentViewController
        var index = pageContent.pageIndex
        
        if ((index == 0) || (index == NSNotFound))
        {
            return nil
        }
        index -= 1
        return getViewControllerAtIndex(index: index)
    }
}

extension TutorialViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (!completed)
        {
            return
        }
        // update the indicator index
        let pageContent: TutorialContentViewController = pageViewController.viewControllers!.first as! TutorialContentViewController
        let index = pageContent.pageIndex
        self.indicator.currentPage = index
        
        
    }
}
