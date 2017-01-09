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
    let socketIOManager = SocketIOManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.backgroundColor = UIColor.clear
        
        self.setup()
        self.inputToolbar.contentView.leftBarButtonItem = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var id = 0
        var roomName = ""
        if singleton.channel != nil {
            id = (singleton.channel?.roomID)!
            loadTheme(url: (singleton.channel?.backGroundImgURL)!)
            roomName = (singleton.channel?.roomName)!
        }
        
        connectionManager.getRoomInfo(roomId: id, userId: userManager.userID, userName: userManager.userName) {
            print("info achieved")
//        self.addDemoMessages()
            self.loadMessage()
            let timeInterval = NSDate().timeIntervalSince1970
            self.socketIOManager.joinRoom(roomName: roomName, userName: self.userManager.userName, created_at: timeInterval)
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
        
        // scroll to bottom
        self.scrollToBottom(animated: true)
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
    
//    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didDeleteMessageAt indexPath: IndexPath!) {
//        self.messages.remove(at: indexPath.row)
//    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let msg : JSQMessage = (messages[indexPath.row])
        let whiteColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)
        if msg.senderId == self.senderId{
            cell.messageBubbleTopLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 30)
        }else{
            cell.messageBubbleTopLabel.textInsets = UIEdgeInsetsMake(0, 35, 0, 0)
        }
        
        if (!msg.isMediaMessage) {
            if msg.senderId == self.senderId{
                cell.textView.textColor = whiteColor
                
            }else {
                cell.textView.textColor = .white
            }
        }
        if msg.senderId == self.senderId{
            cell.cellBottomLabel.textAlignment = .right
        }else {
            cell.cellBottomLabel.textAlignment = .left
        }
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {

        let TailessbubbleFactory = JSQMessagesBubbleImageFactory(bubble: UIImage.jsq_bubbleCompactTailless(), capInsets: UIEdgeInsets.zero)
        let data = messageManager.messages[indexPath.row]
        switch data.senderId {
        case userManager.userID:
            return TailessbubbleFactory?.outgoingMessagesBubbleImage(with: UIColor(data.color))
//                JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor(data.color))
        default:
            return TailessbubbleFactory?.incomingMessagesBubbleImage(with: UIColor(data.color))
                //JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor(data.color))
        }
        
    }
    
//    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
//        let data = messageManager.messages[indexPath.item]
//        let initStr = String(data.senderName[data.senderName.startIndex]).uppercased()
//        let AvatarJobs = JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: initStr, backgroundColor: UIColor(data.color), textColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 19), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
//        
//        return AvatarJobs
//    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let data = messageManager.messages[indexPath.item]
        let initStr = String(data.senderName[data.senderName.startIndex]).uppercased()
        let avatarJobs = JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: initStr, backgroundColor: UIColor(data.color), textColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 19), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
        
        let message = messages[indexPath.item]
        if indexPath.item < messages.count - 1 {
            let nextMessage = self.messages[indexPath.item + 1]
            if nextMessage.senderId == message.senderId{
                return nil
            }
            return avatarJobs//avatarDict[message.senderId]
        }
        return avatarJobs//avatarDict[message.senderId]
    }
    
//    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
//        let message: JSQMessage = self.messages[indexPath.item]
//        
//        let dateformat = DateFormatter()
//        dateformat.dateStyle = .short
//        dateformat.timeStyle = .short
//        
//        let myAttributes = [ NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)]
//        
//        // todo: customize color of date and time
//        //        print(JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date))
//        return NSAttributedString(string: dateformat.string(from: message.date), attributes: myAttributes)
//    }
//    
//    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
//        return 20
//    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        let message = messages[indexPath.item]
        if indexPath.item == 0{
            return 15
        }
        if indexPath.item - 1 > 0 {
            
            let previousMessage = self.messages[indexPath.item - 1]
            if message.senderId == previousMessage.senderId {
                if message.date!.timeIntervalSince(previousMessage.date!) / 600 > 1 {
                    return 15
                }
                return 0
            }else {
                if message.date!.timeIntervalSince(previousMessage.date!) / 600 > 1 {
                    return 15
                }
                return 0
            }
        }
        return 0
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "EEEEEE MMM d, h:mma"
        let dateString = dayTimePeriodFormatter.string(from: message.date)
        if indexPath.item == 0 {
            return NSAttributedString(string: dateString)
        }
        if indexPath.item - 1 > 0 {
            let previousMessage = self.messages[indexPath.item - 1]
            if message.date!.timeIntervalSince(previousMessage.date!) / 600 > 1 {
                return NSAttributedString(string: dateString)
            }
        }
        return nil
    }
  
}

//MARK - Toolbar
extension ChatViewController {
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        print("Send button pressed")
        
        if let channel = singleton.channel {
            socketIOManager.sendMessage(userID: userManager.userID, roomID: channel.roomID, userName: userManager.userName, message: text, is_tagged: 0, channelName: "", longitude: 0, latitude: 0) {_ in 
                self.loadMessage()
                self.finishSendingMessage()
            }
        }
    }
    
//    override func didPressAccessoryButton(_ sender: UIButton!) {
//        
//    }
}

// MARK - Listen for message
extension ChatViewController {
    func receiveNewMessage() {
        
    }
}
