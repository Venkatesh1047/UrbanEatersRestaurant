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
    @IBOutlet weak var visibilitySwitch: UISwitch!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemPriceLbl: UILabel!
    @IBOutlet weak var tapToEditBtn: UIButton!
    @IBOutlet weak var availableStatuslbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        TheGlobalPoolManager.cornerAndBorder(itemImgView, cornerRadius: 5, borderWidth: 0, borderColor: .clear)
        visibilitySwitch.onTintColor = .themeColor
        visibilitySwitch.tintColor = .secondaryBGColor
        visibilitySwitch.backgroundColor = .secondaryBGColor
        visibilitySwitch.layer.cornerRadius = visibilitySwitch.bounds.height / 2
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
