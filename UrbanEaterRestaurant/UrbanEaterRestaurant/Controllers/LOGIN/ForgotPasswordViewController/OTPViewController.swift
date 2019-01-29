//
//  OTPViewController.swift
//  UrbanEaterRestaurant
//
//  Created by Vamsi on 14/12/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class OTPViewController: UIViewController,OTPTextFieldDelegate {

    @IBOutlet weak var otpBGView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var OTP1: OTPTextField!
    @IBOutlet weak var OTP2: OTPTextField!
    @IBOutlet weak var OTP3: OTPTextField!
    @IBOutlet weak var OTP4: OTPTextField!
    @IBOutlet weak var verifyBtn: UIButton!
    
    //New Password View Outlets
    @IBOutlet weak var newPasswordsView: UIView!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    var mobileNumber : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        self.newPasswordsView.isHidden = true
        newPasswordTF.placeholderColor("New Password", color: .placeholderColor)
        confirmPasswordTF.placeholderColor("Confirm Password", color: .placeholderColor)
        TheGlobalPoolManager.cornerAndBorder(verifyBtn, cornerRadius: 8, borderWidth: 0, borderColor: .clear)
        TheGlobalPoolManager.cornerAndBorder(sendBtn, cornerRadius: 8, borderWidth: 0, borderColor: .clear)

        OTP1.delegate = self
        OTP2.delegate = self
        OTP3.delegate = self
        OTP4.delegate = self
        
        OTP1.addTarget(self, action: #selector(OTPViewController.textFieldDidChange(_:)), for: .editingChanged)
        OTP2.addTarget(self, action: #selector(OTPViewController.textFieldDidChange(_:)), for: .editingChanged)
        OTP3.addTarget(self, action: #selector(OTPViewController.textFieldDidChange(_:)), for: .editingChanged)
        OTP4.addTarget(self, action: #selector(OTPViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    //MARK:- Move to Login
    func moveToLogin(){
        print("go to login")
        Themes.sharedInstance.removeActivityView(View: self.view)
        GlobalClass.logout()
        if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: "LoginVCID") as? LoginVC{
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.window!.rootViewController = viewCon
        }
    }
    //MARK:- Update New Password Api Hitting
    func updateNewPasswordApiMethod(){
        if validatePasswords(){
            Themes.sharedInstance.activityView(View: self.view)
            let param = [ "emailId": GlobalClass.updatePasswordModel.data.subId!,
                                    "referenceNumber": GlobalClass.updatePasswordModel.data.referenceNumber!,
                                    "otp": validateOTP().1,
                                    "password" : newPasswordTF.text!] as [String : Any]
            
            URLhandler.postUrlSession(urlString: Constants.urls.UpdateNewPassword, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
                Themes.sharedInstance.removeActivityView(View: self.view)
                print(dataResponse.json)
                if dataResponse.json.exists(){
                    self.moveToLogin()
                }
            }
        }
    }
    //MARK:- Verify OTP Api Hitting
    func verifyOTPApiMethod(_ otp : String){
        Themes.sharedInstance.activityView(View: self.view)
        let param = [ "subId": GlobalClass.updatePasswordModel.data.subId!,
                      "referenceNumber": GlobalClass.updatePasswordModel.data.referenceNumber!,
                      "otp": otp] as [String : Any]
        URLhandler.postUrlSession(urlString: Constants.urls.VerifyOTP, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            print(dataResponse.json)
            if dataResponse.json.exists(){
                ez.runThisInMainThread {
                    self.otpBGView.isHidden = true
                    self.newPasswordsView.isHidden = false
                }
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func verifyBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        if validateOTP().1.length == 4{
            print(validateOTP().1)
            self.verifyOTPApiMethod(validateOTP().1)
        }else{
            Themes.sharedInstance.shownotificationBanner(Msg: "Enter 4-digit OTP")
        }
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func sendBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        self.updateNewPasswordApiMethod()
    }
}
//MARK :- Validation
extension OTPViewController{
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
    func validatePasswords() -> Bool{
        if (self.newPasswordTF.text?.isEmpty)!{
            Themes.sharedInstance.shownotificationBanner(Msg: "Enter new password")
            return false
        }else if (self.confirmPasswordTF.text?.isEmpty)!{
            Themes.sharedInstance.shownotificationBanner(Msg: "Enter confirm password")
            return false
        }else if newPasswordTF.text != confirmPasswordTF.text{
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.Password_Missmatch)
            return false
        }
        return true
    }
}
//MARK :- TextField Delegates
extension OTPViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField){
        let text = textField.text
        if text?.utf16.count==1{
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
        textField.text = ""
        UIView.beginAnimations(nil, context: nil)
        UIView.animate(withDuration: 0.25) {
        }
        UIView.commitAnimations()
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        print(string,range.location,range.length)
        if string == "\n"{
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    func didPressBackspace(textField : OTPTextField){
        let text = textField.text
        print("Text",text ?? "No Text")
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
//MARK:- Override Textfield Delegate
protocol OTPTextFieldDelegate : UITextFieldDelegate {
    func didPressBackspace(textField : OTPTextField)
}
//MARK :- Override TextField
class OTPTextField:UITextField{
    override func deleteBackward() {
        super.deleteBackward()
        if let pinDelegate = self.delegate as? OTPTextFieldDelegate {
            pinDelegate.didPressBackspace(textField: self)
        }
    }
    override func tintColorDidChange() {
        super.tintColorDidChange()
        self.tintColor = UIColor.white
    }
    override func caretRect(for position: UITextPosition) -> CGRect {
        var rect = super.caretRect(for: position)
        rect = CGRect(x: (self.bounds.width-2)/2, y: (self.bounds.height-25)/2, width: 2, height: 25)
        return rect
    }
}
