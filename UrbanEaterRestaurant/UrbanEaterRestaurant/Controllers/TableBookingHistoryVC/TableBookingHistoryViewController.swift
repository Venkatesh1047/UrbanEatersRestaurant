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
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var HistoryTbl: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateConatinerView: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var sortDateLbl: UILabel!
    var dateSelectedString : String!
    let dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableHistoryApiHitting()
    }
    //MARK:- Update UI
    func updateUI(){
        self.HistoryTbl.tableFooterView = UIView()
        self.HistoryTbl.delegate = self
        self.HistoryTbl.dataSource = self
        TheGlobalPoolManager.cornerAndBorder(dateView, cornerRadius: 3, borderWidth: 1, borderColor: .lightGray)
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.maximumDate = NSDate() as Date
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        sortDateLbl.text =  "Choose Date"
        let nibName = UINib(nibName:"CompletedTableCell" , bundle: nil)
        HistoryTbl.register(nibName, forCellReuseIdentifier: "CompletedTableCell")
    }
    //MARK:- Table History Api Hitting
    func tableHistoryApiHitting(){
        Themes.sharedInstance.activityView(View: self.view)
        var param = [String : AnyObject]()
        if dateSelectedString == nil{
            param = ["restaurantId": GlobalClass.restaurantLoginModel.data.subId!] as [String : AnyObject]
        }else{
             param = ["restaurantId": GlobalClass.restaurantLoginModel.data.subId!,
                              "date" : dateSelectedString] as [String : AnyObject]
        }
        URLhandler.postUrlSession(urlString: Constants.urls.TableBookingHistory, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                GlobalClass.tableHistoryModel = TableOrderModel(fromJson: dataResponse.json)
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
    @IBAction func sortDateBtnClicked(_ sender: Any) {
        dateConatinerView.isHidden = false
        blurView.isHidden = false
    }
    @IBAction func doneDatePickerBtnClicked(_ sender: Any) {
        dateConatinerView.isHidden = true
        blurView.isHidden = true
        if  dateSelectedString != nil {
            sortDateLbl.text = dateSelectedString
            self.tableHistoryApiHitting()
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
        return 130
    }
}
