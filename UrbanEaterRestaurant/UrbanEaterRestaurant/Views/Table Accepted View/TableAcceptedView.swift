//
//  TableAcceptedView.swift
//  UrbanEaterRestaurant
//
//  Created by Vamsi on 03/01/19.
//  Copyright © 2019 Nagaraju. All rights reserved.
//

import UIKit

class TableAcceptedView: UIViewController {
    
    @IBOutlet weak var orderIDLbl: UILabel!
    @IBOutlet weak var stausLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var personsLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var enterCodeTF: UITextField!
    @IBOutlet weak var doneBtn: ButtonWithShadow!
    @IBOutlet weak var enterOrderCodeBgView: viewWithShadow!
    
    var schedule:TableOrderData!
    var scheduledFromHome : RestaurantAllOrdersData!
    var isComingFromHome : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.doneBtn.backgroundColor = #colorLiteral(red: 0.2823529412, green: 0.7058823529, blue: 0.2549019608, alpha: 0.2997645548)
        self.enterCodeTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        TheGlobalPoolManager.cornerAndBorder(self.view, cornerRadius: 10, borderWidth: 0, borderColor: .clear)
        TheGlobalPoolManager.cornerRadiusForParticularCornerr(stausLbl, corners: [.bottomLeft,.topRight], size: CGSize(width: 5, height: 0))
        TheGlobalPoolManager.cornerAndBorder(enterOrderCodeBgView, cornerRadius: enterOrderCodeBgView.frame.h/2, borderWidth: 0, borderColor: .clear)
        if isComingFromHome{
            self.orderIDLbl.text = "Order ID: \(scheduledFromHome.orderId!)"
            self.dateLbl.text = scheduledFromHome.bookedDate!
            self.timeLbl.text = scheduledFromHome.startTime!
            self.personsLbl.text = scheduledFromHome.personCount!.toString
            self.nameLbl.text = scheduledFromHome.contact.name!
            self.emailLbl.text = scheduledFromHome.contact.email!
        }else{
            self.orderIDLbl.text = "Order ID: \(schedule.orderId!)"
            self.dateLbl.text = schedule.bookedDate!
            self.timeLbl.text = schedule.startTime!
            self.personsLbl.text = schedule.personCount!.toString
            self.nameLbl.text = schedule.contact.name!
            self.emailLbl.text = schedule.contact.email!
        }
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.length == 0{
            self.doneBtn.backgroundColor = #colorLiteral(red: 0.2823529412, green: 0.7058823529, blue: 0.2549019608, alpha: 0.2997645548)
        }else if textField.text?.length == 4{
            self.doneBtn.backgroundColor = .greenColor
        }else{
            self.doneBtn.backgroundColor = #colorLiteral(red: 0.2823529412, green: 0.7058823529, blue: 0.2549019608, alpha: 0.2997645548)
        }
    }
    //MARK:- Table Order Update  Request
    func tableOrderUpdateRequestApiHitting(_ orderId : String , resID : String , status : String, code:String){
        Themes.sharedInstance.activityView(View: self.view)
        let param = ["id": orderId,
                                "restaurantId": resID,
                                "status": status,
                                "code":code] as [String : AnyObject]
        let header = [X_SESSION_ID : GlobalClass.restaurantLoginModel.data.sessionId!]
        URLhandler.postUrlSession(urlString: Constants.urls.TableUpdateByResID, params: param, header: header) { (dataResponse) in
            if dataResponse.json.exists(){
                NotificationCenter.default.post(name: Notification.Name("DoneButtonClicked"), object: nil)
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func doneBtn(_ sender: ButtonWithShadow) {
        self.view.endEditing(true)
        if enterCodeTF.text?.length != 4{
            TheGlobalPoolManager.showToastView("Invalid Order Code")
        }else{
            if isComingFromHome{
                self.tableOrderUpdateRequestApiHitting(scheduledFromHome.id!, resID: GlobalClass.restaurantLoginModel.data.subId!, status: "CUSTOMER_REACHED", code: enterCodeTF.text!)
            }else{
                self.tableOrderUpdateRequestApiHitting(schedule.id!, resID: GlobalClass.restaurantLoginModel.data.subId!, status: "CUSTOMER_REACHED", code: enterCodeTF.text!)
            }
        }
    }
}
