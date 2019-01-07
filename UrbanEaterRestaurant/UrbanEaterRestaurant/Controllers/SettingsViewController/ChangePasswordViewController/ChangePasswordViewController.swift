//
//  ChangePasswordViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 24/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var oldpassword: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var updateBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        TheGlobalPoolManager.cornerAndBorder(updateBtn, cornerRadius: 5, borderWidth: 0, borderColor: .clear)
        self.updateBtn.backgroundColor = .secondaryBGColor
    }
    //MARK:- Change Password Api Hitting
    func changeNewPassword(){
        if TheGlobalPoolManager.trimString(string: oldpassword.text!) == ""{
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.Invalid_Password)
        }else if !self.isStrongPassword(password: oldpassword.text!) || !isvalidPassword(oldpassword.text!){
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.Invalid_Strong_Password)
        }else if TheGlobalPoolManager.trimString(string: password.text!) == ""{
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.Invalid_Password)
        }else if !self.isStrongPassword(password: password.text!) || !isvalidPassword(password.text!){
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.Invalid_Strong_Password)
        }else if password.text != confirmPassword.text{
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.Password_Missmatch)
        }else{
            self.ChangePasswordWebHit()
        }
    }
    func ChangePasswordWebHit(){
        Themes.sharedInstance.activityView(View: self.view)
        let param = [ "id": GlobalClass.restaurantLoginModel.data.subId!,
                                "currentPassword": oldpassword.text!,
                                "newPassword": password.text!]
        URLhandler.postUrlSession(urlString: Constants.urls.changePasswordURL, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                Themes.sharedInstance.showToastView(dict.object(forKey: "message") as! String)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    public func isStrongPassword(password : String) -> Bool{
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()-_=+{}|?>.<,:;~`’]{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    func isvalidPassword(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^.{6,}$")
        return passwordTest.evaluate(with: password)
    }
    //MARK:- IB Action Outlets
    @IBAction func submitBtnClciked(_ sender: Any){
        changeNewPassword()
    }
    @IBAction func backButtonClicked(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }
}


