//
//  CompletedTableCell.swift
//  UrbanEaterRestaurant
//
//  Created by Vamsi on 04/12/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class CompletedTableCell: UITableViewCell {
    
    @IBOutlet weak var orderIDLbl: UILabel!
    @IBOutlet weak var stausLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var personsLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var redeemedStatusLbl: UILabel!
    @IBOutlet weak var viewInView: ShadowView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ez.runThisInMainThread {
            TheGlobalPoolManager.cornerRadiusForParticularCornerr(self.stausLbl, corners: [.bottomLeft], size: CGSize(width: 5, height: 0))
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
