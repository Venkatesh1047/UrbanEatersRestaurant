//
//  CategoriesViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 25/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit
import EZSwiftExtensions
class CategoriesViewController: UIViewController,SelectGroupDelegate {

    @IBOutlet weak var categoryTbl: UITableView!
    var section = ["Desserts", "Snacks", "Biryani","Grill","Barbeque","Pizza"]

    var collapaseHandlerArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTbl.register(UINib(nibName: "FoodItemsTableViewCell", bundle: nil), forCellReuseIdentifier: "FoodItemsTableViewCell")
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        self.categoryTbl.tableFooterView = UIView()
        categoryTbl.delegate = self
        categoryTbl.dataSource = self
        self.manageCategoriesApiHitting()
    }
    //MARK : - Select Group XIB 405
    func selectGroupXib(){
        let tableView = SelectGroup(nibName: "SelectGroup", bundle: nil)
        tableView.delegate = self
        self.presentPopupViewController(tableView, animationType: MJPopupViewAnimationSlideTopTop)
    }
    func delegateForSelectedGroup(selectedGroup: [String], viewCon: SelectGroup) {
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationSlideBottomBottom)
        if selectedGroup.count != 0 {
            self.section.append(contentsOf: selectedGroup)
            self.categoryTbl.reloadData()
        }
    }
    //MARK:- Manage Categories  Api Hitting
    func manageCategoriesApiHitting(){
        Themes.sharedInstance.activityView(View: self.view)
        let param = ["restaurantId": GlobalClass.restaurantLoginModel.data.subId!]
        URLhandler.postUrlSession(urlString: Constants.urls.ManageCaegories, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                GlobalClass.manageCategoriesModel = ManageCategoriesModel(fromJson: dataResponse.json)
                self.categoryTbl.reloadData()
            }
        }
    }
    //MARK:- Recommended Item Items Delete Api Hitting
    func categoryDeleteApiHitting(_ itemID : String){
        Themes.sharedInstance.activityView(View: self.view)
        let param = ["id": [itemID]]
        URLhandler.postUrlSession(urlString: Constants.urls.RecommendedItemDelete, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
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
}
extension CategoriesViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return GlobalClass.manageCategoriesModel == nil ? 0 : GlobalClass.manageCategoriesModel.data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodItemsTableViewCell") as! FoodItemsTableViewCell
        let data = GlobalClass.manageCategoriesModel.data[indexPath.row]
        cell.expandBtn.isHidden = true
        //cell.expandBtn.setImage(#imageLiteral(resourceName: "Visible").withColor(.secondaryBGColor), for: .normal)
        cell.expandBtn.imageEdgeInsets = UIEdgeInsets.init(top: 6, left: 6, bottom: 6, right: 6)
        cell.headerNameLbl.text = data.name!
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.isPhone() ? 50 : 60
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle:  UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            TheGlobalPoolManager.showAlertWith(title: "Are you sure", message: "You want to delete?", singleAction: false, okTitle:"Confirm") { (sucess) in
                if sucess!{
                    let data = GlobalClass.recommendedModel.data[indexPath.row]
                    self.categoryDeleteApiHitting(data.id!)
                }
            }
        }
    }
}
