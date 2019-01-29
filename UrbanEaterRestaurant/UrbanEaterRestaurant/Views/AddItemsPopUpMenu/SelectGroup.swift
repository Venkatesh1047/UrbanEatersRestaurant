//
//  SelectGroup.swift
//  SCHQApps
//
//  Created by Samcom iMac on 02/04/18.
//  Copyright © 2018 IOS Developers. All rights reserved.
//

import UIKit

protocol SelectGroupDelegate {
    func delegateForSelectedGroup(selectedGroup :[String],viewCon:SelectGroup)
}

class SelectGroup: UIViewController {

    @IBOutlet weak var selectClubLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextBtn: UIButton!
    var delegate : SelectGroupDelegate!
    var selectedItems = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    //MARK : - Methods
    func updateUI(){
        self.view.layer.cornerRadius = 10
        self.tableView.register(UINib(nibName: "SelectGroupCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        TheGlobalPoolManager.cornerAndBorder(nextBtn, cornerRadius: 8, borderWidth: 0, borderColor: .clear)
        self.recommendedItemsApiHitting()
    }
    //MARK:- Recommended  Items Api Hitting
    func recommendedItemsApiHitting(){
        Themes.sharedInstance.activityView(View: self.view)
        let param = ["restaurantId": GlobalClass.restaurantLoginModel.data.subId!]
        let header = [X_SESSION_ID : GlobalClass.restaurantLoginModel.data.sessionId!]
        URLhandler.postUrlSession(urlString: Constants.urls.RecommendedItems, params: param as [String : AnyObject], header: header) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                GlobalClass.recommendedItemsModel = RecommendedModel(fromJson: dataResponse.json)
                if GlobalClass.recommendedItemsModel.hiddenItems.count == 0{
                    self.nextBtn.isEnabled = false
                    self.nextBtn.alpha = 0.5
                    TheGlobalPoolManager.showToastView("No Items available...")
                }else{
                    self.nextBtn.isEnabled = true
                    self.nextBtn.alpha = 1.0
                    self.tableView.reloadData()
                }
            }
        }
    }
    //MARK:- Update Recommended Items Hitting
    func updateRecommendedItemsApiHitting(){
        Themes.sharedInstance.activityView(View: self.view)
        let header = [X_SESSION_ID : GlobalClass.restaurantLoginModel.data.sessionId!]
        let param = ["itemList": self.selectedItems,
                               "restaurantId": GlobalClass.restaurantLoginModel.data.subId!] as [String : Any]
        URLhandler.postUrlSession(urlString: Constants.urls.UpdateRecommendedItems, params: param as [String : AnyObject], header: header) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                NotificationCenter.default.post(name: Notification.Name("UpdateRecommendedItems"), object: nil)
            }
        }
    }
    //MARK : -  IB Action Outlets
    @IBAction func nextBtn(_ sender: UIButton) {
        if selectedItems.count == 0{
            TheGlobalPoolManager.showToastView("Please select atleast one item to continue")
        }else{
            self.updateRecommendedItemsApiHitting()
        }
    }
}
// MARK : - Table View Methods
extension SelectGroup : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalClass.recommendedItemsModel == nil ? 0 : GlobalClass.recommendedItemsModel.hiddenItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SelectGroupCell
        let data = GlobalClass.recommendedItemsModel.hiddenItems[indexPath.row]
        cell.titleLbl.text = data.name!
        let selectedValue = self.selectedItems.contains((data.id!))
        if selectedValue {
            cell.cellSelected(true)
        }
        else{
            cell.cellSelected(false)
        }
        tableView.rowHeight = 50
        cell.selectionStyle = .default
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = GlobalClass.recommendedItemsModel.hiddenItems[indexPath.row]
        let selectedValue = self.selectedItems.contains(data.id!)
        if !selectedValue{
            self.selectedItems.append(data.id!)
        }else{
            let indx = self.selectedItems.index(of: data.id!)
            self.selectedItems.remove(at: indx!)
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let data = GlobalClass.recommendedItemsModel.hiddenItems[indexPath.row]
        let selectedValue = self.selectedItems.contains(data.id!)
        if selectedValue{
            let indx = self.selectedItems.index(of: data.id!)
            self.selectedItems.remove(at: indx!)
        }
        tableView.reloadData()
    }
}

