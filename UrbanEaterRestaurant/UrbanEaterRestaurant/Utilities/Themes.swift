//
//  Themes.swift
//  UrbanEaterRestaurant
//
//  Created by Nagaraju on 31/10/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import UIKit
import SwiftMessages
import MMMaterialDesignSpinner
import Toast_Swift
import EZSwiftExtensions

let TheGlobalPoolManager = Themes.sharedInstance

class Themes: NSObject {
    typealias AlertCallback = (Bool?) -> ()
    static let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    static let sharedInstance = Themes()
    let screenSize:CGRect = UIScreen.main.bounds
    var spinnerView:MMMaterialDesignSpinner=MMMaterialDesignSpinner()
    var isShow : Bool = false
    var isAlertDisplaying = false
     var currentOrderID = ""
    
    var view:UIView{
        return (ez.topMostVC?.view)!
    }
    var vc:UIViewController{
        return ez.topMostVC!
    }
    override init() {
        super.init()
    }
    //MARK:- Store in Userdefaults
    func storeInDefaults(_ value:AnyObject, key:String){
        UserDefaults.standard.set(value, forKey: key)
    }
    //MARK: Retrieve from userdefaults
    func retrieveFromDefaultsFor(_ key:String) -> AnyObject?{
        return UserDefaults.standard.object(forKey: key) as AnyObject
    }
    //MARK: Remove from userdefaults
    func removeFromDefaultsFor(_ key:String){
        UserDefaults.standard.removeObject(forKey: key)
    }
    func cornerRadius(_ object:AnyObject, cornerRad:CGFloat){
        object.layer.cornerRadius = cornerRad
        object.layer.masksToBounds = true
    }
    //MARK:- UIButton Border and Corner radius
    func cornerAndBorder(_ object:AnyObject, cornerRadius : CGFloat , borderWidth : CGFloat, borderColor:UIColor)  {
        object.layer.borderColor = borderColor.cgColor
        object.layer.borderWidth = borderWidth
        object.layer.cornerRadius = cornerRadius
        object.layer.masksToBounds = true
    }
    //MARK:- corner Radius For Header
    func cornerRadiusForParticularCornerr(_ object:AnyObject,  corners:UIRectCorner,  size:CGSize){
        let path = UIBezierPath(roundedRect:object.bounds,
                                byRoundingCorners:corners,
                                cornerRadii: size)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        object.layer.mask = maskLayer
    }
    //MARK:- NS Attributed Text With Color and Font
    func attributedTextWithTwoDifferentTextsWithFont(_ attr1Text : String , attr2Text : String , attr1Color : UIColor , attr2Color : UIColor , attr1Font : Int , attr2Font : Int , attr1FontName : AppFonts , attr2FontName : AppFonts) -> NSAttributedString{
        let attrs1 = [NSAttributedStringKey.font : UIFont.init(name: attr1FontName.fonts, size: CGFloat(attr1Font))!, NSAttributedStringKey.foregroundColor : attr1Color] as [NSAttributedStringKey : Any]
        let attrs2 = [NSAttributedStringKey.font : UIFont.init(name: attr2FontName.fonts, size: CGFloat(attr2Font))!, NSAttributedStringKey.foregroundColor : attr2Color] as [NSAttributedStringKey : Any]
        let attributedString1 = NSMutableAttributedString(string:attr1Text, attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:attr2Text, attributes:attrs2)
        attributedString1.append(attributedString2)
        return attributedString1
    }
    //MARK:- UIAlertController
    func showAlertWith(title:String = "", message:String, singleAction:Bool,  okTitle:String = "Ok", cancelTitle:String = "Cancel", callback:@escaping AlertCallback) {
        self.isAlertDisplaying = true
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: okTitle, style: .default) { action -> Void in
            self.isAlertDisplaying = false
            callback(true)
        }
        if !singleAction{
            let cancelAction: UIAlertAction = UIAlertAction(title: cancelTitle, style: .default) { action -> Void in
                //Just dismiss the action sheet
                self.isAlertDisplaying = false
                callback(false)
            }
            alertController.addAction(cancelAction)
        }
        alertController.addAction(okAction)
        ez.runThisInMainThread {
            self.vc.presentVC(alertController)
        }
    }
    func showToastView(_ title: String) {
        topMostVC()?.view.makeToast(title, duration: 2.0, position: .bottom)
    }
    func shownotificationBanner(Msg: String ){
        let success = MessageView.viewFromNib(layout: .cardView)
        success.configureTheme(.info)
        success.configureContent(title: "Alert!", body: Msg, iconImage: UIImage.init(named: "NotificationIcon")!, iconText: nil, buttonImage: nil, buttonTitle: nil) { (button) in
            print("Notification View Tap")
            SwiftMessages.hide()
        }
        success.button?.isHidden = true
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .top
        successConfig.duration = .seconds(seconds: 5)
        successConfig.presentationContext = .window(windowLevel: UIWindowLevelNormal)
        SwiftMessages.show(config: successConfig, view: success)
    }
    func activityView(View:UIView){
        topMostVC()?.view.isUserInteractionEnabled = true
        spinnerView.frame=CGRect(x: View.center.x-25, y: View.center.y, width: 30, height: 30)
        spinnerView.lineWidth = 3.0
        spinnerView.tintColor = .greenColor
        topMostVC()?.view.addSubview(spinnerView)
        spinnerView.startAnimating()
    }
    func removeActivityView(View:UIView){
        topMostVC()?.view.isUserInteractionEnabled = true
        spinnerView.stopAnimating()
        spinnerView.removeFromSuperview()
    }
    func rotateImage(image: UIImage) -> UIImage {
        if (image.imageOrientation == UIImageOrientation.up ) {
            return image
        }
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return copy!
    }
    func CheckNullvalue(Passed_value:Any?) -> String {
        var Param:Any?=Passed_value
        if(Param == nil || Param is NSNull){
            Param=""
        }else{
            Param = String(describing: Passed_value!)
        }
        return Param as! String
    }
    func topMostVC() -> UIViewController?{
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    //MARK: - Change the Date Formatter
    func convertDateFormater(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return  dateFormatter.string(from: date!)
    }
    //MARK: - Change the Date Formatter
    func convertDateFormaterForFullDate(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let formattedDate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "MMM dd, yyyy"
            return dateFormatter.string(from: formattedDate)
        }
        return date
    }
    //MARK: - Change the Date Formatter
    func convertDateFormaterForFullDate1(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let formattedDate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "MMM dd, yyyy"
            return dateFormatter.string(from: formattedDate)
        }
        return date
    }
    //MARK: - Change the Date Formatter
    func convertDateFormaterForOnlyTime(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let formattedDate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat =  UIDevice.isPhone() ? "dd-MM-yyyy \n\nhh:mm a" : "dd-MM-yyyy \nhh:mm a"
            return dateFormatter.string(from: formattedDate)
        }
        return date
    }
    //MARK: - Getting Past Time from Current time
    func gettingPastTime(_ hours : Int) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.timeZone = NSTimeZone.init(abbreviation: "GMT+5:30")! as TimeZone
        let today = Date()
        let time = Calendar.current.date(byAdding: .hour, value: hours, to: today)
        let strDate = dateFormatter.string(from: time!)
        return strDate
    }
    //MARK: - Trim String
    func trimString(string : String) -> String {
        let trimmedString = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmedString;
    }
    //MARK: -  IS Valid Email Address
    func isValidEmail(testStr:String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    //MARK: -  Remove Meridians Fron Time
    func removeMeridiansfromTime(string : String) -> String {
        var trimmedString = ""
        if string.range(of:"PM") != nil {
            trimmedString = string.replacingOccurrences(of: "PM", with: "")
        }
        if string.range(of:"AM") != nil {
            trimmedString = string.replacingOccurrences(of: "AM", with: "")
        }
        return trimmedString;
    }
    //MARK: - Printing JSON Object.
    func jsonToString(json: AnyObject){
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            print(convertedString ?? "defaultvalue jsonToString")
        } catch let myJSONError {
            print("Error jsonToString",myJSONError)
        }
    }
}
