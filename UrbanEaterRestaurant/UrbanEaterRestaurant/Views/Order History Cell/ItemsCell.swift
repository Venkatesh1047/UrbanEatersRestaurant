//
//  ItemsCell.swift
//  UrbanEaterRestaurant
//
//  Created by Vamsi on 07/12/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import UIKit

class ItemsCell: UITableViewCell {
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var vorousTypeImg: UIImageView!
    @IBOutlet weak var quantityLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
