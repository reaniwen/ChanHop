//
//  PublicChannelContentVC.swift
//  ChanHop
//
//  Created by Rean Wen on 11/28/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit
import SVProgressHUD

class PblcChannelContentVC: UIViewController {

    @IBOutlet weak var channelNameLabel: UITextField!
    
    var joinChannelDelegate: JoinChannelDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        
        channelNameLabel.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createPubChannelAct(_ sender: Any) {
        if let channelName = channelNameLabel.text{
            let shortName = channelName.replacingOccurrences(of: " ", with: "")
            if shortName.characters.count != 0 {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: JOIN_CHANNEL), object: nil, userInfo: ["name":channelName, "password": ""])
                self.dismiss(animated: true, completion: nil)
            } else {
                SVProgressHUD.showError(withStatus: "Please type a channel name")
            }
        } else {
            SVProgressHUD.showError(withStatus: "Please type a channel name")
        }
    }
    
}

extension PblcChannelContentVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Not found, so remove keyboard
        textField.resignFirstResponder()
        return false // We do not want UITextField to insert line-breaks.
    }
}
