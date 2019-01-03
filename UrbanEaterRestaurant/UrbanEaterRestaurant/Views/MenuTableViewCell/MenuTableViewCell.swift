//
//  MenuTableViewCell.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 23/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
@IBOutlet var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.titleLabel.textColor = .textColor
        self.titleLabel.font = UIFont.appFont(.Regular, size: 16)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
