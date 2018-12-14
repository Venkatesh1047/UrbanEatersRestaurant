//
//  FoodItemsTableViewCell.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 26/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit

class FoodItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var headerNameLbl: UILabel!
    @IBOutlet weak var expandBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
