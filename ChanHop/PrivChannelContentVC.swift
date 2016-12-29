//
//  PrivChannelContentViewController.swift
//  ChanHop
//
//  Created by Rean Wen on 11/28/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit
import StoreKit

class PrivChannelContentVC: UIViewController {

    @IBOutlet weak var channelNameLabel: UITextField!
    @IBOutlet weak var passwordFrame: UIView!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var confirmPassFrame: UIView!
    @IBOutlet weak var confirmPassLabel: UITextField!
    
    var channelName: String = ""
    var channelPass: String = ""
    
//    var productIDs: Array<String> = ["com.chanhop.chanhop.PurchasePrivateChannel"]
//    var productsArray: Array<SKProduct> = []
    
//    
//    public static let purchasePrivateChannel = "com.chanhop.chanhop.PurchasePrivateChannel"
//    
//    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [PrivChannelContentVC.purchasePrivateChannel]
    
    var product: SKProduct?
    var productID: Set<String> = ["com.chanhop.privateChannel"]
    
    
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
        
//        SKPaymentQueue.default().add(self)
        getProductInfo()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func createPrivChannelAct(_ sender: Any) {
        if let product = product {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            print("payment not inited")
        }
        
    }
    
    func setPassFrame(frame: UIView) {
        frame.backgroundColor = UIColor.clear
        frame.layer.masksToBounds = true
        frame.layer.borderWidth = 2
        frame.layer.borderColor = UIColor.white.cgColor
        frame.layer.cornerRadius = 12
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

extension PrivChannelContentVC: SKProductsRequestDelegate {
    func getProductInfo()
    {
        if SKPaymentQueue.canMakePayments() {
            
            let request = SKProductsRequest(productIdentifiers: self.productID)
            request.delegate = self
            request.start()
        } else {
            print("Please enable In App Purchase in Settings")
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        var products = response.products
        print(response.products.count)
        
        if (products.count != 0) {
            product = products[0]
//            buyButton.isEnabled = true
//            productTitle.text = product!.localizedTitle
//            productDescription.text = product!.localizedDescription
            
        } else {
            print("Product not found")
        }
        
        let invalids = response.invalidProductIdentifiers
        
        for product in invalids
        {
            print("Product not found: \(product)")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            
            switch transaction.transactionState {
                
            case SKPaymentTransactionState.purchased:
//                self.unlockFeature()
                print("payment finished")
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case SKPaymentTransactionState.failed:
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
}
