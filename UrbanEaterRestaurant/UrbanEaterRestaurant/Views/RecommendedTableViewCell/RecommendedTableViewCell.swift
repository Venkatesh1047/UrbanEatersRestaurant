//
//  RecommendedTableViewCell.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 26/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit

class RecommendedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var itemImgView: UIImageView!
    
    @IBOutlet weak var itemDeleteBtn: UIButton!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemPriceLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        TheGlobalPoolManager.cornerAndBorder(itemImgView, cornerRadius: 5, borderWidth: 0, borderColor: .clear)
        itemImgView.image = #imageLiteral(resourceName: "Delete").withColor(.secondaryBGColor)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
