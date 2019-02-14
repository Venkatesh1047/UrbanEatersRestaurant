//
//  ViewController.swift
//  UrbanEaterRestaurant
//
//  Created by Nagaraju on 31/10/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //Table Orders #############
    //        URLhandler.postUrlSession(hideToast, urlString: Constants.urls.getTableOrdersURL, params: param as [String : AnyObject], header: header) { (dataResponse) in
    //            Themes.sharedInstance.removeActivityView(View: self.view)
    //            if dataResponse.json.exists(){
    //                let tableModel = TableOrderModel(fromJson: dataResponse.json)
    //                if GlobalClass.foodOrderModel != nil && self.selectionView.selectedIndex != 0 && !self.isFoodSelectedFlag{
    //                    if tableModel.new.count > GlobalClass.tableOrderModel.new.count{
    //                        self.newCountLbl.isHidden = false
    //                        self.newCountLbl.text = "\(tableModel.new.count - GlobalClass.tableOrderModel.new.count)"
    //                    }else{
    //                        self.newCountLbl.isHidden = true
    //                    }
    //                }
    //                GlobalClass.tableOrderModel = tableModel
    //                self.dummyTableOrderModel = tableModel
    //                if GlobalClass.tableOrderModel.data.count == 0{
    //                    if !hideToast{
    //                        TheGlobalPoolManager.showToastView("No Bookings available now")
    //                    }
    //                    self.tableView.reloadData()
    //                }else{
    //                    self.tableView.reloadData()
    //                }
    //            }
    //        }
    
    
    
    //Food Orders ###########
    //        URLhandler.postUrlSession(hideToast, urlString: Constants.urls.getFoodOrdersURL, params: param as [String : AnyObject], header: header) { (dataResponse) in
    //            Themes.sharedInstance.removeActivityView(View: self.view)
    //            if dataResponse.json.exists(){
    //                let foodModel = FoodOrderModel(fromJson: dataResponse.json)
    //                if GlobalClass.foodOrderModel != nil && self.selectionView.selectedIndex != 0 && self.isFoodSelectedFlag{
    //                    if foodModel.new.count > GlobalClass.foodOrderModel.new.count{
    //                        self.newCountLbl.isHidden = false
    //                        self.newCountLbl.text = "\(foodModel.new.count - GlobalClass.foodOrderModel.new.count)"
    //                    }else{
    //                        self.newCountLbl.isHidden = true
    //                    }
    //                }
    //                GlobalClass.foodOrderModel = foodModel
    //                self.dummyFoodOrderModel = foodModel
    //                if GlobalClass.foodOrderModel.data.count == 0{
    //                    if !hideToast{
    //                        TheGlobalPoolManager.showToastView("No orders available now")
    //                    }
    //                    self.tableView.reloadData()
    //                }else{
    //                    self.tableView.reloadData()
    //                }
    //            }
    //        }
    
    
    //All Orders #########
    //        URLhandler.postUrlSession(hideToast, urlString: Constants.urls.restaurantAllOrdersURL, params: param as [String : AnyObject], header: header) { (dataResponse) in
    //            Themes.sharedInstance.removeActivityView(View: self.view)
    //            if dataResponse.json.exists(){
    //                let restModel = RestaurantAllOrdersModel(fromJson: dataResponse.json)
    //                if GlobalClass.restaurantAllOrdersModel != nil && self.selectionView.selectedIndex != 0{
    //                    if restModel.new.count > GlobalClass.restaurantAllOrdersModel.new.count{
    //                        self.newCountLbl.isHidden = false
    //                        self.newCountLbl.text = "\(restModel.new.count - GlobalClass.restaurantAllOrdersModel.new.count)"
    //                    }else{
    //                        self.newCountLbl.isHidden = true
    //                    }
    //                }
    //                GlobalClass.restaurantAllOrdersModel = restModel
    //                if !self.searchActive{
    //                    self.dummyRestaurantAllOrdersModel = GlobalClass.restaurantAllOrdersModel
    //                    self.newDummy = GlobalClass.restaurantAllOrdersModel
    //                }
    //                if GlobalClass.restaurantAllOrdersModel.data.count == 0{
    //                    self.tableView.reloadData()
    //                    TheGlobalPoolManager.showToastView("No Orders available now")
    //                }else{
    //                    self.tableView.reloadData()
    //                }
    //            }
    //        }
}

