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
    
    var indicator: UIPageControl!
    
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
        
        arrPageTitle = ["This is The App Guruz", "This is Table Tennis 3D", "This is Hide Secrets"];
        arrPagePhoto = ["1.jpg", "2.jpg", "3.jpg"];
        self.dataSource = self
        self.setViewControllers([getViewControllerAtIndex(index: 0)] as [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        print("style:", self.transitionStyle.rawValue)
        
        indicator = UIPageControl(frame: CGRect(x: 50, y: 50, width: 100, height: 50))
        indicator.pageIndicatorTintColor = UIColor.red
        indicator.currentPageIndicatorTintColor = UIColor.green
        indicator.backgroundColor = UIColor.white
        self.view.addSubview(indicator)
        self.view.bringSubview(toFront: indicator)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getViewControllerAtIndex(index: NSInteger) -> TutorialContentViewController
    {
        let tutorialContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "tutorialContent") as! TutorialContentViewController
        tutorialContentViewController.strTitle = "\(arrPageTitle[index])"
        tutorialContentViewController.strPhotoName = "\(arrPagePhoto[index])"
        tutorialContentViewController.pageIndex = index
        return tutorialContentViewController
    }

}

extension TutorialViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
//            return nil
//        }
//        
//        let previousIndex = viewControllerIndex - 1
//        
//        guard previousIndex >= 0 else {
//            return nil
//        }
//        
//        guard orderedViewControllers.count > previousIndex else {
//            return nil
//        }
//        
//        return orderedViewControllers[previousIndex]
        let pageContent: TutorialContentViewController = viewController as! TutorialContentViewController
        var index = pageContent.pageIndex
        
        if (index == NSNotFound)
        {
            return nil;
        }
        index += 1
//        indicator.currentPage = 1
        if (index == arrPageTitle.count)
        {
            return nil;
        }
        return getViewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
//            return nil
//        }
//        
//        let nextIndex = viewControllerIndex + 1
//        let orderedViewControllersCount = orderedViewControllers.count
//        
//        guard orderedViewControllersCount != nextIndex else {
//            return nil
//        }
//        
//        guard orderedViewControllersCount > nextIndex else {
//            return nil
//        }
//        
//        return orderedViewControllers[nextIndex]
        let pageContent: TutorialContentViewController = viewController as! TutorialContentViewController
        var index = pageContent.pageIndex
        
        if ((index == 0) || (index == NSNotFound))
        {
            return nil
        }
        index -= 1
//        indicator.currentPage = 1
        return getViewControllerAtIndex(index: index)
    }
    
}
