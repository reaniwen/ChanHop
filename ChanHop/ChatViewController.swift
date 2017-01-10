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
    
//    var messages = [JSQMessage]()
    
//    var socket: SocketIOClient?
    
    var backgroundImage = UIImageView()
    var backgroundMask = UIView()
    
    let singleton: Singleton = Singleton.shared
    let userManager: UserManager = UserManager.shared
    let messageManager = MessageManager.shared
    let connectionManager = ConnectionManager.shared
    let socketIOManager = SocketIOManager.shared
    
    var content: String = ""
    var is_tagged: Bool = false
    var channelName: String = ""
    var longitude: Double = 0
    var latitude: Double = 0
    
    var listVC: TagListVC?
    var listView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.backgroundColor = UIColor.clear
        
        self.setup()
        self.inputToolbar.contentView.leftBarButtonItem = nil
        
        NotificationCenter.default.addObserver(self, selector: #selector(cancelTag), name: NSNotification.Name(rawValue: CANCEL_TAG), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chooseTag), name: NSNotification.Name(rawValue: SELECT_TAG), object: nil)
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
            self.reloadMessagesView()
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func reloadMessagesView() {
        self.collectionView?.reloadData()
        
        // scroll to bottom
        self.scrollToBottom(animated: true)
    }

}

extension ChatViewController {
    
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
        return messageManager.messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
//        let data:JSQMessageData = self.messages[indexPath.row]
        var data: JSQMessageData = JSQMessage(senderId: "", displayName: "", text: "")
        if indexPath.item < messageManager.messages.count {
            data = messageManager.messages[indexPath.item]
        }
//        let data: JSQMessageData = messageManager.messages[indexPath.item]
        return data
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
//        let msg : JSQMessage = (messages[indexPath.row])
        let msg: ChanhopMessage = messageManager.messages[indexPath.item]
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
        case String(userManager.userID):
            return TailessbubbleFactory?.outgoingMessagesBubbleImage(with: UIColor(data.color))
//                JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor(data.color))
        default:
            return TailessbubbleFactory?.incomingMessagesBubbleImage(with: UIColor(data.color))
                //JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor(data.color))
        }
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let data = messageManager.messages[indexPath.item]
        let initStr = String(data.senderDisplayName[data.senderDisplayName.startIndex]).uppercased()
//        let initStr = String(data.senderName[data.senderName.startIndex]).uppercased()
        let avatarJobs = JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: initStr, backgroundColor: UIColor(data.color), textColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 19), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
        
        let message = data//messages[indexPath.item]
        if indexPath.item < messageManager.messages.count - 1 {//messages.count - 1 {
            let nextMessage = messageManager.messages[indexPath.item + 1]//self.messages[indexPath.item + 1]
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
        let message = messageManager.messages[indexPath.item]//messages[indexPath.item]
        if indexPath.item == 0{
            return 15
        }
        if indexPath.item - 1 > 0 {
            
            let previousMessage = messageManager.messages[indexPath.item]//self.messages[indexPath.item - 1]
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
        let message = messageManager.messages[indexPath.item]
//        let message = messages[indexPath.item]
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "EEEEEE MMM d, h:mma"
        let dateString = dayTimePeriodFormatter.string(from: message.date)
        if indexPath.item == 0 {
            return NSAttributedString(string: dateString)
        }
        if indexPath.item - 1 > 0 {
            let previousMessage = messageManager.messages[indexPath.item - 1]
//            let previousMessage = self.messages[indexPath.item - 1]
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
//            socketIOManager.sendMessage(userID: userManager.userID, roomID: channel.roomID, userName: userManager.userName, message: text, is_tagged: 0, channelName: "", longitude: 0, latitude: 0) {_ in
            socketIOManager.sendMessage(userID: userManager.userID, roomID: channel.roomID, userName: userManager.userName, message: content, is_tagged: 0, channelName: channelName, longitude: longitude, latitude: latitude) {_ in
                self.reloadMessagesView()
                self.finishSendingMessage()
            }
        }
    }
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        if (textView.text) != nil {
//            print(textView.text)
            content = textView.text
            // todo: optimize here
            if content.range(of: "#") != nil && content.range(of: channelName) == nil {
                if let index = content.range(of: "#")?.lowerBound {
                    let sub = content.substring(to: index)
                    self.inputToolbar.contentView.textView.text = sub
                }
            }
            if content.characters.count != 0 {
                let lastChar = content[content.index(before: content.endIndex)]
                
                if !content.isEmpty && lastChar == "#" {
                    print("jump to tag page")
                    
                    listVC?.removeFromParentViewController()
                    listVC = self.storyboard?.instantiateViewController(withIdentifier: "TagListVC") as? TagListVC
                    
                    if let vc = listVC {
                        listView = vc.view
                        self.addChildViewController(listVC!)
                        self.view.addSubview(listView)
                        
                        textView.resignFirstResponder()
                    }
                }
            }
        }
        
    }
    
    func cancelTag() {
        if let rawText = self.inputToolbar.contentView.textView.text {
            if let index = rawText.range(of: "#")?.lowerBound {
                let sub = rawText.substring(to: index)
                self.inputToolbar.contentView.textView.text = sub
            }
        }
    }
    
    func chooseTag(notification: Notification) {
        let info = notification.userInfo
        if let channelName = info?["channelName"] as? String, let longitude = info?["longitude"] as? Double, let latitude = info?["latitude"] as? Double {
            self.is_tagged = true
            self.channelName = channelName
            self.longitude = longitude
            self.latitude = latitude
            self.inputToolbar.contentView.textView.text = self.inputToolbar.contentView.textView.text + channelName + " "
            self.inputToolbar.contentView.textView.becomeFirstResponder()
        }
    }
}
