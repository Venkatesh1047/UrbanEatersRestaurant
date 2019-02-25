//
//  AccountsViewController.swift
//  UrbanEaterRestaurant
//
//  Created by Nagaraju on 27/11/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class AccountsViewController: UIViewController {

    @IBOutlet weak var viewInView: UIView!
    @IBOutlet weak var menuTbl: UITableView!
    @IBOutlet weak var restarentImgView: UIImageView!
    @IBOutlet weak var restarentNameLbl: UILabel!
    @IBOutlet weak var resStartRating: UIButton!
    var menuList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        ez.runThisInMainThread {
            self.viewInView.h = UIDevice.isPhone() ? 220 : 220
        }
        self.resStartRating.setImage(#imageLiteral(resourceName: "Star").withColor(.whiteColor), for: .normal)
        menuList = ["Order History","Earning Summary","Table Booking History","Manage Menu","Settings","Help & Support","Logout"]
        menuTbl.delegate = self
        menuTbl.dataSource = self
       self.getRestarentProfile()
    }
    //MARK:- IB Action Outlets
    func getRestarentProfile(){
        Themes.sharedInstance.activityView(View: self.view)
        let param = [ ID: GlobalClass.restaurantLoginModel.data.subId!]
        let header = [X_SESSION_ID : GlobalClass.restaurantLoginModel.data.sessionId!]
        URLhandler.postUrlSession(urlString: Constants.urls.getRestaurantDataURL, params: param as [String : AnyObject], header: header) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                GlobalClass.restModel = RestaurantHomeModel(fromJson: dataResponse.json)
                if GlobalClass.restModel != nil{
                    self.updateRestUI()
                }else{
                    TheGlobalPoolManager.showToastView("No data available")
                }
            }
        }
    }
    //MARK:- Update RestUI
    func updateRestUI(){
        if GlobalClass.restModel.data.statIdData != nil{
            self.resStartRating.setTitle(String(GlobalClass.restModel.data.statIdData.rating.average!.rounded(toPlaces: 1)), for: .normal)
        }else{
            self.resStartRating.setTitle(String(0.0), for: .normal)
        }
        let restarent = GlobalClass.restModel!
        let sourceString = restarent.data.logo!.contains("http", compareOption: .caseInsensitive) ? restarent.data.logo! : Constants.BASEURL_IMAGE + restarent.data.logo!
        let logoUrl = NSURL(string:sourceString)!
        self.restarentImgView.sd_setImage(with: logoUrl as URL, placeholderImage: nil, options: .cacheMemoryOnly, completed: nil)
        self.restarentNameLbl.text = GlobalClass.restModel.data.name
    }
    //MARK:- Logout Method
    func logoutAction(){
        TheGlobalPoolManager.showAlertWith(title: "Are you sure", message: "Do you want to Logout?", singleAction: false, okTitle:"Confirm") { (sucess) in
            if sucess!{
                self.LogOutWebHit()
                Themes.sharedInstance.activityView(View: self.view)
            }
        }
    }
    //MARK:- Logout Api Hitting
    func LogOutWebHit(){
        let param = [
            ID: GlobalClass.restaurantLoginModel.data.subId!,
            THROUGH: MOBILE]
        let header = [X_SESSION_ID : GlobalClass.restaurantLoginModel.data.sessionId!]
        URLhandler.postUrlSession(urlString: Constants.urls.logoutURL, params: param as [String : AnyObject], header: header) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                Themes.sharedInstance.showToastView(ToastMessages.Logout)
                GlobalClass.logout()
                self.moveToLogin()
            }
        }
    }
    //MARK:- Move to Login
    func moveToLogin(){
        Themes.sharedInstance.removeActivityView(View: self.view)
        GlobalClass.logout()
        if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: "LoginVCID") as? LoginVC{
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.window!.rootViewController = viewCon
        }
    }
}
// MARK:- UI Table View Delegates and Data Sources
extension AccountsViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MenuList", for: indexPath) as! MenuTableViewCell
        cell.titleLabel.text = self.menuList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.isPhone() ? 60 : 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item : String = menuList[indexPath.row]
        switch item {
        case "Order History":
            let orederHistory = self.storyboard?.instantiateViewController(withIdentifier: "OrderHistoryVCID") as! OrderHistoryViewController
            self.navigationController?.pushViewController(orederHistory, animated: true)
        case "Earning Summary":
            let orederHistory = self.storyboard?.instantiateViewController(withIdentifier: "EarningSummuryVCID") as! EarningSummuryViewController
            self.navigationController?.pushViewController(orederHistory, animated: true)
        case "Table Booking History":
            let bookingHistory = self.storyboard?.instantiateViewController(withIdentifier: "TableBookingHistoryVCID") as! TableBookingHistoryViewController
            self.navigationController?.pushViewController(bookingHistory, animated: true)
        case "Manage Menu":
            if GlobalClass.restModel.data.available == 0{
                TheGlobalPoolManager.showToastView("Please be in Online to change the Business hours")
            }else{
                let settings = self.storyboard?.instantiateViewController(withIdentifier: "ManageMenuVCID") as! ManageMenuViewController
                self.navigationController?.pushViewController(settings, animated: true)
            }
        case "Settings":
            let settings = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewControllerID") as! SettingsViewController
            self.navigationController?.pushViewController(settings, animated: true)
        case "Help & Support":
            let helpNsupport = self.storyboard?.instantiateViewController(withIdentifier: "HelpSupportVCID") as! HelpSupportViewController
            self.navigationController?.pushViewController(helpNsupport, animated: true)
        case "Logout":
            DispatchQueue.main.async {
                self.logoutAction()
            }
            break
        default:
            break
        }
    }
}
