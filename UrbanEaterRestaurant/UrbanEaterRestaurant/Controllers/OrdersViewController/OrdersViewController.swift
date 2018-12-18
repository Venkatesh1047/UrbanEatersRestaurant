//
//  NewOrdersViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 24/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit
import HTHorizontalSelectionList
import EZSwiftExtensions

class OrdersViewController: UIViewController {

    @IBOutlet weak var foodBtn: UIButton!
    @IBOutlet weak var tableBtn: UIButton!
    @IBOutlet var manageBookingBtns: [UIButton]!
    @IBOutlet weak var selectionView: HTHorizontalSelectionList!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchBgView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    
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
        
        if isFoodSelectedFlag {
            self.manageBookingBtns(foodBtn)
        }else{
            self.manageBookingBtns(tableBtn)
        }
         self.updateUI()
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
        //Selection view...............
        selectionView.backgroundColor = .secondaryBGColor
        selectionView.selectionIndicatorAnimationMode = .heavyBounce
        selectionView.delegate = self
        selectionView.dataSource = self
        settings = ["New","Scheduled","Completed"]
        selectionView.centerButtons = true
        selectionView.selectionIndicatorColor = .themeColor
        selectionView.selectionIndicatorHeight = 3
        selectionView.evenlySpaceButtons = true
        selectionView.bottomTrimColor = .clear
        selectionView.setTitleColor(.whiteColor, for: .normal)
        selectionView.setTitleColor(.whiteColor, for: .selected)
        selectionView.setBGColor(.clear, for: .selected)
        selectionView.setTitleFont(.appFont(.Medium, size: 16), for: .normal)
        selectionView.setTitleFont(.appFont(.Medium, size: 16), for: .selected)
        selectionView.layer.masksToBounds = true
        if isScheduledTabSelected {
            self.selectionView.selectedButtonIndex = 1
        }
        self.foodOrderApiHitting()
        self.tableOrderApiHitting()
    }
    //MARK:- Food Order Api Hitting
    func foodOrderApiHitting(){
        Themes.sharedInstance.activityView(View: self.view)
        let param = ["restaurantId": [GlobalClass.restaurantLoginModel.data.subId!]]
        URLhandler.postUrlSession(urlString: Constants.urls.getFoodOrdersURL, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                GlobalClass.foodOrderModel = FoodOrderModel(fromJson: dataResponse.json)
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
    func tableOrderApiHitting(){
        Themes.sharedInstance.activityView(View: self.view)
        var param = [String : AnyObject]()
        if selectedDate == ""{
            param = ["restaurantId": GlobalClass.restaurantLoginModel.data.subId!] as [String : AnyObject]
        }else{
            param = ["restaurantId": GlobalClass.restaurantLoginModel.data.subId!,
                     "date" : selectedDate] as [String : AnyObject]
        }
        URLhandler.postUrlSession(urlString: Constants.urls.getTableOrdersURL, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                GlobalClass.tableOrderModel = TableOrderModel(fromJson: dataResponse.json)
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
//MARK : - HTHorizontalSelectionList Delegates
extension OrdersViewController : HTHorizontalSelectionListDelegate,HTHorizontalSelectionListDataSource{
    func numberOfItems(in selectionList: HTHorizontalSelectionList) -> Int {
        return settings.count
    }
    func selectionList(_ selectionList: HTHorizontalSelectionList, titleForItemWith index: Int) -> String? {
        return (settings[index] as! String)
    }
    func selectionList(_ selectionList: HTHorizontalSelectionList, didSelectButtonWith index: Int) {
        switch selectionView.selectedButtonIndex {
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
}
//MARK : - UI Table View Delegate Methods
extension OrdersViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFoodSelectedFlag{
            if selectionView.selectedButtonIndex == 0{
                return GlobalClass.foodOrderModel == nil ? 0 : GlobalClass.foodOrderModel.new.count
            }else if selectionView.selectedButtonIndex == 1{
                return GlobalClass.foodOrderModel == nil ? 0 : GlobalClass.foodOrderModel.scheduled.count
            }else{
                return GlobalClass.foodOrderModel == nil ? 0 : GlobalClass.foodOrderModel.completed.count
            }
        }else{
            if selectionView.selectedButtonIndex == 0{
                return GlobalClass.tableOrderModel == nil ? 0 : GlobalClass.tableOrderModel.new.count
            }else if selectionView.selectedButtonIndex == 1{
                return GlobalClass.tableOrderModel == nil ? 0 : GlobalClass.tableOrderModel.scheduled.count
            }else{
                return GlobalClass.tableOrderModel == nil ? 0 : GlobalClass.tableOrderModel.completed.count
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectionView.selectedButtonIndex == 0{
            return self.returnManageNewFoodCell(tableView, indexPath: indexPath)!
        }else if selectionView.selectedButtonIndex == 1{
            return self.returnManageScheduledCell(tableView, indexPath: indexPath)!
        }else{
            return self.returnManageCompletedCell(tableView, indexPath: indexPath)!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectionView.selectedButtonIndex == 1{
            if self.isFoodSelectedFlag{
                let schedule = GlobalClass.foodOrderModel.scheduled[indexPath.row]
                self.itemsDetailsPopUpView(schedule)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch selectionView.selectedButtonIndex {
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
        return GlobalClass.foodOrderModel == nil ? 0 :  GlobalClass.foodOrderModel.new[collectionView.tag].items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewFoodItemsCell", for: indexPath as IndexPath) as! NewFoodItemsCell
        let data = GlobalClass.foodOrderModel.new[collectionView.tag].items[indexPath.row]
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
            let data = GlobalClass.foodOrderModel.new[indexPath.row]
            cell.orderIdLbl.text = "Order ID: \(data.order[0].subOrderId!)"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewTableCell") as! NewTableCell
            let data = GlobalClass.tableOrderModel.new[indexPath.row]
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
            let data = GlobalClass.foodOrderModel.scheduled[indexPath.row]
            cell.orderLbl.text = "Order ID: \(data.order[0].subOrderId!)"
            cell.noOfItemsLbl.text = data.items.count.toString
            cell.totalCostLbl.text = "₹ \(data.order[0].billing.orderTotal!.toString)"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduledTableCell") as! ScheduledTableCell
            let data = GlobalClass.tableOrderModel.scheduled[indexPath.row]
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
            let data = GlobalClass.foodOrderModel.completed[indexPath.row]
            cell.orderLbl.text = "Order ID: \(data.order[0].subOrderId!)"
            cell.noOfItemsLbl.text = data.items.count.toString
            cell.totalCostLbl.text = "₹ \(data.order[0].billing.orderTotal!.toString)"
            cell.statusLbl.text = data.order[0].statusText!
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedTableCell") as! CompletedTableCell
            let data = GlobalClass.tableOrderModel.completed[indexPath.row]
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



