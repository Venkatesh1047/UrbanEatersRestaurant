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
    
    @IBOutlet weak var deleteItem: UIButton!
    @IBOutlet weak var visibilityItem: UIButton!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemPriceLbl: UILabel!
    @IBOutlet weak var tapToEditBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        TheGlobalPoolManager.cornerAndBorder(itemImgView, cornerRadius: 5, borderWidth: 0, borderColor: .clear)
        self.deleteItem.setImage(#imageLiteral(resourceName: "Delete").withColor(.redColor), for: .normal)
       // self.visibilityItem.isHidden = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
