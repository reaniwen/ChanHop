//
//  ViewController.swift
//  ChanHop
//
//  Created by Rean Wen on 10/18/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit
import JSQMessagesViewController


class ViewController: JSQMessagesViewController {

    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var channelBtn: UIButton!
    @IBOutlet weak var configBtn: UIButton!
    @IBOutlet weak var memberBtn: UIButton!
    @IBOutlet weak var roomLabel: UILabel!
    
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.lightGray)
    var messages = [JSQMessage]()
    
    var pageIndex: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        self.addDemoMessages()
        
        self.view.addSubview(topBar)
    }

    override func viewDidAppear(_ animated: Bool) {
        // if first time launch, jump to tutorial
        if UserDefaults.standard.bool(forKey: "com.chanhop.finishTutorial") == false{
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "TutorialViewController") as? TutorialViewController {
                self.present(vc, animated: false, completion: nil)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        self.collectionView?.frame = CGRect(x: 0, y: 120, width: self.view.frame.width, height: self.view.frame.height - 120)
        self.topBar.translatesAutoresizingMaskIntoConstraints = false
        
        var parent: AnyObject!
        var child: AnyObject!
        parent = self.view
        child = topBar
        
        let left = NSLayoutConstraint(item: parent, attribute: .leading, relatedBy: .equal, toItem: child, attribute: .leading, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: parent, attribute: .trailing, relatedBy: .equal, toItem: child, attribute: .trailing, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: parent, attribute: .top, relatedBy: .equal, toItem: child, attribute: .top, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: child, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 120)
        parent.addConstraint(left)
        parent.addConstraint(right)
        parent.addConstraint(top)
        parent.addConstraint(height)
        
        
    }
}


extension ViewController {
    func addDemoMessages() {
        for i in 1...10 {
            let sender = (i%2 == 0) ? "Server" : self.senderId
            let messageContent = "Message nr. \(i) \(pageIndex)"
            let message = JSQMessage(senderId: sender, displayName: sender, text: messageContent)
            self.messages.append(message!)
            //            self.messages += [message]
        }
        self.reloadMessagesView()
    }
    
    func setup() {
        self.senderId = UIDevice.current.identifierForVendor?.uuidString
        self.senderDisplayName = "abc"//+UIDevice.current.identifierForVendor?.uuidString
        
        // set room and channel
        self.channelBtn.setTitle("Yankee", for: .normal)
    }
    
    func reloadMessagesView() {
        self.collectionView?.reloadData()
    }
}

extension ViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        let data:JSQMessageData = self.messages[indexPath.row]
        return data
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didDeleteMessageAt indexPath: IndexPath!) {
        self.messages.remove(at: indexPath.row)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let data = messages[indexPath.row]
        switch data.senderId {
        case self.senderId:
            return self.outgoingBubble
        default:
            return self.incomingBubble
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
}

//MARK - Toolbar
extension ViewController {
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date as Date!, text: text)
        self.messages.append(message!)
        self.finishSendingMessage()
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
    }
}
