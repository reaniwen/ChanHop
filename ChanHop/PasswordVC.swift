//
//  PasswordViewController.swift
//  ChanHop
//
//  Created by Rean Wen on 1/11/17.
//  Copyright © 2017 Rean Wen. All rights reserved.
//

import UIKit

class PasswordVC: UIViewController {

    @IBOutlet weak var passwordFrame: UIView!
    @IBOutlet weak var passwordText: UITextField!
    
    weak var joinChannelDelegate: JoinChannelDelegate? = nil // channelviewcontroller
    var channelInfo: ChannelInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setPassFrame(frame: passwordFrame)
        self.passwordText.attributedPlaceholder = NSAttributedString(string:"ENTER PASSWORD",attributes:[NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.8)])
    }

    @IBAction func joinChannel(_ sender: Any) {
        joinChannelDelegate?.joinChannelAct(channelInfo: self.channelInfo, userName: UserManager.shared.userName, password: "", custom: true)
    }
    

    func setPassFrame(frame: UIView) {
        frame.backgroundColor = UIColor.clear
        frame.layer.masksToBounds = true
        frame.layer.borderWidth = 2
        frame.layer.borderColor = UIColor.white.cgColor
        frame.layer.cornerRadius = 12
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
