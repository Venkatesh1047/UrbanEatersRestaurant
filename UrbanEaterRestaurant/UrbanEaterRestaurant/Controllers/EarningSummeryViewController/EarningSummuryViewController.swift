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

    
    var dateSelectedString : String!
    var isFromDateSelected = false
    let dateFormatter = DateFormatter()
    let section = ["Header1","Header2","Header3","Header4","Header5","Header6","Header7"]
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
        dateFormatter.dateFormat = "dd/MM/yyyy"
    }
    //MARK:- IB Action Outlets
    @IBAction func fromDateBtnClicked(_ sender: Any) {
        dateContainerView.isHidden = false
        blurView.isHidden = false
        isFromDateSelected = true
    }
    @IBAction func toDateBtnClicked(_ sender: Any) {
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
            fromDateLbl.text = dateSelectedString
            fromDateLbl.textColor = .textColor
        }else{
            toDateLbl.text = dateSelectedString
            toDateLbl.textColor = .textColor
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
        return section.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryTableViewCell") as! OrderHistoryTableViewCell
        headerCell.dropDownBtn.tag = section
        headerCell.orderIDLbl.text = "Order ID:1AB23456C789"
        if self.collapaseHandlerArray.contains(self.section[section]){
            headerCell.dropDownBtn.setTitle("1", for: .normal)
        }
        else{
            headerCell.dropDownBtn.setTitle("0", for: .normal)
        }
        headerCell.dropDownBtn.addTarget(self, action: #selector(HandleheaderButton(sender:)), for: .touchUpInside)
        return headerCell.contentView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.collapaseHandlerArray.contains(self.section[section]){
            return 4
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsCell") as! ItemsCell
        let itemsArray = ["Veg Biryani","Paneer Butter Masala","Keema Biryni","Chicken Biryani"]
        let priceArray = ["100","150","180","200"]
        cell.contentLbl.text = itemsArray[indexPath.row]
        cell.priceLbl.text = priceArray[indexPath.row]
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
                self.collapaseHandlerArray.append(self.section[sender.tag])
                sender.setTitle("1", for: .normal)
            }
            else {
                while self.collapaseHandlerArray.contains(self.section[sender.tag]){
                    if let itemToRemoveIndex = self.collapaseHandlerArray.index(of: self.section[sender.tag]) {
                        self.collapaseHandlerArray.remove(at: itemToRemoveIndex)
                        sender.setTitle("0", for: .normal)
                    }
                }
            }
        }
        self.earningSTable.reloadSections(IndexSet(integer: sender.tag), with: .none)
    }
}

