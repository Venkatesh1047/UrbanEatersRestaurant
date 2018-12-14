//
//  OrderHistoryViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 23/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderHistoryViewController: UIViewController {

    @IBOutlet weak var orderHistoryTbl: UITableView!
    let section = ["Header1","Header2","Header3","Header4","Header5","Header6","Header7"]
    var collapaseHandlerArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName:"OrderHistoryTableViewCell" , bundle: nil)
        orderHistoryTbl.register(nibName, forCellReuseIdentifier: "OrderHistoryTableViewCell")
        let nibName1 = UINib(nibName:"ItemsCell" , bundle: nil)
        orderHistoryTbl.register(nibName1, forCellReuseIdentifier: "ItemsCell")
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        orderHistoryTbl.tableFooterView = UIView()
        orderHistoryTbl.delegate = self
        orderHistoryTbl.dataSource = self
        self.foodOrderApiHitting()
    }
    //MARK:- Food Order Api Hitting
    func foodOrderApiHitting(){
        Themes.sharedInstance.activityView(View: self.view)
        let param = ["restaurantId": [GlobalClass.restaurantLoginModel.data.subId!]]
        URLhandler.postUrlSession(urlString: Constants.urls.getFoodOrdersURL, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                GlobalClass.foodOrderModel = FoodOrderModel(fromJson: dataResponse.json)
                self.orderHistoryTbl.reloadData()
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK:-----TableView Methods------
extension OrderHistoryViewController : UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return GlobalClass.foodOrderModel == nil ? 0 : GlobalClass.foodOrderModel.completed.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryTableViewCell") as! OrderHistoryTableViewCell
        headerCell.dropDownBtn.tag = section
        let data = GlobalClass.foodOrderModel.completed[section]
        headerCell.orderIDLbl.text = "Order ID: \(data.order[0].subOrderId!)"
        headerCell.noOfItemsLbl.text = data.items.count.toString
        headerCell.orderAmountLbl.text = "₹\(data.order[0].billing.orderTotal!.toString)"
        headerCell.orderStatusLbl.text = data.order[0].statusText!
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
            return GlobalClass.foodOrderModel.completed[section].items.count
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsCell") as! ItemsCell
        let data = GlobalClass.foodOrderModel.completed[indexPath.row].items[indexPath.row]
        cell.contentLbl.text = data.name!
        cell.priceLbl.text = "₹\(data.price.toString)"
        if data.vorousType == 1{
            cell.vorousTypeImg.image = #imageLiteral(resourceName: "Veg")
        }else{
            cell.vorousTypeImg.image = #imageLiteral(resourceName: "NonVeg")
        }
        cell.quantityLbl.text = "✕\(data.quantity!.toString)"
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
        self.orderHistoryTbl.reloadSections(IndexSet(integer: sender.tag), with: .none)
    }
}

