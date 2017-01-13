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
import SVProgressHUD

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
    var channelType: Int = 0
    var hasPassword: Int = 0
    
    var listVC: TagListVC?
    var listView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.backgroundColor = UIColor.clear
        
        self.setup()
        self.inputToolbar.contentView.leftBarButtonItem = nil
        
        NotificationCenter.default.addObserver(self, selector: #selector(cancelTag), name: NSNotification.Name(rawValue: CANCEL_TAG), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chooseTag), name: NSNotification.Name(rawValue: SELECT_TAG), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMessagesView), name: S_NEW_MESSAGE, object: nil)
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
    
    func reloadMessagesView() {
        self.collectionView?.reloadData()
        
        // scroll to bottom
        self.scrollToBottom(animated: true)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
            backgroundImage.sd_setImage(with: URL(string: url)!, placeholderImage: UIImage(named: "holder")!)
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
        var data: JSQMessageData = JSQMessage(senderId: "", displayName: "", text: "")
        if indexPath.item < messageManager.messages.count {
            data = messageManager.messages[indexPath.item]
        }
        return data
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let msg: ChanhopMessage = messageManager.messages[indexPath.item]
        let text = msg.text!
        
        cell.textView.dataDetectorTypes.remove(.all)
        cell.textView!.textColor = UIColor.white
        
        if msg.senderId == self.senderId{
            cell.messageBubbleTopLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 30)
            cell.cellBottomLabel.textAlignment = .right
        }else{
            cell.messageBubbleTopLabel.textInsets = UIEdgeInsetsMake(0, 35, 0, 0)
            cell.cellBottomLabel.textAlignment = .left
        }
        
        // MARK: to underline the tag
        if msg.isTagged{
            let taggedChannel = msg.taggedChannel
            let channelName = taggedChannel?.name
            let range = channelName?.characters.count
//            print("SANT: tagged:\(msg.isTagged) - channelName:\(channelName) - range: \(range) - text:\(msg.text)")
            let characters = Array(text.characters)
            if characters.contains("#") {
                let indexOfA = characters.index(of: "#")
//                print("SANT: index:\(indexOfA)")
                let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: text)
                
                //font type and size
                attributedString.addAttributes([NSFontAttributeName:UIFont(name:(cell.textView.font?.fontName)!, size: 16.5)!, NSForegroundColorAttributeName: UIColor.white], range: NSMakeRange(0, text.characters.count))
                
                //tag underline with range
                attributedString.addAttributes([NSUnderlineStyleAttributeName:1, NSForegroundColorAttributeName: UIColor.blue], range: NSMakeRange(indexOfA!, (range ?? -2) + 2))
                
                cell.textView.attributedText = attributedString
                print(indexPath.item, cell.textView.attributedText)
                return cell
            }
//            print("is tagged, no # found")
            print(indexPath.item, cell.textView.attributedText)
            return cell
        }else{
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: text)
            
            //font type and size
            attributedString.addAttributes([NSFontAttributeName:UIFont(name:(cell.textView.font?.fontName)!, size: 16.5)!, NSForegroundColorAttributeName: UIColor.white, NSUnderlineStyleAttributeName:0], range: NSMakeRange(0, text.characters.count))
            
            cell.textView.attributedText = attributedString
            print(indexPath.item, cell.textView.attributedText)
            return cell
        }
    }
    
    // original one
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
////        let msg : JSQMessage = (messages[indexPath.row])
//        let msg: ChanhopMessage = messageManager.messages[indexPath.item]
//        if msg.senderId == self.senderId{
//            cell.messageBubbleTopLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 30)
//        }else{
//            cell.messageBubbleTopLabel.textInsets = UIEdgeInsetsMake(0, 35, 0, 0)
//        }
//        if msg.senderId == self.senderId{
//            cell.cellBottomLabel.textAlignment = .right
//        }else {
//            cell.cellBottomLabel.textAlignment = .left
//        }
//      
//        let text = msg.text!
// 
//        
//        // MARK: to underline the tag
//        if msg.isTagged, let taggedChannel = msg.taggedChannel {
//         
//            let channelName = taggedChannel.name
//            let range = channelName.characters.count
//            print("\(msg.isTagged): \(channelName):\(msg.text)")
//            let characters = Array(text.characters)
//            if characters.contains("#") {
//                let indexOfA = characters.index(of: "#")
//                let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: text)
//                attributedString.addAttributes([NSFontAttributeName:UIFont(name: (cell.textView.font?.fontName)!, size: 16)!, NSForegroundColorAttributeName: UIColor.white], range: NSMakeRange(0, text.characters.count))
//                attributedString.addAttributes([NSUnderlineStyleAttributeName:1, NSForegroundColorAttributeName: UIColor.red], range: NSMakeRange(indexOfA!, range+1))
//                cell.textView.attributedText = attributedString
//                   print("\(attributedString)")
//                return cell
//            }
//        
//        }
//        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: text)
//        attributedString.addAttributes([NSFontAttributeName:UIFont(name: "Helvetica Neue", size: 20)!, NSForegroundColorAttributeName: UIColor.white], range: NSMakeRange(0, text.characters.count))
//        cell.textView.attributedText = attributedString
//
//        return cell
//    }
    
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
//
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
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let message = messageManager.messages[indexPath.item]
        print(indexPath.item)
        if message.isTagged {
            if let channel = message.taggedChannel {
                if channel.hashPass != "" {
                    if let channelVC = self.parent?.parent?.parent as? ChannelViewController {
//                        print("yeah!!!!!!! I got to channelvc")
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PasswordVC") as? PasswordVC {
                            vc.joinChannelDelegate = channelVC
                            vc.channelInfo = channel
                            channelVC.addChildViewController(vc)
                            channelVC.view.addSubview(vc.view)
                        }
                    }
                } else {
                    if let channelVC = self.parent?.parent?.parent as? ChannelViewController {
                        let userName = UserManager.shared.userName
                        channelVC.joinChannelAct(channelInfo: channel, userName: userName, password: "", custom: false)
                    }
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: JOIN_CHANNEL), object: nil, userInfo: ["name":channel.name, "password": channel.hashPass, "longitude": channel.longitude, "latitude": channel.latitude, "channelType": channel.channelType])
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
//        if let channelVC = self.parent?.parent?.parent as? ChannelViewController {
//            print("yeah!!!!!!! I got to channelvc")
//            let location = UserDefaults.standard.dictionary(forKey: CURRENT_LOC)
//            let localHopInfo = ChannelInfo(name: "localHop", venueID: "", longitude: location!["longitude"] as! Double, latitude: location!["latitude"] as! Double, distance: 0, address: "", imageURL: "", channelType: 3, adURL: nil, hashPass: "")
//            let userName = UserManager.shared.userName
////            channelVC.joinChannelAct(channelInfo: localHopInfo, userName: userName, password: "", custom: false)
//            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PasswordVC") as? PasswordVC {
//                vc.joinChannelDelegate = channelVC
//                vc.channelInfo = localHopInfo
//                channelVC.addChildViewController(vc)
//                channelVC.view.addSubview(vc.view)
//            }
//        }
        
    }
  
}

//MARK - Toolbar
extension ChatViewController {
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        print("Send button pressed")
        
        if let channel = singleton.channel {
            let tag: Int = is_tagged ? 1 : 0
            socketIOManager.sendMessage(userID: userManager.userID, roomID: channel.roomID, userName: userManager.userName, message: content, is_tagged: tag, channelName: channelName, longitude: longitude, latitude: latitude, channelType: channelType, hasPassword: hasPassword) {_ in
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
            // todo: optimize here, judge the word after "#" is channelName
            if content.range(of: "#") != nil && content.range(of: channelName) == nil {
                if let index = content.range(of: "#")?.lowerBound {
                    let sub = content.substring(to: index)
                    self.inputToolbar.contentView.textView.text = sub
                    self.is_tagged = false
                }
            }
            if content.characters.count != 0 {
                let lastChar = content[content.index(before: content.endIndex)]
                
                if !content.isEmpty && lastChar == "#" {
                    if self.is_tagged {
                        SVProgressHUD.showError(withStatus: "You have tagged a channel already!")
                    } else {
                        content = content.replacingOccurrences(of: "#", with: "")
                        textView.text = content
                        print("jump to tag page")
                        
                        listVC?.removeFromParentViewController()
                        listVC = self.storyboard?.instantiateViewController(withIdentifier: "TagListVC") as? TagListVC
                        
                        if let vc = listVC {
                            listView = vc.view
                            self.addChildViewController(listVC!)
                            self.view.addSubview(listView)
                            
                            listVC?.view.frame = self.view.frame
                            
                            textView.resignFirstResponder()
                        }
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
                self.is_tagged = false
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
            connectionManager.interimChannel(channelName: channelName, longitude: longitude, latitude: latitude, type: 1)
            content = self.inputToolbar.contentView.textView.text + "#" + channelName + " "
            self.inputToolbar.contentView.textView.text = content
            self.inputToolbar.contentView.textView.becomeFirstResponder()
        }
    }
}
