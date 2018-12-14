//
//  TableViewCell.swift
//  TableWithSections
//
//  Created by IosDeveloper on 03/11/17.
//  Copyright © 2017 iOSDeveloper. All rights reserved.
//

import UIKit
    
class TableViewCell: UITableViewCell {

    @IBOutlet weak var headerNameLbl: UILabel!
    @IBOutlet weak var showBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
