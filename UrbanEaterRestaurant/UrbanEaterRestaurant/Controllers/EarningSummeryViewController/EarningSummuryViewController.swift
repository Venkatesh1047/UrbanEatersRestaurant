//
//  EarningSummuryViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 23/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit
import SwiftyJSON

class EarningSummuryViewController: UIViewController {
    @IBOutlet weak var fromDateView: UIView!
    @IBOutlet weak var toDateView: UIView!
    @IBOutlet weak var earningSTable: UITableView!
    @IBOutlet weak var fromDateLbl: UILabel!
    @IBOutlet weak var toDateLbl: UILabel!
    @IBOutlet weak var dateContainerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var totalOrdersLbl: UILabel!
    @IBOutlet weak var totalEarningsLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var exportBtn: UIButton!
    
    var fromDateString : String!
    var toDateString : String!
    var dateSelectedString : String!
    var isFromDateSelected = false
    let dateFormatter = DateFormatter()
    var collapaseHandlerArray = [String]()
     var selectedDate : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName:"OrderHistoryTableViewCell" , bundle: nil)
        earningSTable.register(nibName, forCellReuseIdentifier: "OrderHistoryTableViewCell")
        let nibName1 = UINib(nibName:"ItemsCell" , bundle: nil)
        earningSTable.register(nibName1, forCellReuseIdentifier: "ItemsCell")
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        TheGlobalPoolManager.cornerAndBorder(fromDateView, cornerRadius: 5, borderWidth: 1, borderColor: .lightGray)
        TheGlobalPoolManager.cornerAndBorder(toDateView, cornerRadius: 5, borderWidth: 1, borderColor: .lightGray)

        earningSTable.tableFooterView = UIView()
        earningSTable.delegate = self
        earningSTable.dataSource = self
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        datePicker.maximumDate = NSDate() as Date
        datePicker.maximumDate = Date()
        self.earningsSummaryApiHitting()
    }
    //MARK:- Earnings Summary Api Hitting
    func earningsSummaryApiHitting(){
        Themes.sharedInstance.activityView(View: self.view)
        var param = [String : AnyObject]()
        if toDateString == nil{
            param = [
                "restaurantId": [GlobalClass.restaurantLoginModel.data.subId!],
                "earningStatus": 1
                ] as [String : AnyObject]
        }else{
            param = [
                "restaurantId": [GlobalClass.restaurantLoginModel.data.subId!],
                "dateRange": [
                    "from": fromDateString,
                    "to": toDateString
                ],
                "earningStatus": 1
                ] as [String : AnyObject]
        }
        URLhandler.postUrlSession(urlString: Constants.urls.EarningsSummary, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            print("Profile response ----->>> ", dataResponse.json)
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                GlobalClass.earningsHistoryModel = EarningsHistoryModel(fromJson: dataResponse.json)
                if GlobalClass.earningsHistoryModel.data.earningData.count != 0{
                    let data = GlobalClass.earningsHistoryModel.data.earningData[0]
                    self.totalOrdersLbl.text = data.totalOrderCount!.toString
                    self.totalEarningsLbl.text = "₹ \(data.totalEarnAmount!.toString)"
                }else{
                    self.totalOrdersLbl.text = ""
                    self.totalEarningsLbl.text = ""
                }
                if GlobalClass.earningsHistoryModel.data.orderFoodData.count == 0{
                    TheGlobalPoolManager.showToastView(ToastMessages.No_Data_Available)
                    self.earningSTable.reloadData()
                }else{
                    self.earningSTable.reloadData()
                }
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func exportBtn(_ sender: UIButton) {
    }
    @IBAction func fromDateBtnClicked(_ sender: Any) {
        dateContainerView.isHidden = false
        blurView.isHidden = false
        isFromDateSelected = true
    }
    @IBAction func toDateBtnClicked(_ sender: Any) {
        if fromDateString == nil{
            TheGlobalPoolManager.showToastView("Please select from date first")
            return
        }
        dateContainerView.isHidden = false
        blurView.isHidden = false
        isFromDateSelected = false
    }
    @IBAction func datePickDoneClicked(_ sender: Any) {
        dateContainerView.isHidden = true
        blurView.isHidden = true
        print("dateSelectedString ---->>> \(dateSelectedString)")
        let date = Date()
        if (dateSelectedString ?? "").isEmpty {
            dateSelectedString =  dateFormatter.string(from: date)
        }
        if isFromDateSelected {
            fromDateString = dateSelectedString
            fromDateLbl.text = dateSelectedString
            fromDateLbl.textColor = .textColor
        }else{
            toDateString = dateSelectedString
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date1 = dateFormatter.date(from: fromDateString)
            let date2 = dateFormatter.date(from: toDateString)
            if date1 == date2{
                toDateLbl.text = dateSelectedString
                toDateLbl.textColor = .textColor
                self.earningsSummaryApiHitting()
            }else if date1! > date2! {
                TheGlobalPoolManager.showAlertWith(message: "Oops!, 'To Date' is past date when compared to 'From Date", singleAction: true, callback: { (success) in
                    if success!{}
                })
                return
            }else if date1! < date2! {
                toDateLbl.text = dateSelectedString
                toDateLbl.textColor = .textColor
                self.earningsSummaryApiHitting()
            }
        }
    }
    @IBAction func datePickCancelClicked(_ sender: Any) {
        blurView.isHidden = true
        dateContainerView.isHidden = true
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        dateSelectedString = dateFormatter.string(from: sender.date)
    }
}
//MARK:-----TableView Methods------
extension EarningSummuryViewController : UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return GlobalClass.earningsHistoryModel == nil ? 0 : GlobalClass.earningsHistoryModel.data.orderFoodData.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryTableViewCell") as! OrderHistoryTableViewCell
        headerCell.dropDownBtn.tag = section
        let data = GlobalClass.earningsHistoryModel.data.orderFoodData[section].order[0]
        headerCell.orderIDLbl.text = "Order ID: \(data.subOrderId!)"
        headerCell.noOfItemsLbl.text = "\(GlobalClass.earningsHistoryModel.data.orderFoodData[section].items.count) Items"
        headerCell.orderAmountLbl.text = "₹ \(data.billing.orderTotal!.toString)"
        let status = GlobalClass.returnStatus(data.status!)
        headerCell.orderStatusLbl.text = status.0
        headerCell.orderStatusLbl.textColor = status.1
        print(data.history.orderedAt!)
        headerCell.dateLbl.text = TheGlobalPoolManager.convertDateFormaterForFullDate(data.history.orderedAt!)
        if self.collapaseHandlerArray.contains(data.subOrderId!){
            headerCell.dropDownBtn.setTitle("1", for: .normal)
            headerCell.farwardImg.image = #imageLiteral(resourceName: "UpArrow").withColor(.secondaryTextColor)
        }
        else{
            headerCell.dropDownBtn.setTitle("0", for: .normal)
            headerCell.farwardImg.image = #imageLiteral(resourceName: "Farward").withColor(.secondaryTextColor)
        }
        headerCell.dropDownBtn.addTarget(self, action: #selector(HandleheaderButton(sender:)), for: .touchUpInside)
        return headerCell.contentView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = GlobalClass.earningsHistoryModel.data.orderFoodData[section].order[0].subOrderId!
        if self.collapaseHandlerArray.contains(data){
            return GlobalClass.earningsHistoryModel.data.orderFoodData[section].items.count
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsCell") as! ItemsCell
        let data = GlobalClass.earningsHistoryModel.data.orderFoodData[indexPath.section].items[indexPath.row]
        cell.contentLbl.text = data.name!
        cell.priceLbl.text = "₹ \(data.finalPrice!.toString)"
        cell.quantityLbl.text = "✕\(data.quantity!)"
        if data.vorousType! == 2{
            cell.vorousTypeImg.image = #imageLiteral(resourceName: "NonVeg")
        }else{
           cell.vorousTypeImg.image = #imageLiteral(resourceName: "Veg")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 3
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 10))
        footerView.backgroundColor = .clear
        return footerView
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    @objc func HandleheaderButton(sender: UIButton){
        if let buttonTitle = sender.title(for: .normal) {
            if buttonTitle == "0"{
                let data = GlobalClass.earningsHistoryModel.data.orderFoodData[sender.tag].order[0].subOrderId!
                self.collapaseHandlerArray.append(data)
                sender.setTitle("1", for: .normal)
            }
            else {
                let data = GlobalClass.earningsHistoryModel.data.orderFoodData[sender.tag].order[0].subOrderId!
                while self.collapaseHandlerArray.contains(data){
                    if let itemToRemoveIndex = self.collapaseHandlerArray.index(of: data) {
                        self.collapaseHandlerArray.remove(at: itemToRemoveIndex)
                        sender.setTitle("0", for: .normal)
                    }
                }
            }
        }
        self.earningSTable.reloadSections(IndexSet(integer: sender.tag), with: .none)
    }
}

