//
//  ScheduleFoodCell.swift
//  UrbanEaterRestaurant
//
//  Created by Vamsi on 04/12/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import UIKit

class ScheduleFoodCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var orderLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabelPadded!
    @IBOutlet weak var noOfItemsLbl: UILabel!
    @IBOutlet weak var totalCostLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        TheGlobalPoolManager.cornerRadiusForParticularCornerr(statusLbl, corners: [.bottomLeft], size: CGSize(width: 5, height: 0))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
