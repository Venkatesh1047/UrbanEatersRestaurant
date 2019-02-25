//
//  VerificationVC.swift
//  UrbanEaterRestaurant
//
//  Created by Vamsi on 28/01/19.
//  Copyright © 2019 Nagaraju. All rights reserved.
//

import UIKit

class VerificationVC: UIViewController,OTPTextFieldDelegate {

    @IBOutlet var OTP1: OTPTextField!
    @IBOutlet var OTP2: OTPTextField!
    @IBOutlet var OTP3: OTPTextField!
    @IBOutlet var OTP4: OTPTextField!
    @IBOutlet weak var verifyOTP: UIButton!
    @IBOutlet weak var resendLbl: UILabel!
    var password : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.tappedOnLabel(_:)))
        self.resendLbl.addGestureRecognizer(tapGes)
        self.resendLbl.isUserInteractionEnabled = true
        OTP1.delegate = self
        OTP2.delegate = self
        OTP3.delegate = self
        OTP4.delegate = self
        
        OTP1.addTarget(self, action: #selector(VerificationVC.textFieldDidChange(_:)), for: .editingChanged)
        OTP2.addTarget(self, action: #selector(VerificationVC.textFieldDidChange(_:)), for: .editingChanged)
        OTP3.addTarget(self, action: #selector(VerificationVC.textFieldDidChange(_:)), for: .editingChanged)
        OTP4.addTarget(self, action: #selector(VerificationVC.textFieldDidChange(_:)), for: .editingChanged)
    }
    @objc func tappedOnLabel(_ sender:UIGestureRecognizer){
        let range = self.resendLbl.attributedText?.string.range(of: "Resend")
        let nsRange = self.resendLbl.attributedText?.string.nsRange(from: range!)
        let tapLocation = sender.location(in: self.resendLbl)
        let index = self.resendLbl.indexOfAttributedTextCharacterAtPoint(point: tapLocation)
        if index > (nsRange?.location)! && index < (nsRange?.location)! + (nsRange?.length)! {
            print("Tapped On Resend")
            if  let loginModel = GlobalClass.restaurantLoginModel{
                if let data = loginModel.data{
                    self.resendOTPApiMethod(data.referenceNumber!, emailID: data.loginId!)
                }
            }
        }else{
            print("Didn't Tapped On Resend")
        }
    }
    @objc func movoToHome() {
        (UIApplication.shared.delegate as! AppDelegate).SetInitialViewController()
    }
    //MARK:- Verify OTP Api Hitting
    func verifyOTPApiMethod(_ otp : String , refNum : String , emialID : String){
        Themes.sharedInstance.activityView(View: self.view)
        let param = [ ID : emialID,
                               OTP: otp,
                               REFERENCE_NUMBER : refNum] as [String : Any]
        
        URLhandler.postUrlSession(urlString: Constants.urls.VerifyOTP_Restaurant, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            print(dataResponse.json)
            if dataResponse.json.exists(){
                self.LoginWebHit()
            }
        }
    }
    //MARK:- ReSend OTP Api Hitting
    func resendOTPApiMethod(_ refNum : String , emailID : String){
        Themes.sharedInstance.activityView(View: self.view)
        let param = [ SUB_ID: emailID,
                               REFERENCE_NUMBER: refNum] as [String : Any]
        
        URLhandler.postUrlSession(urlString: Constants.urls.ResendOTP, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            print(dataResponse.json)
            if dataResponse.json.exists(){
            }
        }
    }
    //MARK:- Login Api Hitting
    func LoginWebHit(){
        Themes.sharedInstance.activityView(View: self.view)
        let param = [EMAIL_ID: GlobalClass.restaurantLoginModel.data.loginId!,
                              PASSWORD: password,
                               THROUGH: MOBILE,
                               DEVICE_INFO: [DEVICE_TOKEN: GlobalClass.instanceIDTokenMessage]] as [String:AnyObject]
        
        URLhandler.postUrlSession(urlString: Constants.urls.loginURL, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                GlobalClass.restaurantLoginModel = RestaurantLoginModel.init(fromJson: dataResponse.json)
                if GlobalClass.restaurantLoginModel.data.verified! == 0{
                    self.dismiss(animated: true, completion: nil)
                }else{
                    UserDefaults.standard.set(dataResponse.dictionaryFromJson, forKey: RESTAURANT_INFO)
                    self.movoToHome()
                }
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func verifyOtoBtn(_ sender: UIButton) {
        if validateOTP().1.length == 4{
            if let loginModel = GlobalClass.restaurantLoginModel{
                if let data = loginModel.data{
                    self.verifyOTPApiMethod(validateOTP().1, refNum: data.referenceNumber!, emialID: data.loginId!)
                }
            }
        }else{
            TheGlobalPoolManager.showToastView(ToastMessages.Invalid_OTP)
        }
    }
}
//MARK :- TextField Delegates
extension VerificationVC : UITextFieldDelegate{
    @objc func textFieldDidChange(_ textField: UITextField){
        let text = textField.text
        if text?.utf16.count==1{
            self.verifyOTP.isEnabled = self.validateOTP().0
            switch textField{
            case OTP1:
                OTP2.becomeFirstResponder()
            case OTP2:
                OTP3.becomeFirstResponder()
            case OTP3:
                OTP4.becomeFirstResponder()
            case OTP4:
                OTP4.resignFirstResponder()
                break
            default:
                break
            }
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField is OTPTextField{
            textField.text = ""
        }
        UIView.beginAnimations(nil, context: nil)
        UIView.animate(withDuration: 0.25) {
            self.verifyOTP.isEnabled = self.validateOTP().0
        }
        UIView.commitAnimations()
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.beginAnimations(nil, context: nil)
        UIView.animate(withDuration: 0.25) {
        }
        UIView.commitAnimations()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if string == "\n"{
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    func didPressBackspace(textField : OTPTextField){
        let text = textField.text
        if text?.utf16.count == 0{
            switch textField{
            case OTP4:
                OTP3.becomeFirstResponder()
            case OTP3:
                OTP2.becomeFirstResponder()
            case OTP2:
                OTP1.becomeFirstResponder()
            case OTP1: break
            default:
                break
            }
        }
    }
}
//MARK :- Validation
extension VerificationVC{
    func validateOTP() -> (Bool,String){
        let otpTF = [OTP1,OTP2,OTP3,OTP4]
        var validation = true
        var otpString = ""
        for otp in otpTF{
            if (otp?.text?.isEmpty)!{
                validation = false
                break
            }
            otpString = otpString + (otp?.text)!
        }
        return (validation,otpString)
    }
}
