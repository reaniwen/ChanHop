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
import SDWebImage

class ChatViewController: JSQMessagesViewController {

//    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
//    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.lightGray)
    var messages = [JSQMessage]()
    
//    var socket: SocketIOClient?
    
    var backgroundImage = UIImageView()
    var backgroundMask = UIView()
    
    
    let singleton: Singleton = Singleton.shared
    let userManager: UserManager = UserManager.shared
    let messageManager = MessageManager.shared
    let connectionManager = ConnectionManager.shared
    let socketIOManager = SocketIOManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.backgroundColor = UIColor.clear
        
        self.setup()
        self.inputToolbar.contentView.leftBarButtonItem = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var id = 0
        if singleton.channel != nil {
            id = (singleton.channel?.roomID)!
            loadTheme(url: (singleton.channel?.backGroundImgURL)!)
        }
        
        connectionManager.getRoomInfo(roomId: id, userId: userManager.userID, userName: userManager.userName) {
            print("info achieved")
//        self.addDemoMessages()
            self.loadMessage()
        }
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
    
    func loadMessage() {
        self.messages = []
        for i in 0..<messageManager.messages.count {
            let rawMessage = messageManager.messages[i]
            let senderid = rawMessage.senderId
            let sender = rawMessage.senderName
            let messageContent = rawMessage.content
            let sendTime = Date(timeIntervalSince1970: TimeInterval(rawMessage.date))
            if let message = JSQMessage(senderId: String(senderid), senderDisplayName: sender, date: sendTime, text: messageContent) {
                self.messages.append(message)
            }
            
        }
        self.reloadMessagesView()
    }
    
    func setup() {
        self.senderId = String(userManager.userID)
        self.senderDisplayName = userManager.userName
    }
    
    func loadTheme(url:String) {
        //        backgroundImage.image = UIImage(named: "1")
        if url != "" {
            backgroundImage.sd_setImage(with: URL(string: url)!, placeholderImage: UIImage(named: "1")!)
            backgroundMask.backgroundColor = UIColor(red: 34/255, green: 38/255, blue: 42/255, alpha: 0.76)
            self.view.insertSubview(backgroundMask, at: 0)
            self.view.insertSubview(backgroundImage, at: 0)
        }
        
        
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
        print("Send button pressed")
        
        if let channel = singleton.channel {
            socketIOManager.addMessage(roomId: channel.roomID, userid: userManager.userID, userName: userManager.userName, message: text) {
                
////            }
////            connectionManager.sendMessage(roomId: channel.roomID, userId: userManager.userID, userName: userManager.userName, message: text) {
//                let interval = Date().timeIntervalSince1970
//                let rawMessage: Message = Message(id: "0", content: text, senderName: self.userManager.userName, senderId: self.userManager.userID, color: self.userManager.colorHex, date: interval)
//                let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date as Date!, text: text)
//                self.messages.append(message!)
//                self.messageManager.messages.append(rawMessage)
//                self.finishSendingMessage()
            }
        }
        
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
    }
}
