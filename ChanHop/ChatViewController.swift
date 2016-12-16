//
//  ChatViewController.swift
//  ChanHop
//
//  Created by Rean Wen on 11/3/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import SocketIO
import UIColor_Hex_Swift

class ChatViewController: JSQMessagesViewController {

    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.lightGray)
    var messages = [JSQMessage]()
    
//    var socket: SocketIOClient?
    
    var backgroundImage = UIImageView()
    var backgroundMask = UIView()
    
    
    let singleton: Singleton = Singleton.shared
    let userManager: UserManager = UserManager.shared
    let messageManager = MessageManager.shared
    let connectionManager = ConnectionManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.backgroundColor = UIColor.clear
        
        self.setup()
        self.inputToolbar.contentView.leftBarButtonItem = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        

        
        connectionManager.getRoomInfo(roomId: singleton.roomName, userId: userManager.userID) {
            print("info achieved")
//        self.addDemoMessages()
            self.loadMessage()
        }

        
        
        loadTheme(url: "")

    }
    
    func loadTheme(url:String) {
        backgroundImage.image = UIImage(named: "1")
        backgroundMask.backgroundColor = UIColor(red: 34/255, green: 38/255, blue: 42/255, alpha: 0.76)
        self.view.insertSubview(backgroundMask, at: 0)
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let viewWidth = self.view.frame.width
        let viewHeight = self.view.frame.height
        
        backgroundImage.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        backgroundMask.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        
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
//    func addDemoMessages() {
//        for i in 1...10 {
//            let sender = (i%2 == 0) ? "Server" : self.senderId
////            let messageContent = "Message nr. \(i)"
//            let messageContent = "This is a demo message"
//            
//            let message = JSQMessage(senderId: sender, senderDisplayName: sender, date: Date(), text: messageContent)
//            
//            self.messages.append(message!)
//            
//        }
//        self.reloadMessagesView()
//    }
    
    func loadMessage() {
        self.messages = []
        for i in 0..<messageManager.messages.count {
            let rawMessage = messageManager.messages[i]
            let sender = rawMessage.senderName
            let messageContent = rawMessage.content
            let sendTime = Date(timeIntervalSince1970: TimeInterval(rawMessage.date))
            if let message = JSQMessage(senderId: sender, senderDisplayName: sender, date: sendTime, text: messageContent) {
                self.messages.append(message)
            }
            
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
        return self.messageManager.messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        let data:JSQMessageData = self.messages[indexPath.row]
        return data
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didDeleteMessageAt indexPath: IndexPath!) {
        self.messages.remove(at: indexPath.row)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {

        // todo: set the incoming and outgoing
        let data = messageManager.messages[indexPath.row]
        switch data.senderId {
        case userManager.userID:
            return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor(data.color))
        default:
            return JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor(data.color))
        }
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let data = messageManager.messages[indexPath.row]
        let initStr = String(data.senderName[data.senderName.startIndex]).uppercased()
        let AvatarJobs = JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: initStr, backgroundColor: UIColor(data.color), textColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 19), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
        
//        let avatar = UIImage(named: "1.png")
//        let AvatarJobs = JSQMessagesAvatarImageFactory.avatarImage(withPlaceholder: avatar, diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
//        open class func avatarImage(withUserInitials userInitials: String!, backgroundColor: UIColor!, textColor: UIColor!, font: UIFont!, diameter: UInt) -> JSQMessagesAvatarImage!
        
        return AvatarJobs
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
