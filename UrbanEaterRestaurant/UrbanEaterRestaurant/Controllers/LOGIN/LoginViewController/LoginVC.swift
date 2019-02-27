//
//  LoginVC.swift
//  DinedooRestaurant
//
//  Created by Administrator on 20/02/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit
import EZSwiftExtensions  

class LoginVC: UIViewController{
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var passwordHideBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    var mainTheme:Themes = Themes()

    override func viewDidLoad(){
        super.viewDidLoad()
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        emailTxt.placeholderColor("Email", color: .placeholderColor)
        passwordTxt.placeholderColor("Password", color: .placeholderColor)
        passwordHideBtn.setImage(#imageLiteral(resourceName: "NotVisible").withColor(.whiteColor), for: .normal)
        TheGlobalPoolManager.cornerAndBorder(loginBtn, cornerRadius: 8, borderWidth: 0, borderColor: .clear)
    }
    @objc func movoToHome() {
        (UIApplication.shared.delegate as! AppDelegate).SetInitialViewController()
    }
    //MARK:- Login Api Hitting
    func LoginWebHit(){
        Themes.sharedInstance.activityView(View: self.view)
        let param = [EMAIL_ID: emailTxt.text!,
                               PASSWORD: passwordTxt.text!,
                               THROUGH: MOBILE,
                               DEVICE_INFO: [DEVICE_TOKEN: GlobalClass.instanceIDTokenMessage]] as [String:AnyObject]
        
        URLhandler.postUrlSession(urlString: Constants.urls.loginURL, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                GlobalClass.restaurantLoginModel = RestaurantLoginModel.init(fromJson: dataResponse.json)
                if GlobalClass.restaurantLoginModel.data.verified! == 0{
                    let viewCon = self.storyboard?.instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
                    viewCon.password = self.passwordTxt.text!
                    self.present(viewCon, animated: true, completion: nil)
                }else{
                    UserDefaults.standard.set(dataResponse.dictionaryFromJson, forKey: RESTAURANT_INFO)
                    self.movoToHome()
                }
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func passwordHideBtn(_ sender: UIButton) {
        self.passwordHideBtn.setImage(#imageLiteral(resourceName: "NotVisible").withColor(.whiteColor), for: .normal)
        self.passwordHideBtn.setImage(#imageLiteral(resourceName: "Visible").withColor(.whiteColor), for: .selected)
        sender.isSelected = !sender.isSelected
        self.passwordTxt.isSecureTextEntry = !sender.isSelected
    }
    @IBAction func ActionForgotPassword(_ sender: Any){
        let viewCon = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC")as? ForgotPasswordVC
        self.present(viewCon!, animated: true, completion: nil)
    }
    @IBAction func ActionLogin(_ sender: Any){
        if TheGlobalPoolManager.trimString(string: self.emailTxt.text!)  == ""{
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.Email_Address_Is_Empty)
        }else if  !TheGlobalPoolManager.isValidEmail(testStr: self.emailTxt.text!){
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.Invalid_Email)
        }else if TheGlobalPoolManager.trimString(string: self.passwordTxt.text!) == "" {
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.password_empty)
        }else{
            self.LoginWebHit()
        }
    }
}
