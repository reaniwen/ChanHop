//
//  TutorialContentViewController.swift
//  ChanHop
//
//  Created by Rean Wen on 10/18/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit

class TutorialContentViewController: UIViewController {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var centerImage: UIImageView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    
    var pageIndex: Int = 0
    var strTitle: String!
    var strPhotoName: String!
    var titleStr: String!
    var desStr: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        centerImage.image = UIImage(named: strPhotoName)
        topLabel.text = strTitle
        titleLabel.text = titleStr
        desLabel.text = desStr
        self.view.backgroundColor = UIColor.init(red: 158/255, green: 222/255, blue: 74/255, alpha: 1)
        if pageIndex == 0 {
            topLabel.isHidden = true
            titleLabel.isHidden = true
        }
        if pageIndex != 3 {
            doneBtn.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
