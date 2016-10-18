//
//  ViewController.swift
//  ChanHop
//
//  Created by Rean Wen on 10/18/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var topNavigationBar: TopNavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        topNavigationBar = TopNavigationBar()
        self.view.addSubview(topNavigationBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        self.topNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        let left = NSLayoutConstraint(item: self.topNavigationBar, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: self.topNavigationBar, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: self.topNavigationBar, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: self.topNavigationBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        self.view.addConstraint(left)
        self.view.addConstraint(right)
        self.view.addConstraint(top)
        self.view.addConstraint(height)
    }


}

