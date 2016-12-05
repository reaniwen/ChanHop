//
//  PublicChannelContentVC.swift
//  ChanHop
//
//  Created by Rean Wen on 11/28/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit

class PblcChannelContentVC: UIViewController {

    @IBOutlet weak var channelNameLabel: UITextField!
    
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
    }
    
}

extension PblcChannelContentVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Not found, so remove keyboard
        textField.resignFirstResponder()
        return false // We do not want UITextField to insert line-breaks.
    }
}
