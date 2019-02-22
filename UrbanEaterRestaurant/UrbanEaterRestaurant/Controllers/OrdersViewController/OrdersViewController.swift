//
//  NewOrdersViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 24/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit
import SwiftyJSON
import EZSwiftExtensions

class OrdersViewController: UIViewController {

    @IBOutlet weak var foodBtn: UIButton!
    @IBOutlet weak var tableBtn: UIButton!
    @IBOutlet var manageBookingBtns: [UIButton]!
    @IBOutlet weak var selectionView: MXSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchBgView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var clearBtn: UIImageView!
    @IBOutlet weak var newCountLbl: UILabel!
    
    var searchActive = false
    var dummyFoodOrderModel : FoodOrderModel!
    var dummyTableOrderModel : TableOrderModel!
    var settings = [Any]()
    var isFoodSelectedFlag : Bool = false
    var selectedDate : String = ""
    var isScheduledTabSelected : Bool = false
    var previousSkipCount = 0
    var skipCountCheck    = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(OrdersViewController.methodOfReceivedNotification(notification:)), name: Notification.Name("DoneButtonClicked"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeOnlineOptionsView.methodOfReceivedNotification1(notification:)), name: Notification.Name("FoodAccepted"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OrdersViewController.methodOfReceivedNotification2(_:)), name: Notification.Name("OrderReceived"), object: nil)
        tableView.register(UINib(nibName: "NewFoodCell", bundle: nil), forCellReuseIdentifier: "NewFoodCell")
        tableView.register(UINib(nibName: "NewTableCell", bundle: nil), forCellReuseIdentifier: "NewTableCell")
        tableView.register(UINib(nibName: "ScheduleFoodCell", bundle: nil), forCellReuseIdentifier: "ScheduleFoodCell")
        tableView.register(UINib(nibName: "ScheduledTableCell", bundle: nil), forCellReuseIdentifier: "ScheduledTableCell")
        tableView.register(UINib(nibName: "CompletedTableCell", bundle: nil), forCellReuseIdentifier: "CompletedTableCell")
        self.clearBtn.addTapGesture(tapNumber: 1, target: self, action: #selector(self.clearBtnPressed(_:)))
        if isFoodSelectedFlag {
            self.manageBookingBtns(foodBtn)
        }else{
            self.manageBookingBtns(tableBtn)
        }
         self.updateUI()
     }
    override func viewWillAppear(_ animated: Bool) {
        if !isFoodSelectedFlag{
            self.selectionView.select(index: 1, animated: true)
        }else{
             self.selectionView.select(index: 0, animated: true)
        }
    }
    @objc func clearBtnPressed(_ sender: UITapGestureRecognizer) {
        if self.searchActive || self.clearBtn.image == #imageLiteral(resourceName: "Cancelled").withColor(.greyColor){
            self.clearBtn.image = #imageLiteral(resourceName: "Search")
            self.searchActive = false
            self.searchTF.endEditing(true)
            self.searchTF.text = ""
            self.foodOrderApiHitting(false, limit: LIMIT_COUNT, skip: SKIP_COUNT)
            self.tableOrderApiHitting(false, limit: LIMIT_COUNT, skip: SKIP_COUNT)
        }
    }
    @objc func methodOfReceivedNotification(notification: Notification){
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationSlideTopTop)
        self.foodOrderApiHitting(true, limit: LIMIT_COUNT, skip: SKIP_COUNT)
    }
    @objc func methodOfReceivedNotification1(notification: Notification){
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationSlideTopTop)
        self.foodOrderApiHitting(true, limit: LIMIT_COUNT, skip: SKIP_COUNT)
    }
    @objc func methodOfReceivedNotification2(_ userInfo: Notification){
        if let dic = userInfo.userInfo as? [String:AnyObject]{
            if let orderId = dic["orderId"] as? String{
                if TheGlobalPoolManager.currentOrderID != orderId{
                    TheGlobalPoolManager.currentOrderID = orderId
                    self.foodOrderApiHitting(false, limit: LIMIT_COUNT, skip: SKIP_COUNT)
                    self.tableOrderApiHitting(false, limit: LIMIT_COUNT, skip: SKIP_COUNT)
                }
            }
        }
    }
    //MARK: - Items Detsils Pop Up
    func itemsDetailsPopUpView(_ schedule:FoodOrderModelData){
        let viewCon = ItemsDetailView(nibName: "ItemsDetailView", bundle: nil)
        viewCon.schedule = schedule
        self.presentPopupViewController(viewCon, animationType: MJPopupViewAnimationSlideTopTop)
    }
    //MARK: - Completed Items Detsils Pop Up
    func completdItemsDetailsPopUpView(_ schedule:FoodOrderModelData){
        let viewCon = CompletedItemsPopUp(nibName: "CompletedItemsPopUp", bundle: nil)
        viewCon.schedule = schedule
        self.presentPopupViewController(viewCon, animationType: MJPopupViewAnimationSlideTopTop)
    }
    //MARK: - Manage Preparation Time Pop Up
    func managePreparationTimePopUpView(_ orderID : String){
        let viewCon = PreparationTimeView(nibName: "PreparationTimeView", bundle: nil)
        viewCon.orderID = orderID
        self.presentPopupViewController(viewCon, animationType: MJPopupViewAnimationSlideTopTop)
    }
    //MARK: - Table Reedemed Pop Up
    func tableReedeemedPopUpView(_ schedule:TableOrderData){
        let viewCon = TableAcceptedView(nibName: "TableAcceptedView", bundle: nil)
        viewCon.schedule = schedule
        self.presentPopupViewController(viewCon, animationType: MJPopupViewAnimationSlideTopTop)
    }
    @IBAction func backBtn(_ sender: UIButton) {
        ez.topMostVC?.popVC()
    }
    //MARK:- Update UI
    func updateUI(){
        self.newCountLbl.isHidden = true
        TheGlobalPoolManager.cornerAndBorder(newCountLbl, cornerRadius: newCountLbl.bounds.h / 2, borderWidth: 0, borderColor: .clear)
        self.searchBgView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35 ,cornerRadius : self.searchBgView.layer.bounds.h / 2)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        self.searchTF.delegate = self
        //Selection view...............
        selectionView.backgroundColor = .secondaryBGColor
        selectionView.font = UIFont.appFont(.Medium, size: UIDevice.isPhone() ? 16 : 22)
        selectionView.append(title: "New")
            .set(title: .secondaryBGColor, for: .selected).set(title: .whiteColor, for: .normal)
        selectionView.append(title: "Scheduled")
            .set(title: .secondaryBGColor, for: .selected).set(title: .whiteColor, for: .normal)
        selectionView.append(title: "Completed")
            .set(title: .secondaryBGColor, for: .selected).set(title: .whiteColor, for: .normal)
        selectionView.addTarget(self, action: #selector(self.selectedSegment(_:)), for: .valueChanged)
        if isScheduledTabSelected {
            self.selectionView.select(index: 1, animated: true)
            self.selectedSegment(self.selectionView)
        }
       // self.foodOrderApiHitting(false, limit: LIMIT_COUNT, skip: SKIP_COUNT)
       // self.tableOrderApiHitting(false, limit: LIMIT_COUNT, skip: SKIP_COUNT)
    }
    //MARK:- SelectionView
    @objc func selectedSegment(_ sender:MXSegmentedControl){
        self.view.endEditing(true)
        switch sender.selectedIndex {
        case 0:
            // New ....
            self.previousSkipCount = 0
            self.skipCountCheck = 0
            self.newCountLbl.isHidden = true
            if isFoodSelectedFlag{
                self.foodOrderApiHitting(false, limit: LIMIT_COUNT, skip: SKIP_COUNT)
            }else{
                self.tableOrderApiHitting(false, limit: LIMIT_COUNT, skip: SKIP_COUNT)
            }
            tableView.reloadData()
        case 1:
            // Scheduled ....
            self.previousSkipCount = 0
            self.skipCountCheck = 0
            if isFoodSelectedFlag{
                self.foodOrderApiHitting(false, limit: LIMIT_COUNT, skip: SKIP_COUNT)
            }else{
                self.tableOrderApiHitting(false, limit: LIMIT_COUNT, skip: SKIP_COUNT)
            }
        case 2:
            // Completed ....
            self.previousSkipCount = 0
            self.skipCountCheck = 0
            if isFoodSelectedFlag{
                self.foodOrderApiHitting(false, limit: LIMIT_COUNT, skip: SKIP_COUNT)
            }else{
                self.tableOrderApiHitting(false, limit: LIMIT_COUNT, skip: SKIP_COUNT)
            }
        default:
            break
        }
    }
    //MARK:- Food Order Api Hitting
    func foodOrderApiHitting(_ hideToast:Bool , limit:Int, skip:Int){
        if !hideToast{
            Themes.sharedInstance.activityView(View: self.view)
        }
        var param = [String:AnyObject]()
        param = ["restaurantId": [GlobalClass.restaurantLoginModel.data.subId!]] as [String : AnyObject]
        
        switch selectionView.selectedIndex {
        case 0:
            param["status"] =  "ORDERED" as AnyObject
        case 1:
            param["status"] =  "RES_ON_GOING" as AnyObject
        case 2:
            param["status"] =  "RES_COMPLETED" as AnyObject
        default:
            break
        }
        
        ez.runThisAfterDelay(seconds: 0.0, after: {
            let paramSent =  [DATA:param,FILTER : [LIMIT:limit,SKIP:skip]] as [String : AnyObject]
            Sockets.socketWithName(GET_ORDERS_BY_RESTAURANT_ID, input: paramSent, completionHandler: { (response) in
                Themes.sharedInstance.removeActivityView(View: self.view)
                let data = JSON(response)
                print("data Check",data)
                let foodModel = FoodOrderModel(fromJson: data)
                if GlobalClass.foodOrderModel != nil && self.selectionView.selectedIndex != 0 && self.isFoodSelectedFlag{
                    if foodModel.new.count > GlobalClass.foodOrderModel.new.count{
                        self.newCountLbl.isHidden = false
                        self.newCountLbl.text = "\(foodModel.new.count - GlobalClass.foodOrderModel.new.count)"
                    }else{
                        self.newCountLbl.isHidden = true
                    }
                }
                if !self.searchActive{
                    if skip == 0{
                        GlobalClass.foodOrderModel = foodModel
                        self.dummyFoodOrderModel = foodModel
                    }else{
                        GlobalClass.foodOrderModel.data.append(contentsOf: foodModel.data!)
                        GlobalClass.foodOrderModel.new.append(contentsOf: foodModel.new!)
                        GlobalClass.foodOrderModel.scheduled.append(contentsOf: foodModel.scheduled!)
                        GlobalClass.foodOrderModel.completed.append(contentsOf: foodModel.completed!)
                        if let dataModel = GlobalClass.foodOrderModel{
                            self.dummyFoodOrderModel = dataModel
                        }
                    }
                }
                if GlobalClass.foodOrderModel.data.count == 0{
                    if !hideToast{
                        TheGlobalPoolManager.showToastView("No orders available now")
                    }
                    self.tableView.reloadData()
                }else{
                    self.tableView.reloadData()
                }
            })
        })
    }
    //MARK:- Table Order Api Hitting
    func tableOrderApiHitting(_ hideToast:Bool, limit:Int, skip:Int){
        if !hideToast{
            Themes.sharedInstance.activityView(View: self.view)
        }
        var param = [String : AnyObject]()
        if selectedDate == ""{
            param = ["restaurantId": GlobalClass.restaurantLoginModel.data.subId!] as [String : AnyObject]
        }else{
            param = ["restaurantId": GlobalClass.restaurantLoginModel.data.subId!,
                             "date" : selectedDate] as [String : AnyObject]
        }
        
        switch selectionView.selectedIndex {
        case 0:
            param["status"] =  "ORDERED" as AnyObject
        case 1:
            param["status"] =  "RES_ON_GOING" as AnyObject
        case 2:
            param["status"] =  "RES_COMPLETED" as AnyObject
        default:
            break
        }
        
        ez.runThisAfterDelay(seconds: 0.0, after: {
            let paramSent =  [DATA:param,FILTER : [LIMIT:limit,SKIP:skip]] as [String : AnyObject]
            Sockets.socketWithName(GET_ORDERS_TABLE_BY_RESTAURANT_ID, input: paramSent, completionHandler: { (response) in
                Themes.sharedInstance.removeActivityView(View: self.view)
                let data = JSON(response)
                print("data Check",data)
                let tableModel = TableOrderModel(fromJson: data)
                if GlobalClass.tableOrderModel != nil && self.selectionView.selectedIndex != 0 && !self.isFoodSelectedFlag{
                    if tableModel.new.count > GlobalClass.tableOrderModel.new.count{
                        self.newCountLbl.isHidden = false
                        self.newCountLbl.text = "\(tableModel.new.count - GlobalClass.tableOrderModel.new.count)"
                    }else{
                        self.newCountLbl.isHidden = true
                    }
                }
                if !self.searchActive{
                    if skip == 0{
                        GlobalClass.tableOrderModel = tableModel
                        self.dummyTableOrderModel = tableModel
                    }else{
                        GlobalClass.tableOrderModel.data.append(contentsOf: tableModel.data!)
                        GlobalClass.tableOrderModel.new.append(contentsOf: tableModel.new!)
                        GlobalClass.tableOrderModel.scheduled.append(contentsOf: tableModel.scheduled!)
                        GlobalClass.tableOrderModel.completed.append(contentsOf: tableModel.completed!)
                        if let dataModel = GlobalClass.tableOrderModel{
                            self.dummyTableOrderModel = dataModel
                        }
                    }
                }
                if GlobalClass.tableOrderModel.data.count == 0{
                    if !hideToast{
                        TheGlobalPoolManager.showToastView("No Bookings available now")
                    }
                    self.tableView.reloadData()
                }else{
                    self.tableView.reloadData()
                }
            })
        })
    }
    //MARK:- Food Order Update  Request
    func foodOrderUpdateRequestApiHitting(_ orderId : String , resID : String , status : String){
        Themes.sharedInstance.activityView(View: self.view)
        let param = ["id": orderId,
                               "restaurantId": [resID],
                               "status": status] as [String : Any]
        let header = [X_SESSION_ID : GlobalClass.restaurantLoginModel.data.sessionId!]
        URLhandler.postUrlSession(urlString: Constants.urls.FoodOrderUpdateReqURL, params: param as [String : AnyObject], header: header) { (dataResponse) in
            if dataResponse.json.exists(){
                ez.runThisInMainThread {
                    self.foodOrderApiHitting(true, limit: LIMIT_COUNT, skip: SKIP_COUNT)
                }
            }
        }
    }
    //MARK:- Table Order Update  Request
    func tableOrderUpdateRequestApiHitting(_ orderId : String , resID : String , status : String){
        Themes.sharedInstance.activityView(View: self.view)
        let param = ["id": orderId,
                               "restaurantId": resID,
                                "status": status]
        let header = [X_SESSION_ID : GlobalClass.restaurantLoginModel.data.sessionId!]
        URLhandler.postUrlSession(urlString: Constants.urls.TableOrderUpdatetReqURL, params: param as [String : AnyObject], header: header) { (dataResponse) in
            if dataResponse.json.exists(){
                ez.runThisInMainThread {
                    self.tableOrderApiHitting(true, limit: LIMIT_COUNT, skip: SKIP_COUNT)
                }
            }
        }
    }
    //MARK:- Call Button method
    @objc func callButtonMethod(_ btn : UIButton){
        var number = ""
        if !isFoodSelectedFlag{
            if selectionView.selectedIndex == 0{
                let data = self.dummyTableOrderModel.new[btn.tag]
                number = data.contact.phone!
            }else if selectionView.selectedIndex == 1{
                let data = self.dummyTableOrderModel.scheduled[btn.tag]
                number = data.contact.phone!
            }
        }
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            TheGlobalPoolManager.showToastView("Invalid Phone Number")
        }
    }
    //MARK:- Accept Button method
    @objc func acceptBtnMethod(_ btn : UIButton){
        if isFoodSelectedFlag{
            let data = self.dummyFoodOrderModel.new[btn.tag]
            self.managePreparationTimePopUpView(data.id!)
        }else{
            let data = self.dummyTableOrderModel.new[btn.tag]
            TheGlobalPoolManager.showAlertWith(title: "Are you sure", message: "Do you want to Accept?", singleAction: false, okTitle:"Confirm") { (sucess) in
                if sucess!{
                    self.tableOrderUpdateRequestApiHitting(data.id!, resID: GlobalClass.restaurantLoginModel.data.subId!, status: GlobalClass.KEY_ACCEPTED)
                }
            }
        }
    }
    //MARK:- Reject Button method
    @objc func rejectBtnMethod(_ btn : UIButton){
        if isFoodSelectedFlag{
            let data = self.dummyFoodOrderModel.new[btn.tag]
            TheGlobalPoolManager.showAlertWith(title: "Are you sure", message: "Do you want to Reject?", singleAction: false, okTitle:"Confirm") { (sucess) in
                if sucess!{
                    self.foodOrderUpdateRequestApiHitting(data.id!, resID: GlobalClass.restaurantLoginModel.data.subId!, status: GlobalClass.KEY_REJECTED)
                }
            }
        }else{
            let data = self.dummyTableOrderModel.new[btn.tag]
            TheGlobalPoolManager.showAlertWith(title: "Are you sure", message: "Do you want to Reject?", singleAction: false, okTitle:"Confirm") { (sucess) in
                if sucess!{
                    self.tableOrderUpdateRequestApiHitting(data.id!, resID: GlobalClass.restaurantLoginModel.data.subId!, status: GlobalClass.KEY_REJECTED)
                }
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func manageBookingBtns(_ sender: UIButton) {
        let foodImage   = foodBtn == sender ?   #imageLiteral(resourceName: "Food_Selected") : #imageLiteral(resourceName: "Food_Normal")
        let tableImage   = tableBtn == sender ?   #imageLiteral(resourceName: "Table_Selected") : #imageLiteral(resourceName: "Table_Normal")
        tableBtn.setImage(tableImage, for: .normal)
        foodBtn.setImage(foodImage, for: .normal)
        if sender == foodBtn{
            self.isFoodSelectedFlag = true
            self.foodOrderApiHitting(false, limit: LIMIT_COUNT, skip: SKIP_COUNT)
        }else{
            self.isFoodSelectedFlag = false
            self.tableOrderApiHitting(false, limit: LIMIT_COUNT, skip: SKIP_COUNT)
        }
    }
}
//MARK : - UI Table View Delegate Methods
extension OrdersViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFoodSelectedFlag{
            if selectionView.selectedIndex == 0{
                return self.dummyFoodOrderModel == nil ? 0 : self.dummyFoodOrderModel.new.count
            }else if selectionView.selectedIndex == 1{
                return self.dummyFoodOrderModel == nil ? 0 : self.dummyFoodOrderModel.scheduled.count
            }else{
                return self.dummyFoodOrderModel == nil ? 0 : self.dummyFoodOrderModel.completed.count
            }
        }else{
            if selectionView.selectedIndex == 0{
                return self.dummyTableOrderModel == nil ? 0 : self.dummyTableOrderModel.new.count
            }else if selectionView.selectedIndex == 1{
                return self.dummyTableOrderModel == nil ? 0 : self.dummyTableOrderModel.scheduled.count
            }else{
                return self.dummyTableOrderModel == nil ? 0 : self.dummyTableOrderModel.completed.count
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectionView.selectedIndex == 0{
            return self.returnManageNewFoodCell(tableView, indexPath: indexPath)!
        }else if selectionView.selectedIndex == 1{
            return self.returnManageScheduledCell(tableView, indexPath: indexPath)!
        }else{
            return self.returnManageCompletedCell(tableView, indexPath: indexPath)!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectionView.selectedIndex == 1{
            if self.isFoodSelectedFlag{
                let schedule = self.dummyFoodOrderModel.scheduled[indexPath.row]
                self.itemsDetailsPopUpView(schedule)
            }else{
                let schedule = self.dummyTableOrderModel.scheduled[indexPath.row]
                self.tableReedeemedPopUpView(schedule)
            }
        }else if selectionView.selectedIndex == 2{
            if self.isFoodSelectedFlag{
                let schedule = self.dummyFoodOrderModel.completed[indexPath.row]
                self.completdItemsDetailsPopUpView(schedule)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch selectionView.selectedIndex {
        case 0:
            if self.isFoodSelectedFlag{
                return UIDevice.isPhone() ? 200 : 210
            }else{
                return UIDevice.isPhone() ? 200 : 270
            }
        case 1:
            if self.isFoodSelectedFlag{
                return UIDevice.isPhone() ? 110 : 140
            }else{
                return UIDevice.isPhone() ? 150 : 200
            }
        case 2:
            if self.isFoodSelectedFlag{
                return UIDevice.isPhone() ? 130 : 140
            }else{
                return UIDevice.isPhone() ? 130 : 160
            }
        default:
            break
        }
        return 0
    }
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !self.searchActive{
            if isFoodSelectedFlag{
                switch selectionView.selectedIndex {
                case 0:
                    if self.dummyFoodOrderModel.new.count == indexPath.row + 1{
                        if let foodModel = self.dummyFoodOrderModel{
                            if let data = foodModel.new{
                                let checkingSkip = data.count % LIMIT_COUNT
                                let skipCount = data.count
                                if checkingSkip == 0{
                                    if self.previousSkipCount != skipCount{
                                        self.previousSkipCount = skipCount
                                        self.foodOrderApiHitting(false, limit: LIMIT_COUNT, skip: skipCount)
                                    }
                                }
                            }
                        }
                    }
                case 1:
                    if self.dummyFoodOrderModel.scheduled.count == indexPath.row + 1{
                        if let foodModel = self.dummyFoodOrderModel{
                            if let data = foodModel.scheduled{
                                let checkingSkip = data.count % LIMIT_COUNT
                                let skipCount = data.count
                                if checkingSkip == 0{
                                    if self.previousSkipCount != skipCount{
                                        self.previousSkipCount = skipCount
                                        self.foodOrderApiHitting(false, limit: LIMIT_COUNT, skip: skipCount)
                                    }
                                }
                            }
                        }
                    }
                case 2:
                    if self.dummyFoodOrderModel.completed.count == indexPath.row + 1{
                        if let foodModel = self.dummyFoodOrderModel{
                            if let data = foodModel.completed{
                                let checkingSkip = data.count % LIMIT_COUNT
                                let skipCount = data.count
                                if checkingSkip == 0{
                                    if self.previousSkipCount != skipCount{
                                        self.previousSkipCount = skipCount
                                        self.foodOrderApiHitting(false, limit: LIMIT_COUNT, skip: skipCount)
                                    }
                                }
                            }
                        }
                    }
                default:
                    break
                }
            }else{
                switch selectionView.selectedIndex {
                case 0:
                    if self.dummyTableOrderModel.new.count == indexPath.row + 1{
                        if let tableModel = self.dummyTableOrderModel{
                            if let data = tableModel.new{
                                let checkingSkip = data.count % LIMIT_COUNT
                                let skipCount = data.count
                                if checkingSkip == 0{
                                    if self.previousSkipCount != skipCount{
                                        self.previousSkipCount = skipCount
                                        self.tableOrderApiHitting(false, limit: LIMIT_COUNT, skip: skipCount)
                                    }
                                }
                            }
                        }
                    }
                case 1:
                    if self.dummyTableOrderModel.scheduled.count == indexPath.row + 1{
                        if let tableModel = self.dummyTableOrderModel{
                            if let data = tableModel.scheduled{
                                let checkingSkip = data.count % LIMIT_COUNT
                                let skipCount = data.count
                                if checkingSkip == 0{
                                    if self.previousSkipCount != skipCount{
                                        self.previousSkipCount = skipCount
                                        self.tableOrderApiHitting(false, limit: LIMIT_COUNT, skip: skipCount)
                                    }
                                }
                            }
                        }
                    }
                case 2:
                    if self.dummyTableOrderModel.completed.count == indexPath.row + 1{
                        if let tableModel = self.dummyTableOrderModel{
                            if let data = tableModel.completed{
                                let checkingSkip = data.count % LIMIT_COUNT
                                let skipCount = data.count
                                if checkingSkip == 0{
                                    if self.previousSkipCount != skipCount{
                                        self.previousSkipCount = skipCount
                                        self.tableOrderApiHitting(false, limit: LIMIT_COUNT, skip: skipCount)
                                    }
                                }
                            }
                        }
                    }
                default:
                    break
                }
            }
        }
    }
}
//MARK : - UI CollectionView Delegate Methods
extension OrdersViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dummyFoodOrderModel == nil ? 0 :  self.dummyFoodOrderModel.new[collectionView.tag].items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewFoodItemsCell", for: indexPath as IndexPath) as! NewFoodItemsCell
        let data = self.dummyFoodOrderModel.new[collectionView.tag].items[indexPath.row]
        if data.vorousType! == 2{
            cell.foodImgView.image = #imageLiteral(resourceName: "NonVeg")
        }else{
              cell.foodImgView.image = #imageLiteral(resourceName: "Veg")
        }
       cell.itemsLbl.text = "✕\(data.quantity!.toString)"
       cell.nameLbl.text = data.name!
       cell.priceLbl.text = "₹ \(data.finalPrice!.toString)"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 20)
    }
}
//MARK:- From Manage
extension OrdersViewController{
    func returnManageNewFoodCell(_ tableView: UITableView,  indexPath: IndexPath) -> UITableViewCell?{
        if self.isFoodSelectedFlag{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewFoodCell") as! NewFoodCell
            cell.collectionView.tag = indexPath.row
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.reloadData()
            cell.acceptBtn.tag = indexPath.row
            cell.rejectBtn.tag = indexPath.row
            cell.acceptBtn.addTarget(self, action: #selector(self.acceptBtnMethod(_:)), for: .touchUpInside)
            cell.rejectBtn.addTarget(self, action: #selector(self.rejectBtnMethod(_:)), for: .touchUpInside)
            let data = self.dummyFoodOrderModel.new[indexPath.row]
            cell.orderIdLbl.text = "Order ID: \(data.order[0].subOrderId!)"
            if data.history != nil{
                if data.history.orderedAt != ""{
                    cell.dateLbl.text = TheGlobalPoolManager.convertDateFormaterForOnlyTime(data.history.orderedAt!)
                }else{
                    cell.dateLbl.text = ""
                }
            }else{
                cell.dateLbl.text = ""
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewTableCell") as! NewTableCell
            let data = self.dummyTableOrderModel.new[indexPath.row]
            cell.acceptBtn.tag = indexPath.row
            cell.rejectBtn.tag = indexPath.row
            cell.acceptBtn.addTarget(self, action: #selector(self.acceptBtnMethod(_:)), for: .touchUpInside)
            cell.rejectBtn.addTarget(self, action: #selector(self.rejectBtnMethod(_:)), for: .touchUpInside)
            cell.orderIDLbl.text = "Order ID: \(data.orderId!)"
            cell.dateLbl.text = data.bookedDate!
            cell.timeLbl.text = data.startTime!
            cell.personsLbl.text = data.personCount!.toString
            cell.nameLbl.text = data.contact.name!
            cell.emailLbl.text = data.contact.email!
            cell.callBtn.tag = indexPath.row
            cell.callBtn.addTarget(self, action: #selector(callButtonMethod(_:)), for: .touchUpInside)
            return cell
        }
    }
    func returnManageScheduledCell(_ tableView: UITableView,  indexPath: IndexPath) -> UITableViewCell?{
        if self.isFoodSelectedFlag{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleFoodCell") as! ScheduleFoodCell
            cell.statusLbl.isHidden =  true
            let data = self.dummyFoodOrderModel.scheduled[indexPath.row]
            cell.orderLbl.text = "Order ID: \(data.order[0].subOrderId!)"
            cell.noOfItemsLbl.text = "No of Items : \(data.items.count.toString)"
            cell.totalCostLbl.text = "Total Cost: ₹ \(data.order[0].billing.orderTotal!.toString)"
            if data.history != nil{
                if data.history.orderedAt != ""{
                    cell.dateLbl.text = TheGlobalPoolManager.convertDateFormaterForOnlyTime(data.history.orderedAt!)
                }else{
                    cell.dateLbl.text = ""
                }
            }else{
                cell.dateLbl.text = ""
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduledTableCell") as! ScheduledTableCell
            let data = self.dummyTableOrderModel.scheduled[indexPath.row]
            cell.orderIDLbl.text = "Order ID: \(data.orderId!)"
            cell.dateLbl.text = data.bookedDate!
            cell.timeLbl.text = data.startTime!
            cell.personsLbl.text = data.personCount!.toString
            cell.nameLbl.text = data.contact.name!
            cell.emailLbl.text = data.contact.email!
            cell.callBtn.tag = indexPath.row
            cell.callBtn.addTarget(self, action: #selector(callButtonMethod(_:)), for: .touchUpInside)
            return cell
        }
    }
    func returnManageCompletedCell(_ tableView: UITableView,  indexPath: IndexPath) -> UITableViewCell?{
        if self.isFoodSelectedFlag{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleFoodCell") as! ScheduleFoodCell
            cell.statusLbl.isHidden =  false
            let data = self.dummyFoodOrderModel.completed[indexPath.row]
            cell.orderLbl.text = "Order ID: \(data.order[0].subOrderId!)"
            cell.noOfItemsLbl.text = "No of Items : \(data.items.count.toString)"
            cell.totalCostLbl.text = "Total Cost: ₹ \(data.order[0].billing.orderTotal!.toString)"
            let status = GlobalClass.returnStatus(data.order[0].status!)
            cell.statusLbl.text = status.0
            cell.statusLbl.backgroundColor = status.1
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedTableCell") as! CompletedTableCell
            let data = self.dummyTableOrderModel.completed[indexPath.row]
            cell.orderIDLbl.text = "Order ID: \(data.orderId!)"
            cell.dateLbl.text = data.bookedDate!
            cell.timeLbl.text = data.startTime!
            cell.personsLbl.text = data.personCount!.toString
            cell.nameLbl.text = data.contact.name!
            let status = GlobalClass.returnTableStatus(data.status!)
            cell.redeemedStatusLbl.text = status.0
            cell.redeemedStatusLbl.textColor = status.1
            return cell
        }
    }
}
extension OrdersViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.searchActive = true
        self.clearBtn.image = #imageLiteral(resourceName: "Cancelled").withColor(.greyColor)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !self.searchActive || (textField.text?.isEmpty)!{
            self.clearBtn.image = #imageLiteral(resourceName: "Search")
            self.dummyFoodOrderModel = GlobalClass.foodOrderModel
            self.dummyTableOrderModel = GlobalClass.tableOrderModel
            self.tableView.reloadData()
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var searchString = (textField.text?.isEmpty)! ? "" : textField.text!
        if range.length == 1{
            searchString = (searchString as NSString).replacingCharacters(in: range, with: "")
        }else{
            searchString = searchString+string
        }
        if searchString.length > 0{
            switch self.selectionView.selectedIndex{
            case 0 :
                if self.isFoodSelectedFlag && GlobalClass.foodOrderModel != nil {
                    self.dummyFoodOrderModel.new = GlobalClass.foodOrderModel.new.filter({ (data) -> Bool in
                        return data.orderId.contains(searchString, compareOption: .caseInsensitive)
                    })
                }else if GlobalClass.tableOrderModel != nil {
                    self.dummyTableOrderModel.new = GlobalClass.tableOrderModel.new.filter({ (data) -> Bool in
                        return data.orderId.contains(searchString, compareOption: .caseInsensitive)
                    })
                }
            case 1 :
                if self.isFoodSelectedFlag && GlobalClass.foodOrderModel != nil {
                    self.dummyFoodOrderModel.scheduled = GlobalClass.foodOrderModel.scheduled.filter({ (data) -> Bool in
                        return data.orderId.contains(searchString, compareOption: .caseInsensitive)
                    })
                }else if GlobalClass.tableOrderModel != nil {
                    self.dummyTableOrderModel.scheduled = GlobalClass.tableOrderModel.scheduled.filter({ (data) -> Bool in
                        return data.orderId.contains(searchString, compareOption: .caseInsensitive)
                    })
                }
            case 2 :
                if self.isFoodSelectedFlag && GlobalClass.foodOrderModel != nil {
                    self.dummyFoodOrderModel.completed = GlobalClass.foodOrderModel.completed.filter({ (data) -> Bool in
                        return data.orderId.contains(searchString, compareOption: .caseInsensitive)
                    })
                }else if GlobalClass.tableOrderModel != nil {
                    self.dummyTableOrderModel.completed = GlobalClass.tableOrderModel.completed.filter({ (data) -> Bool in
                        return data.orderId.contains(searchString, compareOption: .caseInsensitive)
                    })
                }
            default :
                break
            }
        }else{
            self.dummyFoodOrderModel = GlobalClass.foodOrderModel
            self.dummyTableOrderModel = GlobalClass.tableOrderModel
        }
        self.tableView.reloadData()
        return true
    }
}



