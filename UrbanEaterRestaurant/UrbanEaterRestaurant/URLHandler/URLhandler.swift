
//
//  URLhandler.swift
//  UrbanEaterRestaurant
//
//  Created by Nagaraju on 03/11/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import EZSwiftExtensions

class URLhandler: NSObject {
    static let sharedInstance = URLhandler()
    
    // MARK : - Get Api hitting Model
    class func getUrlSession(urlString: String, params: [String : AnyObject]? ,header : [String : String] ,  completion completionHandler:@escaping (_ response: DataResponse<Any>) -> ()) {
        Alamofire.request(urlString,method: .get, parameters: params,encoding : JSONEncoding.default, headers: header).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    let dic = response.result.value as! [String : AnyObject]
                    let stautsCode = dic["statusCode"] as! NSNumber
                    let message     = dic["message"] as! String
                    if Int(stautsCode) >= 200 && Int(stautsCode) < 300{
                        completionHandler(response)
                    }else{
                        Themes.sharedInstance.showToastView(message)
                        Themes.sharedInstance.removeActivityView(View: (URLhandler.sharedInstance.topMostVC()?.view)!)
                    }
                }
                break
            case .failure(_):
                Themes.sharedInstance.removeActivityView(View: (URLhandler.sharedInstance.topMostVC()?.view)!)
                Themes.sharedInstance.showToastView((response.result.error?.localizedDescription)!)
                break
            }
        }
    }
    // MARK : - Post Api hitting Model
    class func postUrlSession(_ hideToast:Bool = false, urlString: String, params: [String : AnyObject] ,header : [String : String] ,  completion completionHandler:@escaping (_ response: DataResponse<Any>) -> ()) {
        Alamofire.request(urlString,method: .post, parameters: params,encoding : JSONEncoding.default, headers: header).responseJSON { (response) in
            print(response.result)
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    let dic = response.result.value as! [String : AnyObject]
                    let stautsCode = dic["statusCode"] as! NSNumber
                    let message     = dic["message"] as! String
                    let code  = dic["code"] as! NSNumber
                    if Int(stautsCode) >= 200 && Int(stautsCode) < 300{
                        completionHandler(response)
                    }else{
                        print(response.result.value,urlString)
                        Themes.sharedInstance.removeActivityView(View: (URLhandler.sharedInstance.topMostVC()?.view)!)
                        if !hideToast{
                            Themes.sharedInstance.showToastView(message)
                        }
                         if !TheGlobalPoolManager.isAlertDisplaying{
                            if Int(code) == 1607 || Int(code) == 1608{
                                TheGlobalPoolManager.showAlertWith(message: ToastMessages.Session_Expired, singleAction: true, callback: { (success) in
                                    if success!{
                                        GlobalClass.logout()
                                        if let viewCon = ez.topMostVC?.storyboard?.instantiateViewController(withIdentifier: "LoginVCID") as? LoginVC{
                                            let appdelegate = UIApplication.shared.delegate as! AppDelegate
                                            appdelegate.window!.rootViewController = viewCon
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
                break
            case .failure(_):
               Themes.sharedInstance.removeActivityView(View: (URLhandler.sharedInstance.topMostVC()?.view)!)
               if !hideToast{
                Themes.sharedInstance.showToastView((response.result.error?.localizedDescription)!)
               }
                break
            }
        }
    }
    // MARK : - Delete Api hitting Model
    class func deleteUrlSession(urlString: String, params: [String : AnyObject]? ,header : [String : String] ,  completion completionHandler:@escaping (_ response: DataResponse<Any>) -> ()) {
        Alamofire.request(urlString,method: .delete, parameters: params,encoding : JSONEncoding.default, headers: header).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    let dic = response.result.value as! [String : AnyObject]
                    let stautsCode = dic["statusCode"] as! NSNumber
                    let message     = dic["message"] as! String
                    if Int(stautsCode) >= 200 && Int(stautsCode) < 300{
                        completionHandler(response)
                    }else{
                        Themes.sharedInstance.removeActivityView(View: (URLhandler.sharedInstance.topMostVC()?.view)!)
                        Themes.sharedInstance.showToastView(message)
                    }
                }
                break
            case .failure(_):
                Themes.sharedInstance.removeActivityView(View: (URLhandler.sharedInstance.topMostVC()?.view)!)
                Themes.sharedInstance.showToastView((response.result.error?.localizedDescription)!)
                break
            }
        }
    }
    // MARK : - Put Api hitting Model
    class func putUrlSession(urlString: String, params: [String : AnyObject] ,header : [String : String] ,  completion completionHandler:@escaping (_ response: DataResponse<Any>) -> ()) {
        Alamofire.request(urlString,method: .put, parameters: params, headers: header).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    let dic = response.result.value as! [String : AnyObject]
                    let stautsCode = dic["statusCode"] as! String
                    let message     = dic["message"] as! String
                    if Int(stautsCode)! >= 200 && Int(stautsCode)! < 300{
                        completionHandler(response)
                    }else{
                    Themes.sharedInstance.removeActivityView(View: (URLhandler.sharedInstance.topMostVC()?.view)!)
                    Themes.sharedInstance.showToastView(message)
                    }
                }
                break
            case .failure(_):
                Themes.sharedInstance.removeActivityView(View: (URLhandler.sharedInstance.topMostVC()?.view)!)
                Themes.sharedInstance.showToastView((response.result.error?.localizedDescription)!)
                break
            }
        }
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
}
extension DataResponse{
    var json:JSON {
        return JSON(self.result.value as Any)
    }
    var dictionary:[String:AnyObject]?{
        return try! JSONSerialization.jsonObject(with: self.result.value as! Data, options: .init(rawValue: 0)) as? [String:AnyObject]
    }
    var restaurantDetails:[String:AnyObject]?{
        return dictionary?["data"] as? [String:AnyObject]
    }
    var dictionaryFromJson:[String:AnyObject]?{
        return self.result.value as? [String:AnyObject]
    }
    var userDetailsFromJson:[String:AnyObject]?{
        return dictionaryFromJson?["userDetails"] as? [String:AnyObject]
    }
}
extension String{
    var toInt:Int{
        return Int(self)!
    }
}

