//
//  ManageBookingCell.swift
//  UrbanEaterRestaurant
//
//  Created by Vamsi on 06/12/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import UIKit

class ManageBookingCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lbl1Title: UILabel!
    @IBOutlet weak var lbl2Title: UILabel!
    @IBOutlet weak var lbl3Title: UILabel!
    @IBOutlet weak var lbl1: UILabelPadded!
    @IBOutlet weak var lbl2: UILabelPadded!
    @IBOutlet weak var lbl3: UILabelPadded!
    @IBOutlet weak var contentLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
