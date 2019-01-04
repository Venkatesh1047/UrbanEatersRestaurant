//
//  NewFoodCell.swift
//  UrbanEaterRestaurant
//
//  Created by Vamsi on 04/12/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import UIKit

class NewFoodCell: UITableViewCell {

    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.register(UINib.init(nibName: "NewFoodItemsCell", bundle: nil), forCellWithReuseIdentifier: "NewFoodItemsCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
