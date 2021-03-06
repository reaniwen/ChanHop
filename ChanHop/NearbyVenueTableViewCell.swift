//
//  NearbyVenueTableViewCell.swift
//  ChanHop
//
//  Created by Rean Wen on 11/1/16.
//  Copyright © 2016 Rean Wen. All rights reserved.
//

import UIKit

class NearbyVenueTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
//        self.backgroundView = UIView()
//        self.selectedBackgroundView = UIView()
        
        nameLabel.textColor = UIColor.white
        categoryLabel.textColor = UIColor.white
        distanceLabel.textColor = UIColor.gray
        
        categoryLabel.text = "PUBLIC CHANNEL"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
