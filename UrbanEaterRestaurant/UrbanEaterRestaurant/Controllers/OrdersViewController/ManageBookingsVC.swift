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
    var lbl1ValuesArray = [String]()
    var lbl2ValuesArray = [String]()
    var lbl3ValuesArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "ManageBookingCell", bundle: nil), forCellReuseIdentifier: "ManageBookingCell")
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        if GlobalClass.restModel != nil{
            let data = GlobalClass.restModel.data.statIdData!
            lbl1ValuesArray = [data.order.totalOrdered!.toString,data.food.total!.toString,"\(GlobalClass.restModel.data.bookTableTimings.weekDay.startAt!) to \(GlobalClass.restModel.data.bookTableTimings.weekDay.endAt!)"]
            lbl2ValuesArray = [data.order.totalAccepted!.toString,data.food.available!.toString,"\(GlobalClass.restModel.data.bookTableTimings.weekEnd.startAt!) to \(GlobalClass.restModel.data.bookTableTimings.weekEnd.endAt!)"]
            lbl3ValuesArray = [data.order.totalCompleted!.toString,data.food.recommended!.toString,GlobalClass.restModel.data.bookTableTimings.totalTableCount!.toString] 
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
        cell.lbl1.text = lbl1ValuesArray[indexPath.row]
        cell.lbl2.text = lbl2ValuesArray[indexPath.row]
        cell.lbl3.text = lbl3ValuesArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.pushingToOrderVC()
        case 1:
            self.pushingToManageMenuVC()
        case 2:
            self.pushingToManageTimingsVC()
        default:
            break
        }
    }
}
