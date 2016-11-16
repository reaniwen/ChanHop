//
//  ChatViewController.swift
//  ChanHop
//
//  Created by Rean Wen on 11/3/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {

    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.lightGray)
    var messages = [JSQMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setup()
        self.addDemoMessages()
        
        self.inputToolbar.contentView.leftBarButtonItem = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadMessagesView() {
        self.collectionView?.reloadData()
    }

}

extension ChatViewController {
    // todo: get message
    func addDemoMessages() {
        for i in 1...10 {
            let sender = (i%2 == 0) ? "Server" : self.senderId
            let messageContent = "Message nr. \(i)"
            
            let message = JSQMessage(senderId: sender, senderDisplayName: sender, date: Date(), text: messageContent)
            
            self.messages.append(message!)
            
        }
        self.reloadMessagesView()
    }
    
    func setup() {
        self.senderId = UIDevice.current.identifierForVendor?.uuidString
        self.senderDisplayName = "abc"//+UIDevice.current.identifierForVendor?.uuidString
    }
}

// MARK - DataSource and Delegation
extension ChatViewController {
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
        
        let avatar = UIImage(named: "1.png")
        // todo: add image
        let AvatarJobs = JSQMessagesAvatarImageFactory.avatarImage(withPlaceholder: avatar, diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
        
        return AvatarJobs
        
        //        return nil
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message: JSQMessage = self.messages[indexPath.item]
        
        let dateformat = DateFormatter()
        dateformat.dateStyle = .short
        dateformat.timeStyle = .short
        
        let myAttributes = [ NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)]
        
        // todo: customize color of date and time
        //        print(JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date))
        return NSAttributedString(string: dateformat.string(from: message.date), attributes: myAttributes)
        
        //        return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 20
    }
}

//MARK - Toolbar
extension ChatViewController {
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date as Date!, text: text)
        self.messages.append(message!)
        self.finishSendingMessage()
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
    }
}
