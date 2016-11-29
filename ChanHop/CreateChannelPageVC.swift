//
//  CreateChannelPageVC.swift
//  ChanHop
//
//  Created by Rean Wen on 11/28/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit

class CreateChannelPageVC: UIPageViewController {
    
    var indicator: UIPageControl!
    let PAGE_COUNT = 2
    
    var vcs: [UIViewController?] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        vcs.append(self.storyboard?.instantiateViewController(withIdentifier: "PblcChannelContentVC"))
        vcs.append(self.storyboard?.instantiateViewController(withIdentifier: "PrivChannelContentVC"))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getViewControllerAtIndex(_ index: NSInteger) -> UIViewController
    {
        if let vc = vcs[index] {
            return vc
        } else {
            return UIViewController()
        }
    }

}

extension CreateChannelPageVC: UIPageViewControllerDataSource {
    
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
        return getViewControllerAtIndex(index)
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
        return getViewControllerAtIndex(index)
    }
}

extension CreateChannelPageVC: UIPageViewControllerDelegate {
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
