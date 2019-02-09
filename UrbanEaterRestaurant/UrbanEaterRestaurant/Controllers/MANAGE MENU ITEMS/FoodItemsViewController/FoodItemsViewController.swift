//
//  FoodItemsViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 25/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import UserNotifications
class FoodItemsViewController: UIViewController,SelectGroupDelegate,UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var foodItemsTbl: UITableView!
    @IBOutlet weak var addItems: UIButton!
    
    var collapaseHandlerArray = [String]()
    var selectedSection = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodItemsTbl.register(UINib(nibName: "FoodItemsTableViewCell", bundle: nil), forCellReuseIdentifier: "FoodItemsTableViewCell")
        let nibName = UINib(nibName:"FoodItemsTableViewCell1" , bundle: nil)
        foodItemsTbl.register(nibName, forCellReuseIdentifier: "FoodItemsTableViewCell1")
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
         self.addItems.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35 ,cornerRadius : self.addItems.layer.bounds.h / 2)
        self.foodItemsTbl.tableFooterView = UIView()
        foodItemsTbl.delegate = self
        foodItemsTbl.dataSource = self
        self.manageCategoriesApiHitting()
    }
    //MARK : - Select Group XIB
    func selectGroupXib(){
        let tableView = SelectGroup(nibName: "SelectGroup", bundle: nil)
        tableView.delegate = self
        self.presentPopupViewController(tableView, animationType: MJPopupViewAnimationSlideTopTop)
    }
    func delegateForSelectedGroup(selectedGroup: [String], viewCon: SelectGroup) {
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationSlideBottomBottom)
        if selectedGroup.count != 0 {
            self.foodItemsTbl.reloadData()
        }
    }
    //MARK:- Manage Categories  Api Hitting
    func manageCategoriesApiHitting(){
        Themes.sharedInstance.activityView(View: self.view)
        let param = ["restaurantId": GlobalClass.restaurantLoginModel.data.subId!]
        let header = [X_SESSION_ID : GlobalClass.restaurantLoginModel.data.sessionId!]
        URLhandler.postUrlSession(urlString: Constants.urls.ManageCaegories, params: param as [String : AnyObject], header: header) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                GlobalClass.manageCategoriesModel = ManageCategoriesModel(fromJson: dataResponse.json)
                self.foodItemsTbl.reloadData()
            }
        }
    }
    //MARK:- ManageCategory  Item Delete Api Hitting
    func manageCategoryItemDeleteApiHitting(_ itemID : String){
        Themes.sharedInstance.activityView(View: self.view)
        let param = ["id": itemID]
        let header = [X_SESSION_ID : GlobalClass.restaurantLoginModel.data.sessionId!]
        URLhandler.postUrlSession(urlString: Constants.urls.CategoryFoodItemDelete, params: param as [String : AnyObject], header: header) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                self.manageCategoriesApiHitting()
            }
        }
    }
    //MARK:- ManageCategory  Item Update Api Hitting
    func manageCategoryItemUpdateApiHitting(_ itemID : String, availableStatus : Int , time : String){
        Themes.sharedInstance.activityView(View: self.view)
        let param = ["id": itemID,
                                "available": availableStatus,
                                "nextAvailableTime": time] as [String : Any]
        let header = [X_SESSION_ID : GlobalClass.restaurantLoginModel.data.sessionId!]
        URLhandler.postUrlSession(urlString: Constants.urls.CategoryFoodItemUpdate, params: param as [String : AnyObject], header: header) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                self.manageCategoriesApiHitting()
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func addBtnClicked(_ sender: Any) {
       self.selectGroupXib()
    }
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addItemsBtn(_ sender: UIButton) {
        let viewCon = self.storyboard?.instantiateViewController(withIdentifier: "AddFoodViewController") as! AddFoodViewController
        self.navigationController?.pushViewController(viewCon, animated: true)
    }
}
//MARK:-----TableView Methods------
extension FoodItemsViewController : UITableViewDataSource,UITableViewDelegate {
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
        let cell : FoodItemsTableViewCell1 = tableView.dequeueReusableCell(withIdentifier: "FoodItemsTableViewCell1") as! FoodItemsTableViewCell1
        let data = GlobalClass.manageCategoriesModel.data[indexPath.section].itemList[indexPath.row]
        cell.deleteItem.tag = ("\(indexPath.section+1)\(indexPath.row)").toInt()!
        cell.visibilityItem.tag = ("\(indexPath.section+1)\(indexPath.row)").toInt()!
        cell.tapToEditBtn.tag = ("\(indexPath.section+1)\(indexPath.row)").toInt()!
        cell.deleteItem.addTarget(self, action: #selector(deleteBtnMethod(_:)), for: .touchUpInside)
         cell.visibilityItem.addTarget(self, action: #selector(visibilityButtonMethod(_:)), for: .touchUpInside)
        cell.tapToEditBtn.addTarget(self, action: #selector(tapToEditBtnMethod(_:)), for: .touchUpInside)
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
        if data.available == 1{
            cell.visibilityItem.setImage(#imageLiteral(resourceName: "Visible").withColor(.secondaryBGColor), for: .normal)
        }else{
            cell.visibilityItem.setImage(#imageLiteral(resourceName: "NotVisible").withColor(.secondaryBGColor), for: .normal)
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
        self.foodItemsTbl.reloadSections(IndexSet(integer: sender.tag), with: .none)
    }
    //MARK:- Delete Button method
    @objc func deleteBtnMethod(_ btn : UIButton){
        TheGlobalPoolManager.showAlertWith(title: "Are you sure", message: "You want to delete?", singleAction: false, okTitle:"Confirm") { (sucess) in
            if sucess!{
                let selectedSection = btn.tag.toString
                let index = selectedSection.index(selectedSection.startIndex, offsetBy: 0)
                let selectedIndex = Int(btn.tag.toString.dropFirst())
                let itemID = GlobalClass.manageCategoriesModel.data[selectedSection[index].toInt! - 1].itemList[selectedIndex!].itemId!
                self.manageCategoryItemDeleteApiHitting(itemID)
            }
        }
    }
    //MARK:- Tap to Edit Button method
    @objc func tapToEditBtnMethod(_ btn : UIButton){
        let selectedSection = btn.tag.toString
        let index = selectedSection.index(selectedSection.startIndex, offsetBy: 0)
        let selectedIndex = Int(btn.tag.toString.dropFirst())
        let data = GlobalClass.manageCategoriesModel.data[selectedSection[index].toInt! - 1].itemList[selectedIndex!]
        let viewCon = self.storyboard?.instantiateViewController(withIdentifier: "AddFoodViewController") as! AddFoodViewController
        viewCon.isComingFromEdit = true
        viewCon.categoryName = GlobalClass.manageCategoriesModel.data[selectedSection[index].toInt! - 1].name!
        viewCon.editItemData = data
        self.navigationController?.pushViewController(viewCon, animated: true)
    }
    //MARK:- Visibility Button method
    @objc func visibilityButtonMethod(_ btn : UIButton){
        let selectedSection = btn.tag.toString
        let index = selectedSection.index(selectedSection.startIndex, offsetBy: 0)
        let selectedIndex = Int(btn.tag.toString.dropFirst())
        let data = GlobalClass.manageCategoriesModel.data[selectedSection[index].toInt! - 1].itemList[selectedIndex!]
        if data.available == 1{
            self.setUnavailable(data.itemId!, itemName: data.name!)
        }else{
            self.setAvailable(data.itemId!, itemName: data.name!)
        }
    }
    func setUnavailable(_ itemID: String ,  itemName : String ) {
        let titleText = [NSAttributedStringKey.font : UIFont.appFont(.Medium, size: 16), NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)] as [NSAttributedStringKey : Any]
        let titleAttributed = NSMutableAttributedString(string: "\(itemName) Unavailable ...", attributes:titleText)
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let firstAction: UIAlertAction = UIAlertAction(title: "Upto 1 Hour", style: .default) { action -> Void in
            let dateString = Date().adding(minutes: 60)
            let body = itemName + " was unavailable since 1 hour"
            let identifier = itemID
            let timeInterval = dateString.2.timeIntervalSinceNow
            self.cancelScheduleNotification(identifier)
            self.scheduleLocalNotification(body, identifier: identifier, timeInterval: timeInterval)
            self.updateCategoryItem( dateString.0, itemID: itemID, availableStatus: 0)
        }
        let secondAction: UIAlertAction = UIAlertAction(title: "Upto 4 Hours", style: .default) { action -> Void in
            let dateString = Date().adding(minutes: 240)
            let body = itemName + " was unavailable since 4 hours"
            let identifier = itemID
            let timeInterval = dateString.2.timeIntervalSinceNow
            self.cancelScheduleNotification(identifier)
            self.scheduleLocalNotification(body, identifier: identifier, timeInterval: timeInterval)
            self.updateCategoryItem(dateString.0, itemID: itemID, availableStatus: 0)
        }
        let thirdAction: UIAlertAction = UIAlertAction(title: "Upto 8 Hours", style: .default) { action -> Void in
            let dateString = Date().adding(minutes: 480)
            let body = itemName + " was unavailable since 8 hours"
            let identifier = itemID
            let timeInterval = dateString.2.timeIntervalSinceNow
            self.cancelScheduleNotification(identifier)
            self.scheduleLocalNotification(body, identifier: identifier, timeInterval: timeInterval)
            self.updateCategoryItem(dateString.0, itemID: itemID, availableStatus: 0)
        }
        let fourthAction: UIAlertAction = UIAlertAction(title: "Next Start Time", style: .default) { action -> Void in
            var timeString = GlobalClass.restModel.data.timings.weekDay.startAt
            if Date().weekday.lowercased() == "friday" || Date().weekday.lowercased() == "saturday"{
                timeString = GlobalClass.restModel.data.timings.weekEnd.startAt
            }
            let dateString = Date().addingOneDayExtra(timeString!)
            let body = itemName + " was unavailable since Yesterday"
            let identifier = itemID
            let timeInterval = dateString.1.timeIntervalSinceNow
            self.cancelScheduleNotification(identifier)
            self.scheduleLocalNotification(body, identifier: identifier, timeInterval: timeInterval)
            self.updateCategoryItem(timeString!, itemID: itemID, availableStatus: 0)
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(thirdAction)
        actionSheetController.addAction(fourthAction)
        actionSheetController.addAction(cancelAction)
        actionSheetController.setValue(titleAttributed, forKey : "attributedTitle")
        if UIDevice.current.userInterfaceIdiom == .pad {
            print("IPAD")
            actionSheetController.modalPresentationStyle = .popover
            let popover = actionSheetController.popoverPresentationController!
            popover.delegate = self
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
            self.present(actionSheetController, animated: true, completion: nil )
        }
        else if UIDevice.current.userInterfaceIdiom == .phone{
            print("IPHONE")
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    func setAvailable(_ itemID: String ,  itemName : String ) {
        let titleText = [NSAttributedStringKey.font : UIFont.appFont(.Medium, size: 16), NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)] as [NSAttributedStringKey : Any]
        let titleAttributed = NSMutableAttributedString(string: "\(itemName) Unavailable ...", attributes:titleText)
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let firstAction: UIAlertAction = UIAlertAction(title: "Change Unavailable Time", style: .default) { action -> Void in
            self.setUnavailable(itemID, itemName: itemName)
        }
        let secondAction: UIAlertAction = UIAlertAction(title: "Available This Item", style: .default) { action -> Void in
            self.cancelScheduleNotification(itemID)
            self.updateCategoryItem("", itemID: itemID, availableStatus: 1)
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)
        actionSheetController.setValue(titleAttributed, forKey : "attributedTitle")
        if UIDevice.current.userInterfaceIdiom == .pad {
            print("IPAD")
            actionSheetController.modalPresentationStyle = .popover
            let popover = actionSheetController.popoverPresentationController!
            popover.delegate = self
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
            self.present(actionSheetController, animated: true, completion: nil )
        }
        else if UIDevice.current.userInterfaceIdiom == .phone{
            print("IPHONE")
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    func updateCategoryItem(_  nextAvailableTime : String , itemID : String,availableStatus : Int){
        self.manageCategoryItemUpdateApiHitting(itemID, availableStatus: availableStatus, time: nextAvailableTime)
    }
    func scheduleLocalNotification(_ body:String, identifier:String, timeInterval:TimeInterval){
        let content = UNMutableNotificationContent()
        content.title = "Manage UnAvailable Item"
        content.body = body
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    func cancelScheduleNotification(_ identifier:String){
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == identifier {
                    identifiers.append(notification.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
}

