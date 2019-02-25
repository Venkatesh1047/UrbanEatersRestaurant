//
//  ManageRecomendedVC.swift
//  UrbanEaterRestaurant
//
//  Created by Vamsi on 08/02/19.
//  Copyright © 2019 Nagaraju. All rights reserved.
//

import UIKit

class ManageRecomendedVC: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var collapaseHandlerArray = [String]()
    var selectedSection = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateUI()
        tableView.register(UINib(nibName: "FoodItemsTableViewCell", bundle: nil), forCellReuseIdentifier: "FoodItemsTableViewCell")
        let nibName = UINib(nibName:"RecommendedCell" , bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "RecommendedCell")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        self.manageCategoriesApiHitting()
    }
    //MARK:- Manage Categories  Api Hitting
    func manageCategoriesApiHitting(){
        Themes.sharedInstance.activityView(View: self.view)
        let param = [RES_ID: GlobalClass.restaurantLoginModel.data.subId!]
        let header = [X_SESSION_ID : GlobalClass.restaurantLoginModel.data.sessionId!]
        URLhandler.postUrlSession(urlString: Constants.urls.ManageCaegories, params: param as [String : AnyObject], header: header) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                GlobalClass.manageCategoriesModel = ManageCategoriesModel(fromJson: dataResponse.json)
                self.tableView.reloadData()
            }
        }
    }
    //MARK:- Recommended Item Items Delete Api Hitting
    func recommendedItemDeleteApiHitting(_ itemID : String){
        Themes.sharedInstance.activityView(View: self.view)
        let param = [ITEM_LIST: [itemID],
                              RES_ID: GlobalClass.restaurantLoginModel.data.subId!] as [String : Any]
        let header = [X_SESSION_ID : GlobalClass.restaurantLoginModel.data.sessionId!]
        URLhandler.postUrlSession(urlString: Constants.urls.RecommendedItemDelete, params: param as [String : AnyObject], header: header) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                self.manageCategoriesApiHitting()
            }
        }
    }
    //MARK:- Update Recommended Items Hitting
    func updateRecommendedItemsApiHitting(_ itemID : String){
        Themes.sharedInstance.activityView(View: self.view)
        let header = [X_SESSION_ID : GlobalClass.restaurantLoginModel.data.sessionId!]
        let param = [ITEM_LIST: [itemID],
                               RES_ID: GlobalClass.restaurantLoginModel.data.subId!] as [String : Any]
        URLhandler.postUrlSession(urlString: Constants.urls.UpdateRecommendedItems, params: param as [String : AnyObject], header: header) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                self.manageCategoriesApiHitting()
            }
        }
    }
    //MARK:- Visibility Button method
    @objc func recomendedSwitchMethod(_ btn : UISwitch){
        let selectedSection = btn.tag.toString
        let index = selectedSection.index(selectedSection.startIndex, offsetBy: 0)
        let selectedIndex = Int(btn.tag.toString.dropFirst())
        let data = GlobalClass.manageCategoriesModel.data[selectedSection[index].toInt! - 1].itemList[selectedIndex!]
        if data.recommended == 1{
            self.recommendedItemDeleteApiHitting(data.itemId!)
        }else{
            self.updateRecommendedItemsApiHitting(data.itemId!)
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func backBtn(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK:-----TableView Methods------
extension ManageRecomendedVC : UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return GlobalClass.manageCategoriesModel == nil ? 0 : GlobalClass.manageCategoriesModel.data.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIDevice.isPhone() ? 50 : 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.collapaseHandlerArray.contains(GlobalClass.manageCategoriesModel.data[section].name){
            return GlobalClass.manageCategoriesModel.data[section].itemList.count
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.isPhone() ? 90 : 120
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "FoodItemsTableViewCell") as! FoodItemsTableViewCell
        let data = GlobalClass.manageCategoriesModel.data[section]
        headerCell.headerNameLbl.text = data.name!
        headerCell.expandBtn.tag = section
        if self.collapaseHandlerArray.contains(GlobalClass.manageCategoriesModel.data[section].name){
            headerCell.expandBtn.setTitle("Hide", for: .normal)
            headerCell.expandBtn.setImage(#imageLiteral(resourceName: "UpArrow"), for: .normal)
        }
        else{
            headerCell.expandBtn.setImage(#imageLiteral(resourceName: "DownArrow"), for: .normal)
            headerCell.expandBtn.setTitle("Show", for: .normal)
        }
        headerCell.expandBtn.addTarget(self, action: #selector(self.HandleExpandButton(sender:)), for: .touchUpInside)
        return headerCell.contentView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : RecommendedCell = tableView.dequeueReusableCell(withIdentifier: "RecommendedCell") as! RecommendedCell
        let data = GlobalClass.manageCategoriesModel.data[indexPath.section].itemList[indexPath.row]
        cell.on_offSwitch.tag = ("\(indexPath.section+1)\(indexPath.row)").toInt()!
        cell.on_offSwitch.addTarget(self, action: #selector(recomendedSwitchMethod(_:)), for: .valueChanged)
        cell.itemNameLbl.text = data.name!
        cell.itemPriceLbl.text = "₹ \(data.price!.toString)"
        let sourceString = data.avatar!.contains("http", compareOption: .caseInsensitive) ? data.avatar! : Constants.BASEURL_IMAGE + data.avatar!
        let url = URL.init(string: sourceString)
        cell.itemImgView.sd_setImage(with: url ,placeholderImage:  #imageLiteral(resourceName: "PlaceHolderImage")) { (image, error, cache, url) in
            if error != nil{
            }else{
                cell.itemImgView.image = image
            }
        }
        if data.recommended! == 1{
            cell.on_offSwitch.isOn = true
        }else{
            cell.on_offSwitch.isOn = false
        }
        return cell
    }
    //Header cell button Action
    @objc func HandleExpandButton(sender: UIButton){
        selectedSection = sender.tag
        if let buttonTitle = sender.title(for: .normal) {
            if buttonTitle == "Show"{
                self.collapaseHandlerArray.append(GlobalClass.manageCategoriesModel.data[sender.tag].name!)
                sender.setTitle("Hide", for: .normal)
            }else {
                while self.collapaseHandlerArray.contains(GlobalClass.manageCategoriesModel.data[sender.tag].name!){
                    if let itemToRemoveIndex = self.collapaseHandlerArray.index(of: GlobalClass.manageCategoriesModel.data[sender.tag].name!) {
                        self.collapaseHandlerArray.remove(at: itemToRemoveIndex)
                        sender.setTitle("Show", for: .normal)
                    }
                }
            }
        }
        self.tableView.reloadSections(IndexSet(integer: sender.tag), with: .none)
    }
}
