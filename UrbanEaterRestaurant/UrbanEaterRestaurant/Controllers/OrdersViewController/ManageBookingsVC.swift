//
//  ManageBookingsVC.swift
//  UrbanEaterRestaurant
//
//  Created by Vamsi on 06/12/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import UIKit

class ManageBookingsVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var imgsArray = [#imageLiteral(resourceName: "Img1"),#imageLiteral(resourceName: "Img3"),#imageLiteral(resourceName: "Img2")]
    var titlesArray = ["Manage Bookings","Manage Menu","Manage Business Hours"]
    var lbl1TitlesArray = ["New:","Total Items:","Weekdays:"]
    var lbl2TitlesArray = ["Scheduled:","Available:","Weekends:"]
    var lbl3TitlesArray = ["Completed:","Recomended:","Today Closing Time:"]
    var contentArray = ["Orders","Menu","Time"]
    var lbl1ValuesArray = [String]()
    var lbl2ValuesArray = [String]()
    var lbl3ValuesArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "ManageBookingCell", bundle: nil), forCellReuseIdentifier: "ManageBookingCell")
        //self.updateUI()
    }
    override func viewWillAppear(_ animated: Bool) {
       self.getRestarentDataModel()
    }
    //MARK:- Update UI
    func updateUI(){
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        if GlobalClass.restModel != nil && GlobalClass.restModel.data.statIdData != nil{
            let data = GlobalClass.restModel.data.statIdData!
            if GlobalClass.restModel.data.timings != nil{
                lbl1ValuesArray = [data.order.totalOrdered!.toString,data.food.total!.toString,"\(GlobalClass.restModel.data.timings.weekDay.startAt!)  to  \(GlobalClass.restModel.data.timings.weekDay.endAt!)"]
                lbl2ValuesArray = [data.order.totalAccepted!.toString,data.food.available!.toString,"\(GlobalClass.restModel.data.timings.weekEnd.startAt!)  to  \(GlobalClass.restModel.data.timings.weekEnd.endAt!)"]
                var closingTime  = "_"
                let today = Date()
                let calendar = Calendar(identifier: .gregorian)
                let components = calendar.dateComponents([.weekday], from: today)
                if components.weekday == 1 || components.weekday == 7 {
                    closingTime = GlobalClass.restModel.data.timings.weekEnd.endAt!
                }else {
                    closingTime = GlobalClass.restModel.data.timings.weekDay.endAt!
                }
                lbl3ValuesArray = [data.order.totalCompleted!.toString,data.food.recommended!.toString,closingTime]
            }else{
                lbl1ValuesArray = [data.order.totalOrdered!.toString,data.food.total!.toString," _"]
                lbl2ValuesArray = [data.order.totalAccepted!.toString,data.food.available!.toString," _"]
                lbl3ValuesArray = [data.order.totalCompleted!.toString,data.food.recommended!.toString,"_"]
            }
        }
    }
    //MARK:- Get Restaurant  Data Api
    func getRestarentDataModel(){
        Themes.sharedInstance.activityView(View: self.view)
        let param = [ "id": GlobalClass.restaurantLoginModel.data.subId!]
        URLhandler.postUrlSession(urlString: Constants.urls.getRestaurantDataURL, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                GlobalClass.restModel = RestaurantHomeModel(fromJson: dataResponse.json)
                self.updateUI()
            }
        }
    }
    //MARK: - Pushing to Order VC
    func pushingToOrderVC(){
        if let viewCon = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrdersViewController") as? OrdersViewController {
            viewCon.hidesBottomBarWhenPushed = true
            viewCon.isFoodSelectedFlag = true
            self.navigationController?.pushViewController(viewCon, animated: true)
        }
    }
    //MARK: - Pushing to Manage Menu VC
    func pushingToManageMenuVC(){
        if let viewCon = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ManageMenuVCID") as? ManageMenuViewController {
            viewCon.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewCon, animated: true)
        }
    }
    //MARK: - Pushing to Manage Timings VC
    func pushingToManageTimingsVC(){
        if let viewCon = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BusinessHoursVCID") as? BusinessHoursViewController {
            viewCon.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewCon, animated: true)
        }
    }
}
extension ManageBookingsVC : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell : ManageBookingCell = tableView.dequeueReusableCell(withIdentifier: "ManageBookingCell") as! ManageBookingCell
        cell.imgView.image = imgsArray[indexPath.row]
        cell.titleLbl.text = titlesArray[indexPath.row]
        cell.lbl1Title.text = lbl1TitlesArray[indexPath.row]
        cell.lbl2Title.text = lbl2TitlesArray[indexPath.row]
        cell.lbl3Title.text = lbl3TitlesArray[indexPath.row]
         if GlobalClass.restModel != nil && GlobalClass.restModel.data.statIdData != nil{
            cell.lbl1.text = lbl1ValuesArray[indexPath.row]
            cell.lbl2.text = lbl2ValuesArray[indexPath.row]
            cell.lbl3.text = lbl3ValuesArray[indexPath.row]
        }
        let attrs1 = [NSAttributedStringKey.font : UIFont.appFont(.Regular, size: UIDevice.isPhone() ? 11 : 16), NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)] as [NSAttributedStringKey : Any]
        let attrs2 = [NSAttributedStringKey.font : UIFont.appFont(.Medium, size: UIDevice.isPhone() ? 11 : 16), NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.2823529412, green: 0.7058823529, blue: 0.2549019608, alpha: 1)] as [NSAttributedStringKey : Any]
        let attributedString1 = NSMutableAttributedString(string:"You can manage", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:" \(contentArray[indexPath.row])", attributes:attrs2)
        let attributedString3 = NSMutableAttributedString(string:" from here", attributes:attrs1)
        attributedString1.append(attributedString2)
        attributedString1.append(attributedString3)
        cell.contentLbl.attributedText = attributedString1
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.isPhone() ? 170 : 210
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.pushingToOrderVC()
        case 1:
            self.pushingToManageMenuVC()
        case 2:
            if GlobalClass.restModel.data.available == 0{
                TheGlobalPoolManager.showToastView("Please be in Online to change the Business hours")
            }else{
                self.pushingToManageTimingsVC()
            }
        default:
            break
        }
    }
}
