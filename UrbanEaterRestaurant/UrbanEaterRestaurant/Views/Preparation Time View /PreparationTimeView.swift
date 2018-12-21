//
//  PreparationTimeView.swift
//  UrbanEaterRestaurant
//
//  Created by Vamsi on 21/12/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import UIKit

class PreparationTimeView: UIViewController {
    @IBOutlet weak var minutesTF: UITextField!
    @IBOutlet weak var addBtn: ButtonWithShadow!
    @IBOutlet weak var reduceBtn: ButtonWithShadow!
    @IBOutlet weak var continueBtn: ButtonWithShadow!
    
    var schedule:FoodOrderModelData!
    var scheduledFromHome : RestaurantAllOrdersData!
    var isComingFromHome : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        TheGlobalPoolManager.cornerAndBorder(self.view, cornerRadius: 15, borderWidth: 0, borderColor: .clear)
        TheGlobalPoolManager.cornerAndBorder(continueBtn, cornerRadius: 8, borderWidth: 0, borderColor: .clear)
    }
    //MARK:- IB Action Outlets
    @IBAction func addBtn(_ sender: UIButton) {
        let value = ((self.minutesTF.text?.toInt())! + 5)
        self.minutesTF.text = value.toString
    }
    @IBAction func reduceBtn(_ sender: UIButton) {
        let value = ((self.minutesTF.text?.toInt())! - 5)
        if value != 0{
            self.minutesTF.text = value.toString
        }else{
            TheGlobalPoolManager.showToastView("Minimum time required")
        }
    }
}
