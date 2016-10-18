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
        
//        if let firstViewController = orderedViewControllers.first {
//            setViewControllers([firstViewController],
//                               direction: .forward,
//                               animated: true,
//                               completion: nil)
//        }
        print("style:", self.transitionStyle.rawValue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    private(set) lazy var orderedViewControllers: [UIViewController] = {
//        return [self.newColoredViewController(color: "Green"),
//                self.newColoredViewController(color: "Red"),
//                self.newColoredViewController(color: "Blue")]
//    }()
//
//    private func newColoredViewController(color: String) -> UIViewController {
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(color)ViewController")
//        return vc
//    }
    
    func getViewControllerAtIndex(index: NSInteger) -> TutorialContentViewController
    {
        // Create a new view controller and pass suitable data.
//        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as! TutorialContentViewController
        let tutorialContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "tutorialContent") as! TutorialContentViewController
        tutorialContentViewController.strTitle = "\(arrPageTitle[index])"
        tutorialContentViewController.strPhotoName = "\(arrPagePhoto[index])"
        tutorialContentViewController.pageIndex = index
        return tutorialContentViewController
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
        return getViewControllerAtIndex(index: index)
    }
    
}
