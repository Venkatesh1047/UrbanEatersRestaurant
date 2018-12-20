//
//  NewOrdersViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 24/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit
//import HTHorizontalSelectionList
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
    var searchActive = false
    var dummyFoodOrderModel : FoodOrderModel!
    var dummyTableOrderModel : TableOrderModel!
    var settings = [Any]()
    var isFoodSelectedFlag : Bool = false
    var selectedDate : String = ""
    var isScheduledTabSelected : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    @objc func clearBtnPressed(_ sender: UITapGestureRecognizer) {
        if self.searchActive || self.clearBtn.image == #imageLiteral(resourceName: "Cancelled").withColor(.greyColor){
            self.clearBtn.image = #imageLiteral(resourceName: "Search")
            self.searchActive = false
            self.searchTF.endEditing(true)
            self.searchTF.text = ""
        }
    }
    //MARK: - Items Detsils Pop Up
    func itemsDetailsPopUpView(_ schedule:FoodOrderModelData){
        let viewCon = ItemsDetailView(nibName: "ItemsDetailView", bundle: nil)
        viewCon.schedule = schedule
        self.presentPopupViewController(viewCon, animationType: MJPopupViewAnimationSlideTopTop)
    }
    @IBAction func backBtn(_ sender: UIButton) {
        ez.topMostVC?.popVC()
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
        if isScheduledTabSelected {
            self.selectionView.select(index: 1, animated: true)
            self.selectedSegment(self.selectionView)
        }
        self.foodOrderApiHitting(false)
        self.tableOrderApiHitting(false)
        ez.runThisEvery(seconds: 5.0, startAfterSeconds: 5.0) { (timer) in
            self.foodOrderApiHitting(true)
            self.tableOrderApiHitting(true)
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
    //MARK:- Food Order Api Hitting
    func foodOrderApiHitting(_ hideToast:Bool){
        if !hideToast{
            Themes.sharedInstance.activityView(View: self.view)
        }
        let param = ["restaurantId": [GlobalClass.restaurantLoginModel.data.subId!]]
        URLhandler.postUrlSession(hideToast, urlString: Constants.urls.getFoodOrdersURL, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                GlobalClass.foodOrderModel = FoodOrderModel(fromJson: dataResponse.json)
                self.dummyFoodOrderModel = GlobalClass.foodOrderModel
                if GlobalClass.foodOrderModel.data.count == 0{
                    TheGlobalPoolManager.showToastView("No data available")
                    self.tableView.reloadData()
                }else{
                    self.tableView.reloadData()
                }
            }
        }
    }
    //MARK:- Table Order Api Hitting
    func tableOrderApiHitting(_ hideToast:Bool){
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
        URLhandler.postUrlSession(hideToast, urlString: Constants.urls.getTableOrdersURL, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                GlobalClass.tableOrderModel = TableOrderModel(fromJson: dataResponse.json)
                self.dummyTableOrderModel = GlobalClass.tableOrderModel
                if GlobalClass.tableOrderModel.data.count == 0{
                    TheGlobalPoolManager.showToastView("No data available")
                    self.tableView.reloadData()
                }else{
                    self.tableView.reloadData()
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
            self.tableView.reloadData()
        }else{
            self.isFoodSelectedFlag = false
            self.tableView.reloadData()
        }
    }
}
//MARK : - UI Table View Delegate Methods
extension OrdersViewController : UITableViewDelegate,UITableViewDataSource{
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
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch selectionView.selectedIndex {
        case 0:
            if self.isFoodSelectedFlag{
                return 200
            }else{
                return 200
            }
        case 1:
            if self.isFoodSelectedFlag{
                return 100
            }else{
                return 150
            }
        case 2:
            if self.isFoodSelectedFlag{
                return 100
            }else{
                return 130
            }
        default:
            break
        }
        return 0
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
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected Index >>>>>>>",indexPath.row)
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
            let data = self.dummyFoodOrderModel.new[indexPath.row]
            cell.orderIdLbl.text = "Order ID: \(data.order[0].subOrderId!)"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewTableCell") as! NewTableCell
            let data = self.dummyTableOrderModel.new[indexPath.row]
            cell.orderIDLbl.text = "Order ID: \(data.orderId!)"
            cell.dateLbl.text = data.bookedDate!
            cell.timeLbl.text = data.startTime!
            cell.personsLbl.text = data.personCount!.toString
            cell.nameLbl.text = data.contact.name!
            cell.emailLbl.text = data.contact.email!
            return cell
        }
    }
    func returnManageScheduledCell(_ tableView: UITableView,  indexPath: IndexPath) -> UITableViewCell?{
        if self.isFoodSelectedFlag{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleFoodCell") as! ScheduleFoodCell
            cell.statusLbl.isHidden =  true
            let data = self.dummyFoodOrderModel.scheduled[indexPath.row]
            cell.orderLbl.text = "Order ID: \(data.order[0].subOrderId!)"
            cell.noOfItemsLbl.text = data.items.count.toString
            cell.totalCostLbl.text = "₹ \(data.order[0].billing.orderTotal!.toString)"
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
            return cell
        }
    }
    func returnManageCompletedCell(_ tableView: UITableView,  indexPath: IndexPath) -> UITableViewCell?{
        if self.isFoodSelectedFlag{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleFoodCell") as! ScheduleFoodCell
            cell.statusLbl.isHidden =  false
            let data = self.dummyFoodOrderModel.completed[indexPath.row]
            cell.orderLbl.text = "Order ID: \(data.order[0].subOrderId!)"
            cell.noOfItemsLbl.text = data.items.count.toString
            cell.totalCostLbl.text = "₹ \(data.order[0].billing.orderTotal!.toString)"
            cell.statusLbl.text = data.order[0].statusText!
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedTableCell") as! CompletedTableCell
            let data = self.dummyTableOrderModel.completed[indexPath.row]
            cell.orderIDLbl.text = "Order ID: \(data.orderId!)"
            cell.dateLbl.text = data.bookedDate!
            cell.timeLbl.text = data.startTime!
            cell.personsLbl.text = data.personCount!.toString
            cell.nameLbl.text = data.contact.name!
            cell.redeemedStatusLbl.text = data.statusText!
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



