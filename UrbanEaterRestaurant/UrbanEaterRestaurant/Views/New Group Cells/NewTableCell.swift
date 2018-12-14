//
//  NewTableCell.swift
//  UrbanEaterRestaurant
//
//  Created by Vamsi on 04/12/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import UIKit

class NewTableCell: UITableViewCell {
    @IBOutlet weak var orderIDLbl: UILabel!
    @IBOutlet weak var stausLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var personsLbl: UILabel!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var detailsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var detailsView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        TheGlobalPoolManager.cornerRadiusForParticularCornerr(stausLbl, corners: [.bottomLeft], size: CGSize(width: 5, height: 0))
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
