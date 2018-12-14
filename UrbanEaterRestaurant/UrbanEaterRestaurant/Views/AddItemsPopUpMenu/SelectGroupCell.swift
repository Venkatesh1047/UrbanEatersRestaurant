//
//  SelectGroupCell.swift
//  SCHQApps
//
//  Created by Samcom iMac on 02/04/18.
//  Copyright © 2018 IOS Developers. All rights reserved.
//

import UIKit

class SelectGroupCell: UITableViewCell {

    @IBOutlet weak var selectedImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let uncheckImage: UIImage? =  #imageLiteral(resourceName: "ic_uncheck").withRenderingMode(.alwaysTemplate)
        let checkImage: UIImage? =  #imageLiteral(resourceName: "ic_check").withRenderingMode(.alwaysTemplate)
        selectedImg.image = uncheckImage
        selectedImg.highlightedImage = checkImage
        selectedImg.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func cellSelected(_ isSelectedValue:Bool){
        if isSelectedValue{
            selectedImg.isHighlighted = true
            self.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }else{
            selectedImg.isHighlighted = false
            self.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}
