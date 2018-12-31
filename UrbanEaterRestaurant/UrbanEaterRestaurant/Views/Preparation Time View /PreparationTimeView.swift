//
//  PreparationTimeView.swift
//  UrbanEaterRestaurant
//
//  Created by Vamsi on 21/12/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class PreparationTimeView: UIViewController {
    @IBOutlet weak var minutesTF: UITextField!
    @IBOutlet weak var addBtn: ButtonWithShadow!
    @IBOutlet weak var reduceBtn: ButtonWithShadow!
    @IBOutlet weak var continueBtn: ButtonWithShadow!
    
    var isComingFromHome : Bool = false
    var orderID : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        TheGlobalPoolManager.cornerAndBorder(self.view, cornerRadius: 15, borderWidth: 0, borderColor: .clear)
        TheGlobalPoolManager.cornerAndBorder(continueBtn, cornerRadius: 8, borderWidth: 0, borderColor: .clear)
        TheGlobalPoolManager.cornerAndBorder(addBtn, cornerRadius: addBtn.bounds.h / 2, borderWidth: 0, borderColor: .clear)
        TheGlobalPoolManager.cornerAndBorder(reduceBtn, cornerRadius: addBtn.bounds.h / 2, borderWidth: 0, borderColor: .clear)
        if GlobalClass.restModel != nil{
            self.minutesTF.text =  GlobalClass.restModel.data.deliveryTime!.toString
        }
    }
    //MARK:- Food Order Update  Request
    func foodOrderUpdateRequestApiHitting(_ orderId : String , resID : String , status : String, preparationTime : String){
        Themes.sharedInstance.activityView(View: self.view)
        let param = ["id": orderId,
                     "restaurantId": [resID],
                     "status": status,
                     "foodPrepTime" : preparationTime.toInt()!] as [String : Any]
        URLhandler.postUrlSession(urlString: Constants.urls.FoodOrderUpdateReqURL, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            if dataResponse.json.exists(){
                // Success.....
                NotificationCenter.default.post(name: Notification.Name("FoodAccepted"), object: nil)
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func addBtn(_ sender: UIButton) {
        let value = ((self.minutesTF.text?.toInt())! + 10)
        if value > 40{
            TheGlobalPoolManager.showToastView("Sorry, maximum time for order is 40 mins")
            return
        }
        self.minutesTF.text = value.toString
    }
    @IBAction func reduceBtn(_ sender: UIButton) {
        let value = ((self.minutesTF.text?.toInt())! - 10)
        if value < 20{
            TheGlobalPoolManager.showToastView("Minimum 20 mins required")
            return
        }
        self.minutesTF.text = value.toString
    }
    @IBAction func continueBtn(_ sender: UIButton) {
        if ((minutesTF.text?.toInt())! >= 20 && (minutesTF.text?.toInt())! <= 40){
            if orderID != nil{
                self.foodOrderUpdateRequestApiHitting(orderID, resID: GlobalClass.restaurantLoginModel.data.subId!, status: GlobalClass.KEY_ACCEPTED, preparationTime: minutesTF.text!)
            }
        }else{
            TheGlobalPoolManager.showAlertWith(message: "Invalid Prepararion time.Min time should be 20 mins and Max time should be 40 mins.", singleAction: true) { (success) in
                if success!{}
            }
        }
    }
}
