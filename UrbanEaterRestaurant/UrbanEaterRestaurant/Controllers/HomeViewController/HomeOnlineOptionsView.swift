//
//  HomeOnlineOptionsView.swift
//  UrbanEaterRestaurant
//
//  Created by Vamsi on 03/12/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import UIKit
import SwiftyJSON
import EZSwiftExtensions

let LIMIT_COUNT = 25
var SKIP_COUNT  = 0

class HomeOnlineOptionsView: UIViewController {
    @IBOutlet weak var selectionView: MXSegmentedControl!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBgView: UIView!
    @IBOutlet weak var clearBtn: UIImageView!
    @IBOutlet weak var newCountLbl: UILabel!
    
    var isFromHome:Bool = false
    var settings = [Any]()
    var searchActive = false
    var dummyRestaurantAllOrdersModel : RestaurantAllOrdersModel!
    var newDummy : RestaurantAllOrdersModel!
    var previousSkipCount = 0
    var skipCountCheck    = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "NewFoodCell", bundle: nil), forCellReuseIdentifier: "NewFoodCell")
        tableView.register(UINib(nibName: "NewTableCell", bundle: nil), forCellReuseIdentifier: "NewTableCell")
        tableView.register(UINib(nibName: "ScheduleFoodCell", bundle: nil), forCellReuseIdentifier: "ScheduleFoodCell")
        tableView.register(UINib(nibName: "ScheduledTableCell", bundle: nil), forCellReuseIdentifier: "ScheduledTableCell")
        tableView.register(UINib(nibName: "CompletedTableCell", bundle: nil), forCellReuseIdentifier: "CompletedTableCell")
        self.updateUI()
        self.clearBtn.addTapGesture(tapNumber: 1, target: self, action: #selector(self.clearBtnPressed(_:)))
        if self.isFromHome{}
        NotificationCenter.default.addObserver(self, selector: #selector(HomeOnlineOptionsView.methodOfReceivedNotification(notification:)), name: Notification.Name("DoneButtonClicked"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeOnlineOptionsView.methodOfReceivedNotification1(notification:)), name: Notification.Name("FoodAccepted"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(HomeOnlineOptionsView.methodOfReceivedNotification2(_:)), name: Notification.Name("OrderReceived"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(self.socketConnectionConnected(_:)), name: NSNotification.Name(SOCKET_CONNECTED), object: nil)
        ez.runThisInMainThread {
            Sockets.socketListenForTrackingOrderStatus(completionHandler: { (data) in
            })
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.selectionView.select(index: 0, animated: true)
    }
    @objc func methodOfReceivedNotification(notification: Notification){
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationSlideTopTop)
        self.restaurantAllOrdersApiHitting(true, limit: LIMIT_COUNT , skip: SKIP_COUNT)
    }
    @objc func methodOfReceivedNotification1(notification: Notification){
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationSlideTopTop)
        self.restaurantAllOrdersApiHitting(true, limit: LIMIT_COUNT , skip: SKIP_COUNT)
        if GlobalClass.restaurantAllOrdersModel != nil{
            if GlobalClass.restaurantAllOrdersModel.new.count == 0{
                // Need to write logic....
            }
        }
    }
    @objc func methodOfReceivedNotification2(_ userInfo:Notification){
        if let dic = userInfo.userInfo as? [String:AnyObject]{
            if let orderId = dic[ORDER_ID] as? String{
                if TheGlobalPoolManager.currentOrderID != orderId{
                    TheGlobalPoolManager.currentOrderID = orderId
                    ez.runThisInMainThread {
                        self.selectionView.select(index: 0, animated: true)
                    }
                }
            }
        }
    }
    //MARK:- Socket Connected
    @objc func socketConnectionConnected(_ userInfo:Notification){
        if  GlobalClass.restaurantAllOrdersModel == nil{
            ez.runThisInMainThread {
                self.selectionView.select(index: 0, animated: true)
            }
        }
    }
    @objc func clearBtnPressed(_ sender: UITapGestureRecognizer) {
        if self.searchActive || self.clearBtn.image == #imageLiteral(resourceName: "Cancelled").withColor(.greyColor){
            self.clearBtn.image = #imageLiteral(resourceName: "Search")
            self.searchActive = false
            self.searchTF.endEditing(true)
            self.searchTF.text = ""
            self.restaurantAllOrdersApiHitting(true, limit: LIMIT_COUNT , skip: SKIP_COUNT)
        }
    }
    //MARK:- Update UI
    func updateUI(){
        ez.runThisInMainThread {
            self.newCountLbl.isHidden = true
            TheGlobalPoolManager.cornerAndBorder(self.newCountLbl, cornerRadius: self.newCountLbl.bounds.h / 2, borderWidth: 0, borderColor: .clear)
            self.searchBgView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35 ,cornerRadius : self.searchBgView.layer.bounds.h / 2)
        }
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
            self.restaurantAllOrdersApiHitting(false, limit: LIMIT_COUNT , skip: SKIP_COUNT)
            break
        case 1:
            // Scheduled ....
            self.previousSkipCount = 0
            self.skipCountCheck = 0
           self.restaurantAllOrdersApiHitting(false, limit: LIMIT_COUNT , skip: SKIP_COUNT)
            break
        case 2:
            // Completed ....
            self.previousSkipCount = 0
            self.skipCountCheck = 0
           self.restaurantAllOrdersApiHitting(false, limit: LIMIT_COUNT , skip: SKIP_COUNT)
            break
        default:
            break
        }
    }
    //MARK:- Restaurant All Orders Api Hitting
    func restaurantAllOrdersApiHitting(_ hideToast:Bool ,limit:Int, skip:Int){
        print("Hitting Api with ============= \(skip)")
        if !hideToast{
            Themes.sharedInstance.activityView(View: self.view)
        }
        
        var param = [String:AnyObject]()
        param = [RES_ID: GlobalClass.restaurantLoginModel.data.subId!,
                          ORDER_FOOD: 1,
                          ORDER_TABLE: 1] as [String : AnyObject]
        
        switch selectionView.selectedIndex {
        case 0:
            param[ORDER_STATUS] =  ORDERED as AnyObject
            param[ORDER_STATUS] =  ORDERED as AnyObject
        case 1:
            param[ORDER_STATUS] =  RES_ON_GOING as AnyObject
            param[ORDER_STATUS] =  RES_ON_GOING as AnyObject
        case 2:
            param[ORDER_STATUS] =  RES_COMPLETED as AnyObject
            param[ORDER_STATUS] =  RES_COMPLETED as AnyObject
        default:
            break
        }
        
        ez.runThisAfterDelay(seconds: 0.0, after: {
            let paramSent = [DATA:param,FILTER : [LIMIT:limit,SKIP:skip]] as [String : AnyObject]
            print("paramSent",paramSent)
            Sockets.socketWithName(GET_RESTAURANT_ORDERS, input: paramSent, completionHandler: { (response) in
                Themes.sharedInstance.removeActivityView(View: self.view)
                 let data = JSON(response)
                let restModel = RestaurantAllOrdersModel(fromJson: data)
                if GlobalClass.restaurantAllOrdersModel != nil && self.selectionView.selectedIndex != 0{
                    if restModel.new.count > GlobalClass.restaurantAllOrdersModel.new.count{
                        self.newCountLbl.isHidden = false
                        self.newCountLbl.text = "\(restModel.new.count - GlobalClass.restaurantAllOrdersModel.new.count)"
                    }else{
                        self.newCountLbl.isHidden = true
                    }
                }
                if !self.searchActive{
                    if skip == 0{
                        GlobalClass.restaurantAllOrdersModel = restModel
                        self.dummyRestaurantAllOrdersModel = GlobalClass.restaurantAllOrdersModel
                        self.newDummy = GlobalClass.restaurantAllOrdersModel
                    }else{
                        GlobalClass.restaurantAllOrdersModel.data.append(contentsOf: restModel.data!)
                        GlobalClass.restaurantAllOrdersModel.new.append(contentsOf: restModel.new!)
                        GlobalClass.restaurantAllOrdersModel.scheduled.append(contentsOf: restModel.scheduled!)
                        GlobalClass.restaurantAllOrdersModel.completed.append(contentsOf: restModel.completed!)
                        if let dataModel = GlobalClass.restaurantAllOrdersModel{
                            self.dummyRestaurantAllOrdersModel = dataModel
                            self.newDummy = dataModel
                        }
                    }
                }
                if GlobalClass.restaurantAllOrdersModel.data.count == 0{
                    self.tableView.reloadData()
                    //TheGlobalPoolManager.showToastView("No Orders available now")
                }else{
                    self.tableView.reloadData()
                }
            })
        })
    }
    //MARK:- Food Order Update  Request
    func foodOrderUpdateRequestApiHitting(_ orderId : String , resID : String , status : String){
        Themes.sharedInstance.activityView(View: self.view)
        let param =  [ID: orderId,
                                RES_ID: [resID],
                                STATUS: status] as [String : Any]
        let header = [X_SESSION_ID : GlobalClass.restaurantLoginModel.data.sessionId!]
        URLhandler.postUrlSession(urlString: Constants.urls.FoodOrderUpdateReqURL, params: param as [String : AnyObject], header: header) { (dataResponse) in
            if dataResponse.json.exists(){
                ez.runThisInMainThread {
                    self.restaurantAllOrdersApiHitting(true, limit: LIMIT_COUNT , skip: SKIP_COUNT)
                }
            }
        }
    }
    //MARK:- Table Order Update  Request
    func tableOrderUpdateRequestApiHitting(_ orderId : String , resID : String , status : String){
        Themes.sharedInstance.activityView(View: self.view)
        let param =  [ID: orderId,
                                RES_ID: resID,
                                STATUS: status]
        let header = [X_SESSION_ID : GlobalClass.restaurantLoginModel.data.sessionId!]
        URLhandler.postUrlSession(urlString: Constants.urls.TableOrderUpdatetReqURL, params: param as [String : AnyObject], header: header) { (dataResponse) in
            if dataResponse.json.exists(){
                ez.runThisInMainThread {
                    self.restaurantAllOrdersApiHitting(true, limit: LIMIT_COUNT , skip: SKIP_COUNT)
                }
            }
        }
    }
    //MARK: - Items Detsils Pop Up
    func itemsDetailsPopUpView(_ schedule:RestaurantAllOrdersData){
        let viewCon = ItemsDetailView(nibName: "ItemsDetailView", bundle: nil)
        viewCon.scheduledFromHome = schedule
        viewCon.isComingFromHome = true
        self.presentPopupViewController(viewCon, animationType: MJPopupViewAnimationSlideTopTop)
    }
    //MARK: - Completed Items Detsils Pop Up
    func completdItemsDetailsPopUpView(_ schedule:RestaurantAllOrdersData){
        let viewCon = CompletedItemsPopUp(nibName: "CompletedItemsPopUp", bundle: nil)
        viewCon.scheduledFromHome = schedule
        viewCon.isComingFromHome = true
        self.presentPopupViewController(viewCon, animationType: MJPopupViewAnimationSlideTopTop)
    }
    //MARK: - Manage Preparation Time Pop Up
    func managePreparationTimePopUpView(_ orderID : String){
        let viewCon = PreparationTimeView(nibName: "PreparationTimeView", bundle: nil)
        viewCon.isComingFromHome = true
        viewCon.orderID = orderID
        self.presentPopupViewController(viewCon, animationType: MJPopupViewAnimationSlideTopTop)
    }
    //MARK: - Table Reedemed Pop Up
    func tableReedeemedPopUpView(_ schedule:RestaurantAllOrdersData){
        let viewCon = TableAcceptedView(nibName: "TableAcceptedView", bundle: nil)
        viewCon.scheduledFromHome = schedule
        viewCon.isComingFromHome = true
        self.presentPopupViewController(viewCon, animationType: MJPopupViewAnimationSlideTopTop)
    }
    //MARK:- Accept Button method
    @objc func acceptBtnMethod(_ btn : UIButton){
        let data = self.dummyRestaurantAllOrdersModel.new[btn.tag]
        if !data.isOrderTable{
            self.managePreparationTimePopUpView(data.id!)
        }else{
            TheGlobalPoolManager.showAlertWith(title: "Are you sure", message: "Do you want to Accept?", singleAction: false, okTitle:"Confirm") { (sucess) in
                if sucess!{
                    self.tableOrderUpdateRequestApiHitting(data.id!, resID: GlobalClass.restaurantLoginModel.data.subId!, status: GlobalClass.KEY_ACCEPTED)
                }
            }
        }
    }
    //MARK:- Reject Button method
    @objc func rejectBtnMethod(_ btn : UIButton){
        let data = self.dummyRestaurantAllOrdersModel.new[btn.tag]
        if !data.isOrderTable{
            TheGlobalPoolManager.showAlertWith(title: "Are you sure", message: "Do you want to Reject this Order?", singleAction: false, okTitle:"Confirm") { (sucess) in
                if sucess!{
                    self.foodOrderUpdateRequestApiHitting(data.id!, resID: GlobalClass.restaurantLoginModel.data.subId!, status: GlobalClass.KEY_REJECTED)
                }
            }
        }else{
            TheGlobalPoolManager.showAlertWith(title: "Are you sure", message: "Do you want to Reject?", singleAction: false, okTitle:"Confirm") { (sucess) in
                if sucess!{
                    self.tableOrderUpdateRequestApiHitting(data.id!, resID: GlobalClass.restaurantLoginModel.data.subId!, status: GlobalClass.KEY_REJECTED)
                }
            }
        }
    }
}
//MARK : - UI Table View Delegate Methods
extension HomeOnlineOptionsView : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectionView.selectedIndex == 0{
            return self.dummyRestaurantAllOrdersModel == nil ? 0 : self.dummyRestaurantAllOrdersModel.new.count
        }else if selectionView.selectedIndex == 1{
            return self.dummyRestaurantAllOrdersModel == nil ? 0 : self.dummyRestaurantAllOrdersModel.scheduled.count
        }else{
            return self.dummyRestaurantAllOrdersModel == nil ? 0 : self.dummyRestaurantAllOrdersModel.completed.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectionView.selectedIndex == 0{
            return self.returnHomeNewFoodCell(tableView, indexPath: indexPath)!
        }else if selectionView.selectedIndex == 1{
            return self.returnHomeScheduledCell(tableView, indexPath: indexPath)!
        }else{
            return self.returnHomeCompletedCell(tableView, indexPath: indexPath)!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectionView.selectedIndex == 1{
            let data = self.dummyRestaurantAllOrdersModel.scheduled[indexPath.row]
            if !data.isOrderTable{
                let schedule = self.dummyRestaurantAllOrdersModel.scheduled[indexPath.row]
                self.itemsDetailsPopUpView(schedule)
            }else{
                let schedule = self.dummyRestaurantAllOrdersModel.scheduled[indexPath.row]
                self.tableReedeemedPopUpView(schedule)
            }
        }else if selectionView.selectedIndex == 2{
            let data = self.dummyRestaurantAllOrdersModel.completed[indexPath.row]
            if !data.isOrderTable{
                let schedule = self.dummyRestaurantAllOrdersModel.completed[indexPath.row]
                self.completdItemsDetailsPopUpView(schedule)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch selectionView.selectedIndex {
        case 0:
            let data = self.dummyRestaurantAllOrdersModel.new[indexPath.row]
            if !data.isOrderTable{
                if data.items.count > 3{
                    return UIDevice.isPhone() ? CGFloat(135 + Int(data.items.count * 30)) : CGFloat(155 + Int(data.items.count * 30))
                }
                return UIDevice.isPhone() ? 200 : 210
            }
            return UIDevice.isPhone() ? 160 : 220
        case 1:
            let data = self.dummyRestaurantAllOrdersModel.scheduled[indexPath.row]
            if !data.isOrderTable{
                return UIDevice.isPhone() ? 110 : 140
            }
            return UIDevice.isPhone() ? 110 : 140
        case 2:
            let data = self.dummyRestaurantAllOrdersModel.completed[indexPath.row]
            if !data.isOrderTable{
                return UIDevice.isPhone() ? 130 : 160
            }
            return UIDevice.isPhone() ? 130 : 160
        default:
            break
        }
        return 0
    }
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if !searchActive{
            switch selectionView.selectedIndex {
            case 0:
                if self.dummyRestaurantAllOrdersModel.new.count == indexPath.row + 1{
                    if let restModel = self.dummyRestaurantAllOrdersModel{
                        if let data = restModel.new{
                            let checkingSkip = data.count % LIMIT_COUNT
                            let skipCount = data.count
                            if checkingSkip == 0{
                                if self.previousSkipCount != skipCount{
                                    self.previousSkipCount = skipCount
                                    self.restaurantAllOrdersApiHitting(false, limit: LIMIT_COUNT , skip: skipCount)
                                }
                            }
                        }
                    }
                }
            case 1:
                if self.dummyRestaurantAllOrdersModel.scheduled.count == indexPath.row + 1{
                    if let restModel = self.dummyRestaurantAllOrdersModel{
                        if let data = restModel.scheduled{
                            let checkingSkip = data.count % LIMIT_COUNT
                            let skipCount = data.count
                            if checkingSkip == 0{
                                if self.previousSkipCount != skipCount{
                                    self.previousSkipCount = skipCount
                                    self.restaurantAllOrdersApiHitting(false, limit: LIMIT_COUNT , skip: skipCount)
                                }
                            }
                        }
                    }
                }
            case 2:
                if self.dummyRestaurantAllOrdersModel.completed.count == indexPath.row + 1{
                    if let restModel = self.dummyRestaurantAllOrdersModel{
                        if let data = restModel.completed{
                            let checkingSkip = data.count % LIMIT_COUNT
                            let skipCount = data.count
                            if checkingSkip == 0{
                                if self.previousSkipCount != skipCount{
                                    self.previousSkipCount = skipCount
                                    self.restaurantAllOrdersApiHitting(false, limit: LIMIT_COUNT , skip: skipCount)
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
//MARK : - UI CollectionView Delegate Methods
extension HomeOnlineOptionsView : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dummyRestaurantAllOrdersModel == nil ? 0 :  self.dummyRestaurantAllOrdersModel.new[collectionView.tag].items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewFoodItemsCell", for: indexPath as IndexPath) as! NewFoodItemsCell
        let data = self.dummyRestaurantAllOrdersModel.new[collectionView.tag].items[indexPath.row]
        if data.vorousType! == 2 {
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
//MARK:- From Home
extension HomeOnlineOptionsView{
    func returnHomeNewFoodCell(_ tableView: UITableView,  indexPath: IndexPath) -> UITableViewCell?{
        let data = self.dummyRestaurantAllOrdersModel.new[indexPath.row]
        if !data.isOrderTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewFoodCell") as! NewFoodCell
            cell.acceptBtn.tag = indexPath.row
            cell.rejectBtn.tag = indexPath.row
            cell.acceptBtn.addTarget(self, action: #selector(self.acceptBtnMethod(_:)), for: .touchUpInside)
            cell.rejectBtn.addTarget(self, action: #selector(self.rejectBtnMethod(_:)), for: .touchUpInside)
            cell.collectionView.tag = indexPath.row
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.reloadData()
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
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewTableCell") as! NewTableCell
        cell.detailsView.isHidden = true
        cell.acceptBtn.tag = indexPath.row
        cell.rejectBtn.tag = indexPath.row
        cell.acceptBtn.addTarget(self, action: #selector(self.acceptBtnMethod(_:)), for: .touchUpInside)
        cell.rejectBtn.addTarget(self, action: #selector(self.rejectBtnMethod(_:)), for: .touchUpInside)
        cell.orderIDLbl.text = "Order ID: \(data.orderId!)"
        cell.dateLbl.text = data.bookedDate!
        cell.timeLbl.text = data.startTime!
        cell.personsLbl.text = data.personCount!.toString
        return cell
    }
    func returnHomeScheduledCell(_ tableView: UITableView,  indexPath: IndexPath) -> UITableViewCell?{
        let data = self.dummyRestaurantAllOrdersModel.scheduled[indexPath.row]
        if !data.isOrderTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleFoodCell") as! ScheduleFoodCell
            cell.statusLbl.isHidden = true
            cell.orderLbl.text = "Order ID: \(data.order[0].subOrderId!)"
            cell.noOfItemsLbl.text = "No of Items :  \(data.items.count.toString)"
            cell.totalCostLbl.text   = "Total Cost:  ₹ \(data.order[0].billing.orderTotal!.toString)"
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
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduledTableCell") as! ScheduledTableCell
        cell.detailsView.isHidden = true
        cell.underlineLbl.isHidden = true
        cell.orderIDLbl.text = "Order ID: \(data.orderId!)"
        cell.dateLbl.text = data.bookedDate!
        cell.timeLbl.text = data.startTime!
        cell.personsLbl.text = data.personCount!.toString
        return cell
    }
    func returnHomeCompletedCell(_ tableView: UITableView,  indexPath: IndexPath) -> UITableViewCell?{
        let data = self.dummyRestaurantAllOrdersModel.completed[indexPath.row]
        if !data.isOrderTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleFoodCell") as! ScheduleFoodCell
            cell.statusLbl.isHidden = false
            cell.orderLbl.text = "Order ID: \(data.order[0].subOrderId!)"
            cell.noOfItemsLbl.text = "No of Items :  \(data.items.count.toString)"
            cell.totalCostLbl.text = "Total Cost:  ₹ \(data.order[0].billing.orderTotal!.toString)"
            let status = GlobalClass.returnStatus(data.order[0].status!)
            cell.statusLbl.text = status.0
            cell.statusLbl.backgroundColor = status.1
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedTableCell") as! CompletedTableCell
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
extension UIView {
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float , cornerRadius : CGFloat) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.cornerRadius = cornerRadius
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}

extension HomeOnlineOptionsView : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.searchActive = true
        self.clearBtn.image = #imageLiteral(resourceName: "Cancelled").withColor(.greyColor)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !self.searchActive || (textField.text?.isEmpty)!{
            self.clearBtn.image = #imageLiteral(resourceName: "Search")
            self.dummyRestaurantAllOrdersModel = nil
            self.dummyRestaurantAllOrdersModel = GlobalClass.restaurantAllOrdersModel
            self.newDummy = GlobalClass.restaurantAllOrdersModel
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
        if GlobalClass.restaurantAllOrdersModel != nil && searchString.length > 0{
            switch self.selectionView.selectedIndex{
            case 0 :
                self.dummyRestaurantAllOrdersModel.new = self.newDummy.new.filter({ (data) -> Bool in
                    return data.orderId.contains(searchString, compareOption: .caseInsensitive)
                })
            case 1 :
                self.dummyRestaurantAllOrdersModel.scheduled = self.newDummy.scheduled.filter({ (data) -> Bool in
                    return data.orderId.contains(searchString, compareOption: .caseInsensitive)
                })
            case 2 :
                self.dummyRestaurantAllOrdersModel.completed = self.newDummy.completed.filter({ (data) -> Bool in
                    return data.orderId.contains(searchString, compareOption: .caseInsensitive)
                })
            default :
                break
            }
        }else{
            self.dummyRestaurantAllOrdersModel = nil
            self.dummyRestaurantAllOrdersModel = GlobalClass.restaurantAllOrdersModel
            self.newDummy = GlobalClass.restaurantAllOrdersModel
        }
        self.tableView.reloadData()
        return true
    }
}

