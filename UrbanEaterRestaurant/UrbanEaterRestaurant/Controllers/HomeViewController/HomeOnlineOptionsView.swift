//
//  HomeOnlineOptionsView.swift
//  UrbanEaterRestaurant
//
//  Created by Vamsi on 03/12/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import UIKit
//import HTHorizontalSelectionList
import EZSwiftExtensions

class HomeOnlineOptionsView: UIViewController {
    @IBOutlet weak var selectionView: MXSegmentedControl!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBgView: UIView!
    @IBOutlet weak var clearBtn: UIImageView!
    var isFromHome:Bool = false
    var settings = [Any]()
    var searchActive = false
    var dummyRestaurantAllOrdersModel : RestaurantAllOrdersModel!
    var newDummy : RestaurantAllOrdersModel!
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
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    @objc func clearBtnPressed(_ sender: UITapGestureRecognizer) {
        if self.searchActive || self.clearBtn.image == #imageLiteral(resourceName: "Cancelled").withColor(.greyColor){
            self.clearBtn.image = #imageLiteral(resourceName: "Search")
            self.searchActive = false
            self.searchTF.endEditing(true)
            self.searchTF.text = ""
        }
    }
    //MARK:- Update UI
    func updateUI(){
        self.searchBgView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35 ,cornerRadius : self.searchBgView.layer.bounds.h / 2)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        self.searchTF.delegate = self
        //Selection view...............
        selectionView.backgroundColor = .secondaryBGColor
        selectionView.font = UIFont.appFont(.Medium, size: 16)
        selectionView.append(title: "New")
            .set(title: .secondaryBGColor, for: .selected).set(title: .whiteColor, for: .normal)
        selectionView.append(title: "Scheduled")
            .set(title: .secondaryBGColor, for: .selected).set(title: .whiteColor, for: .normal)
        selectionView.append(title: "Completed")
            .set(title: .secondaryBGColor, for: .selected).set(title: .whiteColor, for: .normal)
        selectionView.addTarget(self, action: #selector(self.selectedSegment(_:)), for: .valueChanged)
        self.restaurantAllOrdersApiHitting(false)
        ez.runThisEvery(seconds: 5.0, startAfterSeconds: 5.0) { (timer) in
            self.restaurantAllOrdersApiHitting(true)
        }
    }
    //MARK:- SelectionView
    @objc func selectedSegment(_ sender:MXSegmentedControl){
        switch sender.selectedIndex {
        case 0:
            // New ....
            tableView.reloadData()
            break
        case 1:
            // Scheduled ....
            tableView.reloadData()
            break
        case 2:
            // Completed ....
            tableView.reloadData()
            break
        default:
            break
        }
    }
    //MARK:- Restaurant All Orders Api Hitting
    func restaurantAllOrdersApiHitting(_ hideToast:Bool){
        if !hideToast{
            Themes.sharedInstance.activityView(View: self.view)
        }
        let param = ["restaurantId": GlobalClass.restaurantLoginModel.data.subId!,
                               "orderFood": 1,
                               "orderFoodStatus": "",
                               "orderTable": 1,
                               "orderTableStatus": ""] as [String : Any]
        URLhandler.postUrlSession(hideToast, urlString: Constants.urls.restaurantAllOrdersURL, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                GlobalClass.restaurantAllOrdersModel = RestaurantAllOrdersModel(fromJson: dataResponse.json)
                if !self.searchActive{
                    self.dummyRestaurantAllOrdersModel = GlobalClass.restaurantAllOrdersModel
                    self.newDummy = GlobalClass.restaurantAllOrdersModel
                }
                self.tableView.reloadData()
            }
        }
    }
    //MARK:- Food Order Update  Request
    func foodOrderUpdateRequestApiHitting(_ orderId : String , resID : String , status : String){
        Themes.sharedInstance.activityView(View: self.view)
        let param = ["id": orderId,
                                "restaurantId": [resID],
                                "status": status] as [String : Any]
        URLhandler.postUrlSession(urlString: Constants.urls.FoodOrderUpdateReqURL, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            if dataResponse.json.exists(){
                ez.runThisInMainThread {
                    self.restaurantAllOrdersApiHitting(true)
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
        URLhandler.postUrlSession(urlString: Constants.urls.TableOrderUpdatetReqURL, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            if dataResponse.json.exists(){
                ez.runThisInMainThread {
                    self.restaurantAllOrdersApiHitting(true)
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
    //MARK:- Accept Button method
    @objc func acceptBtnMethod(_ btn : UIButton){
        let data = self.dummyRestaurantAllOrdersModel.new[btn.tag]
        if !data.isOrderTable{
            self.foodOrderUpdateRequestApiHitting(data.id!, resID: GlobalClass.restaurantLoginModel.data.subId!, status: GlobalClass.KEY_ACCEPTED)
        }else{
            self.tableOrderUpdateRequestApiHitting(data.id!, resID: GlobalClass.restaurantLoginModel.data.subId!, status: GlobalClass.KEY_ACCEPTED)
        }
    }
    //MARK:- Reject Button method
    @objc func rejectBtnMethod(_ btn : UIButton){
        let data = self.dummyRestaurantAllOrdersModel.new[btn.tag]
        if !data.isOrderTable{
            self.foodOrderUpdateRequestApiHitting(data.id!, resID: GlobalClass.restaurantLoginModel.data.subId!, status: GlobalClass.KEY_REJECTED)
        }else{
            self.tableOrderUpdateRequestApiHitting(data.id!, resID: GlobalClass.restaurantLoginModel.data.subId!, status: GlobalClass.KEY_REJECTED)
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
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch selectionView.selectedIndex {
        case 0:
            let data = self.dummyRestaurantAllOrdersModel.new[indexPath.row]
            if !data.isOrderTable{
                return 200
            }
            return 160
        case 1:
            let data = self.dummyRestaurantAllOrdersModel.scheduled[indexPath.row]
            if !data.isOrderTable{
                return 110
            }
            return 110
        case 2:
            let data = self.dummyRestaurantAllOrdersModel.completed[indexPath.row]
            if !data.isOrderTable{
                return 110
            }
            return 130
        default:
            break
        }
        return 0
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
        if data.vorousType! == 2{
            cell.foodImgView.image = #imageLiteral(resourceName: "NonVeg")
        }else{
            cell.foodImgView.image = #imageLiteral(resourceName: "Veg")
        }
        cell.itemsLbl.text = "✕\(data.quantity!.toString)"
        cell.nameLbl.text = data.name!
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected Index >>>>>>>",indexPath.row)
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
            cell.orderIdLbl.text = "Order ID: \(data.order[0].subOrderId!)"
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
            cell.noOfItemsLbl.text = data.items.count.toString
            cell.totalCostLbl.text = data.order[0].billing.orderTotal!.toString
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
            cell.statusLbl.isHidden = true
            cell.orderLbl.text = "Order ID: \(data.order[0].subOrderId!)"
            cell.noOfItemsLbl.text = data.items.count.toString
            cell.totalCostLbl.text = "₹ \(data.order[0].billing.orderTotal!.toString)"
            cell.statusLbl.text = data.order[0].statusText!
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedTableCell") as! CompletedTableCell
        cell.orderIDLbl.text = "Order ID: \(data.orderId!)"
        cell.dateLbl.text = data.bookedDate!
        cell.timeLbl.text = data.startTime!
        cell.personsLbl.text = data.personCount!.toString
        cell.nameLbl.text = data.contact.name!
        cell.redeemedStatusLbl.text = data.statusText!
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
        layer.cornerRadius = layer.bounds.h / 2
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
                print(self.dummyRestaurantAllOrdersModel.scheduled.count, self.newDummy.scheduled.count, GlobalClass.restaurantAllOrdersModel.scheduled.count)
            case 2 :
                self.dummyRestaurantAllOrdersModel.completed = self.newDummy.completed.filter({ (data) -> Bool in
                    return data.orderId.contains(searchString, compareOption: .caseInsensitive)
                })
                print(self.dummyRestaurantAllOrdersModel.completed.count, self.newDummy.completed.count, GlobalClass.restaurantAllOrdersModel.completed.count)
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

