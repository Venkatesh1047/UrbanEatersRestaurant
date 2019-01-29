//
//  ForgotPasswordVC.swift
//  UrbanEaterRestaurant
//
//  Created by Vamsi on 14/12/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var emailID: UITextField!
    @IBOutlet weak var sendOTPBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        emailID.placeholderColor("Email ID", color: .placeholderColor)
        TheGlobalPoolManager.cornerAndBorder(sendOTPBtn, cornerRadius: 8, borderWidth: 0, borderColor: .clear)
    }
    //MARK:- Validate
    func validate() -> Bool{
        if (self.emailID.text?.isEmpty)! {
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.Email_Address_Is_Empty)
            return false
        }else if !TheGlobalPoolManager.isValidEmail(testStr: self.emailID.text!){
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.Invalid_Email)
            return false
        }
        return true
    }
    //MARK:- Pushing to OTP VC
    func presentingOTPVC(){
        let viewCon = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController")as? OTPViewController
        self.present(viewCon!, animated: true, completion: nil)
    }
    //MARK:- Send OTP Api Hitting
    func sendOTPApiMethod(){
        if validate(){
            Themes.sharedInstance.activityView(View: self.view)
            let param = [
                "emailId": emailID.text!,
                "through": "MOBILE"
                ] 
            
            URLhandler.postUrlSession(urlString: Constants.urls.ForgotPassword, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
                Themes.sharedInstance.removeActivityView(View: self.view)
                print(dataResponse.json)
                if dataResponse.json.exists(){
                    GlobalClass.updatePasswordModel = UpdatePasswordModel.init(fromJson: dataResponse.json)
                    self.presentingOTPVC()
                }
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func sendOTPBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        self.sendOTPApiMethod()
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
