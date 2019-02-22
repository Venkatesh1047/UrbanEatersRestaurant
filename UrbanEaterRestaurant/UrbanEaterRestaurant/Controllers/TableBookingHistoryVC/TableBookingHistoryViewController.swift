//
//  TableBookingHistoryViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 24/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit
import SwiftyJSON

class TableBookingHistoryViewController: UIViewController {
    
    @IBOutlet weak var HistoryTbl: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateConatinerView: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var fromDateView: UIView!
    @IBOutlet weak var toDateView: UIView!
    @IBOutlet weak var fromDateLbl: UILabel!
    @IBOutlet weak var toDateLbl: UILabel!
    var fromDateString : String!
    
    var toDateString : String!
    var dateSelectedString : String!
    var isFromDateSelected = false
    let dateFormatter = DateFormatter()
    var selectedDate : String = ""
    var skipCountCheck = 0
    var previousSkipCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableHistoryApiHitting(LIMIT_COUNT, skip: SKIP_COUNT)
    }
    //MARK:- Update UI
    func updateUI(){
        self.HistoryTbl.tableFooterView = UIView()
        self.HistoryTbl.delegate = self
        self.HistoryTbl.dataSource = self
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.maximumDate = NSDate() as Date
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        TheGlobalPoolManager.cornerAndBorder(fromDateView, cornerRadius: 5, borderWidth: 1, borderColor: .lightGray)
        TheGlobalPoolManager.cornerAndBorder(toDateView, cornerRadius: 5, borderWidth: 1, borderColor: .lightGray)
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        datePicker.maximumDate = NSDate() as Date
        datePicker.maximumDate = Date()
        let nibName = UINib(nibName:"CompletedTableCell" , bundle: nil)
        HistoryTbl.register(nibName, forCellReuseIdentifier: "CompletedTableCell")
    }
    //MARK:- Table History Api Hitting
    func tableHistoryApiHitting(_ limit:Int, skip:Int){
        print("Hitting Api with ============= \(skip)")
        Themes.sharedInstance.activityView(View: self.view)
        var param = [String : AnyObject]()
        if toDateString == nil{
           param = ["restaurantId": GlobalClass.restaurantLoginModel.data.subId!] as [String : AnyObject]
        }else if toDateString == fromDateString{
            param = ["restaurantId": GlobalClass.restaurantLoginModel.data.subId!,
                     "date" : toDateString] as [String : AnyObject]
        }
        else{
            param = ["restaurantId": GlobalClass.restaurantLoginModel.data.subId!,
                             "dateRange": [
                             "from": fromDateString,
                             "to": toDateString]] as [String : AnyObject]
        }
        let header = [X_SESSION_ID : GlobalClass.restaurantLoginModel.data.sessionId!]
        URLhandler.postUrlSession(urlString: Constants.urls.TableBookingHistory, params: param as [String : AnyObject], header: header) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                if skip == 0{
                    GlobalClass.tableHistoryModel = TableOrderModel(fromJson: dataResponse.json)
                }else{
                    if let dataModel = TableOrderModel(fromJson: dataResponse.json).completed{
                        GlobalClass.tableHistoryModel.completed.append(contentsOf: dataModel)
                    }
                }
                if GlobalClass.tableHistoryModel.data.count == 0{
                    TheGlobalPoolManager.showToastView(ToastMessages.No_Data_Available)
                    self.HistoryTbl.reloadData()
                }else{
                     self.HistoryTbl.reloadData()
                }
            }
        }
    }
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        dateSelectedString = dateFormatter.string(from: sender.date)
    }
    //MARK:- IB Action Outlets
    @IBAction func fromDateBtnClicked(_ sender: Any) {
        dateConatinerView.isHidden = false
        blurView.isHidden = false
        isFromDateSelected = true
    }
    @IBAction func toDateBtnClicked(_ sender: Any) {
        if fromDateString == nil{
            TheGlobalPoolManager.showToastView("Please select from date first")
            return
        }
        dateConatinerView.isHidden = false
        blurView.isHidden = false
        isFromDateSelected = false
    }
    @IBAction func doneDatePickerBtnClicked(_ sender: Any) {
        dateConatinerView.isHidden = true
        blurView.isHidden = true
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
                self.tableHistoryApiHitting(LIMIT_COUNT, skip: SKIP_COUNT)
            }else if date1! > date2! {
                TheGlobalPoolManager.showAlertWith(message: "Oops!, 'To Date' is past date when compared to 'From Date", singleAction: true, callback: { (success) in
                    if success!{}
                })
                return
            }else if date1! < date2! {
                toDateLbl.text = dateSelectedString
                toDateLbl.textColor = .textColor
                self.tableHistoryApiHitting(LIMIT_COUNT, skip: SKIP_COUNT)
            }
        }
    }
    @IBAction func cancelDatePickerBtnClicked(_ sender: Any) {
        dateConatinerView.isHidden = true
        blurView.isHidden = true
    }
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension TableBookingHistoryViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       return GlobalClass.tableHistoryModel == nil ? 0 : GlobalClass.tableHistoryModel.completed.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedTableCell") as! CompletedTableCell
        let data = GlobalClass.tableHistoryModel.completed[indexPath.row]
        cell.stausLbl.isHidden = true
        cell.orderIDLbl.text = "Order ID: \(data.orderId!)"
        cell.dateLbl.text = data.bookedDate!
        cell.timeLbl.text = data.startTime!
        cell.personsLbl.text = data.personCount!.toString
        cell.nameLbl.text = data.contact.name!
        let status = GlobalClass.returnStatus(data.status!)
        cell.redeemedStatusLbl.text = status.0
        cell.redeemedStatusLbl.textColor = status.1
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.isPhone() ? 130 : 160
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if GlobalClass.tableHistoryModel.completed.count == indexPath.row + 1{
            if let tableData = GlobalClass.tableHistoryModel{
                if let data = tableData.completed{
                    let checkingSkip = data.count % LIMIT_COUNT
                    let skipCount = data.count
                    if checkingSkip == 0{
                        if self.previousSkipCount != skipCount{
                            self.previousSkipCount = skipCount
                            self.tableHistoryApiHitting(LIMIT_COUNT, skip: skipCount)
                        }
                    }
                }
            }
        }
    }
}
