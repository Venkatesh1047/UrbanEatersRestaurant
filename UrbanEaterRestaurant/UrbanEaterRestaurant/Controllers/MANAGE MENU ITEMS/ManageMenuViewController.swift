//
//  ManageMenuViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 24/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit

class ManageMenuViewController: UIViewController {
    
    @IBOutlet weak var manageMenuTbl: UITableView!
    var menuList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        manageMenuTbl.tableFooterView = UIView()
        manageMenuTbl.delegate = self
        manageMenuTbl.dataSource = self
        menuList = ["Manage Recommended Items","Manage Food Items","Manage Categories"]
    }
    //MARK:- IB Action Outlets
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK:-----TableView Methods------
extension ManageMenuViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MenuList", for: indexPath) as! MenuTableViewCell
        cell.titleLabel.text = self.menuList[indexPath.row]
        cell.selectionStyle = .none
        tableView.rowHeight = UIDevice.isPhone() ? 50 : 60
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = indexPath.row
        switch value {
        case 0:
            let passwordVC = self.storyboard?.instantiateViewController(withIdentifier: "RecommendedVCID") as! RecommendedViewController
            self.navigationController?.pushViewController(passwordVC, animated: true)
        case 1:
            let passwordVC = self.storyboard?.instantiateViewController(withIdentifier: "FoodItemsVCID") as! FoodItemsViewController
            self.navigationController?.pushViewController(passwordVC, animated: true)
        case 2:
            let passwordVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesVCID") as! CategoriesViewController
            self.navigationController?.pushViewController(passwordVC, animated: true)
        default:
            break
        }
    }
}
