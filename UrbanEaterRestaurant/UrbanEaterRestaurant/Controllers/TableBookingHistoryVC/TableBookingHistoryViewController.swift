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
    var commonUtlity:Utilities = Utilities()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableOrderApiHitting()
    }
    //MARK:- Update UI
    func updateUI(){
        self.HistoryTbl.tableFooterView = UIView()
        self.HistoryTbl.delegate = self
        self.HistoryTbl.dataSource = self
        TheGlobalPoolManager.cornerAndBorder(dateView, cornerRadius: 3, borderWidth: 1, borderColor: .lightGray)
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = Date()
        sortDateLbl.text =  dateFormatter.string(from: date)
        let nibName = UINib(nibName:"CompletedTableCell" , bundle: nil)
        HistoryTbl.register(nibName, forCellReuseIdentifier: "CompletedTableCell")
    }
    //MARK:- Table Order Api Hitting
    func tableOrderApiHitting(){
        Themes.sharedInstance.activityView(View: self.view)
        let param = ["restaurantId": GlobalClass.restaurantLoginModel.data.subId!]
        URLhandler.postUrlSession(urlString: Constants.urls.getTableOrdersURL, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            print("Profile response ----->>> ", dataResponse.json)
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                GlobalClass.tableOrderModel = TableOrderModel(fromJson: dataResponse.json)
                self.HistoryTbl.reloadData()
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
       return GlobalClass.tableOrderModel == nil ? 0 : GlobalClass.tableOrderModel.completed.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedTableCell") as! CompletedTableCell
        let data = GlobalClass.tableOrderModel.completed[indexPath.row]
        cell.stausLbl.isHidden = true
        cell.orderIDLbl.text = "Order ID: \(data.orderId!)"
        cell.dateLbl.text = data.bookedDate!
        cell.timeLbl.text = data.startTime!
        cell.personsLbl.text = data.personCount!.toString
        cell.nameLbl.text = data.contact.name!
        cell.redeemedStatusLbl.text = data.statusText!
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
