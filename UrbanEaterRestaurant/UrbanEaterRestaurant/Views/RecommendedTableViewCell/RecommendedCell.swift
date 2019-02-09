//
//  RecommendedCell.swift
//  UrbanEaterRestaurant
//
//  Created by Vamsi on 06/02/19.
//  Copyright © 2019 Nagaraju. All rights reserved.
//

import UIKit

class RecommendedCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var itemImgView: UIImageView!
    @IBOutlet weak var on_offSwitch : UISwitch!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemPriceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        TheGlobalPoolManager.cornerAndBorder(itemImgView, cornerRadius: 5, borderWidth: 0, borderColor: .clear)
        on_offSwitch.onTintColor = .themeColor
        on_offSwitch.tintColor = .secondaryBGColor
        on_offSwitch.backgroundColor = .secondaryBGColor
        on_offSwitch.layer.cornerRadius = on_offSwitch.bounds.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
