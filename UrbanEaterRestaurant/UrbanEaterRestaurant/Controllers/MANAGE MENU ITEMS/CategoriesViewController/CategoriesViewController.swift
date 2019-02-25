//
//  CategoriesViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 25/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit
import EZSwiftExtensions
class CategoriesViewController: UIViewController {

    @IBOutlet weak var categoryTbl: UITableView!
    @IBOutlet weak var addCategoryBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(CategoriesViewController.methodOfReceivedNotification(notification:)), name: Notification.Name("NewCategoryAdded"), object: nil)
        categoryTbl.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCell")
        self.updateUI()
    }
    @objc func methodOfReceivedNotification(notification: Notification){
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationSlideTopTop)
        self.manageCategoriesApiHitting()
    }
    //MARK:- Update UI
    func updateUI(){
        self.addCategoryBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35 ,cornerRadius : self.addCategoryBtn.layer.bounds.h / 2)
        categoryTbl.tableFooterView = UIView()
        categoryTbl.delegate = self
        categoryTbl.dataSource = self
        self.manageCategoriesApiHitting()
    }
    //MARK: - Add Category Pop Up
    func addCategoryPopUpView(){
        let viewCon = AddCategoryView(nibName: "AddCategoryView", bundle: nil)
        self.presentPopupViewController(viewCon, animationType: MJPopupViewAnimationSlideTopTop)
    }
    //Delete Button Method
    @objc func deleteBtnMethod(_ btn : UIButton){
        TheGlobalPoolManager.showAlertWith(title: "Are you sure", message: "You want to delete this Category?", singleAction: false, okTitle:"Confirm") { (sucess) in
            if sucess!{
                let data = GlobalClass.manageCategoriesModel.data[btn.tag]
                self.categoryDeleteApiHitting(data.categoryId!)
            }
        }
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
                self.categoryTbl.reloadData()
            }
        }
    }
    //MARK:- Recommended Item Items Delete Api Hitting
    func categoryDeleteApiHitting(_ itemID : String){
        Themes.sharedInstance.activityView(View: self.view)
        let param = [ID: itemID]
        let header = [X_SESSION_ID : GlobalClass.restaurantLoginModel.data.sessionId!]
        
        URLhandler.postUrlSession(urlString: Constants.urls.Category_Delete_By_ID, params: param as [String : AnyObject], header: header) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                self.manageCategoriesApiHitting()
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func addBtnClicked(_ sender: Any) {
        // Add Button
    }
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addCategoryBtn(_ sender: UIButton) {
        self.addCategoryPopUpView()
    }
}
extension CategoriesViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return GlobalClass.manageCategoriesModel == nil ? 0 : GlobalClass.manageCategoriesModel.data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell") as! CategoryTableViewCell
        let data = GlobalClass.manageCategoriesModel.data[indexPath.row]
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnMethod(_:)), for: .touchUpInside)
        cell.deleteBtn.setImage(#imageLiteral(resourceName: "Delete").withColor(.redColor), for: .normal)
        cell.deleteBtn.imageEdgeInsets = UIDevice.isPhone() ? UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5) : UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        cell.titleLbl.text = data.name!
        cell.selectionStyle = .none
        tableView.separatorStyle = .singleLine
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.isPhone() ? 50 : 60
    }
}
