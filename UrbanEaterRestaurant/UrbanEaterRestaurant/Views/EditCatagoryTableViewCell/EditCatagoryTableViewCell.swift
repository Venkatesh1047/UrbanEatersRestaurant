//
//  EditCatagoryTableViewCell.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 26/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit

class EditCatagoryTableViewCell: UITableViewCell {
    @IBOutlet weak var catagoryTxt: UITextField!
    
    @IBOutlet weak var updateBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateBtn.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
