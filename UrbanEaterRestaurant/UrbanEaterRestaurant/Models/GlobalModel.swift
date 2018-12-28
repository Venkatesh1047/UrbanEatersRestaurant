//
//  GlobalModel.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 02/11/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import Foundation
import EZSwiftExtensions

let GlobalClass = GlobalModel.sharedInstance

class GlobalModel:NSObject {
    static let sharedInstance = GlobalModel()
    var restaurantLoginModel     : RestaurantLoginModel!
    var foodOrderModel           : FoodOrderModel!
    var tableOrderModel          : TableOrderModel!
    var tableHistoryModel        : TableOrderModel!
    var restModel                        : RestaurantHomeModel!
    var restaurantAllOrdersModel : RestaurantAllOrdersModel!
    var updatePasswordModel      : UpdatePasswordModel!
    var manageCategoriesModel    : ManageCategoriesModel!
    var recommendedModel         : RecommendedModel!
    var earningsHistoryModel     : EarningsHistoryModel!
 
    
    let KEY_ACCEPTED     = "RES_ACCEPTED"
    let KEY_REJECTED     = "RES_REJECTED"
    let KEY_ID           = "id"
    let KEY_DELIVERYTIME = "deliveryTime"
    let KEY_TIMINGS      = "timings"
    let KEY_WEEKDAY      = "weekDay"
    let KEY_WEEKEND      = "weekEnd"
    let KEY_STARTAT      = "startAt"
    let KEY_ENDAT        = "endAt"
    let KEY_STATUS       = "status"
    
    override init() {
        super.init()
    }
    //MARK : - Logout Method
    func logout(){
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
            UIApplication.shared.unregisterForRemoteNotifications()
        }
    }
    //MARK : - Get Time Stamp From NSDate
    func getDateFromTimeStamp(timeStamp : Double) -> String {
        let date = NSDate(timeIntervalSince1970: timeStamp)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"  // Example : 2018-11-27T13:08:20.663Z
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
}
class ButtonWithShadow: UIButton {
    override func draw(_ rect: CGRect) {
        updateLayerProperties()
    }
    func updateLayerProperties() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 3.0
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
    }
}
class viewWithShadow: UIView {
    override func draw(_ rect: CGRect) {
        updateLayerProperties()
    }
    func updateLayerProperties() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 5.0
        self.layer.cornerRadius = self.layer.bounds.height / 2
        self.layer.masksToBounds = true
    }
}
