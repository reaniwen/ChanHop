//
//  TopNavigationBar.swift
//  ChanHop
//
//  Created by Rean Wen on 10/18/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit

class TopNavigationBar: UIView {
    
    var leftButton: UIButton!
    var rightButton: UIButton!
    var channelButton: UIButton!
    var roomView: UIView!
    var roomLabel: UILabel!

    override init (frame : CGRect) {
        super.init(frame : frame)
        self.backgroundColor = UIColor.darkGray
        
        leftButton = UIButton()
        leftButton.setTitle("left", for: .normal)
        // todo: set the title to the right image
        leftButton.addTarget(self, action: #selector(leftBtnAct), for: .touchUpInside)
        
        rightButton = UIButton()
        rightButton.setTitle("right", for: .normal)
        // todo: set the title to the right image
        rightButton.addTarget(self, action: #selector(rightBtnAct), for: .touchUpInside)
        
        channelButton = UIButton()
        channelButton.setTitle("THE LOCAL HOP", for: .normal)
        
        roomView = UIView()
        roomView.backgroundColor = UIColor.lightGray
        
        roomLabel = UILabel()
        roomLabel.text = "ROOM 123"
        
        
        self.addSubview(leftButton)
        self.addSubview(rightButton)
        self.addSubview(channelButton)
        self.addSubview(roomView)
        roomView.addSubview(roomLabel)
        
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        channelButton.translatesAutoresizingMaskIntoConstraints = false
        roomView.translatesAutoresizingMaskIntoConstraints = false
        roomLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // right button constraints
        let right = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: rightButton, attribute: .trailing, multiplier: 1, constant: 20)
        var midY = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: rightButton, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(right)
        self.addConstraint(midY)
        
        // left button constraints
        let left = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: leftButton, attribute: .leading, multiplier: 1, constant: -20)
        midY = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: leftButton, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(left)
        self.addConstraint(midY)
        
        var midX = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: channelButton, attribute: .centerX, multiplier: 1, constant: 0)
        midY = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: channelButton, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(midX)
        self.addConstraint(midY)
        
        // room view constraints
        let bottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: roomView, attribute: .bottom, multiplier: 1, constant: 0)
        midX = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: roomView, attribute: .centerX, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: roomView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35)
        let width = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: roomView, attribute: .width, multiplier: 1, constant: 0)
        self.addConstraint(bottom)
        self.addConstraint(midX)
        self.addConstraint(height)
        self.addConstraint(width)
        
        
        // room label constraints
        midX = NSLayoutConstraint(item: roomView, attribute: .centerX, relatedBy: .equal, toItem: roomLabel, attribute: .centerX, multiplier: 1, constant: 0)
        midY = NSLayoutConstraint(item: roomView, attribute: .centerY, relatedBy: .equal, toItem: roomLabel, attribute: .centerY, multiplier: 1, constant: 0)
        
        roomView.addConstraint(midX)
        roomView.addConstraint(midY)
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

    
    func leftBtnAct() {
        print("left button pressed")
    }
    
    func rightBtnAct() {
        print("right button pressed")
    }
}
