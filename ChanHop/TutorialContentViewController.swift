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
    
    var pageIndex: Int = 0
    var strTitle: String!
    var strPhotoName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        centerImage.image = UIImage(named: strPhotoName)
        topLabel.text = strTitle
        self.view.backgroundColor = UIColor.darkGray
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
