//
//  MemberListTableViewCell.swift
//  ChanHop
//
//  Created by Rean on 1/12/17.
//  Copyright © 2017 Rean Wen. All rights reserved.
//

import UIKit

class MemberListTableViewCell: UITableViewCell {

    @IBOutlet weak var avatorBackground: UIImageView!
    @IBOutlet weak var userInitialLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        avatorBackground.layer.cornerRadius = 18
        userNameLabel.textColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
