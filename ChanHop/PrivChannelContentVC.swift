//
//  PrivChannelContentViewController.swift
//  ChanHop
//
//  Created by Rean Wen on 11/28/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit
import StoreKit
import SVProgressHUD

class PrivChannelContentVC: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    @IBOutlet weak var channelNameLabel: UITextField!
    @IBOutlet weak var passwordFrame: UIView!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var confirmPassFrame: UIView!
    @IBOutlet weak var confirmPassLabel: UITextField!
    
    var channelName: String = ""
    var channelPass: String = ""
    
    var products = [SKProduct]()
    
    var joinChannelDelegate: JoinChannelDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.clear
        
        self.channelNameLabel.delegate = self
        self.passwordLabel.delegate = self
        self.confirmPassLabel.delegate = self
        
        setPassFrame(frame: passwordFrame)
        setPassFrame(frame: confirmPassFrame)
        self.passwordLabel.attributedPlaceholder = NSAttributedString(string:"CREATE A PASSWORD",attributes:[NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.8)])
        self.confirmPassLabel.attributedPlaceholder = NSAttributedString(string: "RE-TYPE PASSWORD", attributes:[NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.8)])

        
        requestProduct()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func createPrivChannelAct(_ sender: Any) {
        for product in self.products{
            SKPaymentQueue.default().add(self)
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    func setPassFrame(frame: UIView) {
        frame.backgroundColor = UIColor.clear
        frame.layer.masksToBounds = true
        frame.layer.borderWidth = 2
        frame.layer.borderColor = UIColor.white.cgColor
        frame.layer.cornerRadius = 12
    }
    
    func requestProduct(){
        let id: Set<String> = ["com.chanhop.chanhop.newPrivateChannel","jgfgf"]
        let productRequest = SKProductsRequest(productIdentifiers: id)
        productRequest.delegate = self
        productRequest.start()
    }
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("SANT:valid:\(response.products.count)")
        print("SANT:invalid:\(response.invalidProductIdentifiers.count)")
        print("SANT:invalid:\(response.invalidProductIdentifiers.debugDescription)")
        print("SANT:invalid:\(response.invalidProductIdentifiers.description)")
        
        self.products = response.products
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("Sant: hello")
        
        for transaction in transactions {
            
            switch transaction.transactionState {
            case .purchased:
                print("purchased")
                SKPaymentQueue.default().finishTransaction(transaction)
                unlockChannel()
                break
            case .purchasing:
                print("purchasing")
                break
            case .failed:
                print("failed")
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .deferred:
                print("deferred")
                break
            case.restored:
                print("restored")
                SKPaymentQueue.default().finishTransaction(transaction)
                break
                
            }
        }
    }
    
    func unlockChannel(){
        print("purchase complete!")
        // todo: finish the created channel and join channel
//        if let channelName = channelNameLabel.text{
//            let shortName = channelName.replacingOccurrences(of: " ", with: "")
//            if shortName.characters.count != 0 {
//                if passwordLabel.text == confirmPassLabel.text {
//                    if let location = UserDefaults.standard.dictionary(forKey: CURRENT_LOC) {
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: JOIN_CHANNEL), object: nil, userInfo: ["name":channelName, "password": "", "longitude": location["longitude"] as! Double, "latitude": location["latitude"] as! Double, "channelType": 4])
//                        self.dismiss(animated: true, completion: nil)
//                    }
//                } else {
//                    SVProgressHUD.showError(withStatus: "Please type the same password")
//                }
//                
//            } else {
//                SVProgressHUD.showError(withStatus: "Please type a channel name")
//            }
//        } else {
//            SVProgressHUD.showError(withStatus: "Please type a channel name")
//        }
    }
}

extension PrivChannelContentVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTage=textField.tag+1;
        // Try to find next responder
        let nextResponder=textField.superview?.viewWithTag(nextTage) as UIResponder!
        
        if (nextResponder != nil){
            // Found next responder, so set it.
            nextResponder?.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }
        return false // We do not want UITextField to insert line-breaks.
    }
}

//extension PrivChannelContentVC: SKProductsRequestDelegate {
//    func getProductInfo()
//    {
//        if SKPaymentQueue.canMakePayments() {
//            
//            let request = SKProductsRequest(productIdentifiers: self.productID)
//            request.delegate = self
//            request.start()
//        } else {
//            print("Please enable In App Purchase in Settings")
//        }
//    }
//    
//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        
//        var products = response.products
//        print(response.products.count)
//        
//        if (products.count != 0) {
//            product = products[0]
////            buyButton.isEnabled = true
////            productTitle.text = product!.localizedTitle
////            productDescription.text = product!.localizedDescription
//            
//        } else {
//            print("Product not found")
//        }
//        
//        let invalids = response.invalidProductIdentifiers
//        
//        for product in invalids
//        {
//            print("Product not found: \(product)")
//        }
//    }
//    
//    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        for transaction in transactions {
//            
//            switch transaction.transactionState {
//                
//            case SKPaymentTransactionState.purchased:
////                self.unlockFeature()
//                print("payment finished")
//                SKPaymentQueue.default().finishTransaction(transaction)
//                
//            case SKPaymentTransactionState.failed:
//                SKPaymentQueue.default().finishTransaction(transaction)
//            default:
//                break
//            }
//        }
//    }
//}
