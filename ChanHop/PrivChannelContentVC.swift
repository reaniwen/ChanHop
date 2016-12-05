//
//  PrivChannelContentViewController.swift
//  ChanHop
//
//  Created by Rean Wen on 11/28/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit

class PrivChannelContentVC: UIViewController {

    @IBOutlet weak var channelNameLabel: UITextField!
    @IBOutlet weak var passwordFrame: UIView!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var confirmPassFrame: UIView!
    @IBOutlet weak var confirmPassLabel: UITextField!
    
    var channelName: String = ""
    var channelPass: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.clear
        
        self.channelNameLabel.delegate = self
        self.passwordLabel.delegate = self
        self.confirmPassLabel.delegate = self
        
        setPassFrame(frame: passwordFrame)
        setPassFrame(frame: confirmPassFrame)
        self.passwordLabel.attributedPlaceholder = NSAttributedString(string:"CREATE A PASSWORD",attributes:[NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.8)])
        self.confirmPassLabel.attributedPlaceholder = NSAttributedString(string: "RE-TYPE PASSWORD", attributes:[NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.8)])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func createPrivChannelAct(_ sender: Any) {
    }
    
    func setPassFrame(frame: UIView) {
        frame.backgroundColor = UIColor.clear
        frame.layer.masksToBounds = true
        frame.layer.borderWidth = 2
        frame.layer.borderColor = UIColor.white.cgColor
        frame.layer.cornerRadius = 12
    }
}

extension PrivChannelContentVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTage=textField.tag+1;
        // Try to find next responder
        let nextResponder=textField.superview?.viewWithTag(nextTage) as UIResponder!
        
        if (nextResponder != nil){
            // Found next responder, so set it.
            nextResponder?.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }
        return false // We do not want UITextField to insert line-breaks.
    }
}
