//
//  FoodItemsTableViewCell1.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 28/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit

class FoodItemsTableViewCell1: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var itemImgView: UIImageView!
    
    @IBOutlet weak var itemHideBtn: UIButton!
    @IBOutlet weak var itemEyeImgView: UIImageView!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemPriceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
