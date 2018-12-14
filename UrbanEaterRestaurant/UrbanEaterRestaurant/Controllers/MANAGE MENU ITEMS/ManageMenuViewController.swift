//
//  ManageMenuViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 24/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit

class ManageMenuViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var menuList = [String]()
    @IBOutlet weak var manageMenuTbl: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        menuList = ["Manage Recommended Items","Manage Food Items","Manage Categories"]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one MenuList
        let cell:MenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MenuList", for: indexPath) as! MenuTableViewCell
        
        cell.titleLabel.text = self.menuList[indexPath.row]
        cell.selectionStyle = .none
        tableView.rowHeight = 50
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // ["Manage Recommended Items","Manage Food Items","Manage Categories"]
        let value = menuList[indexPath.row]
        switch value {
        case "Manage Recommended Items":
            let passwordVC = self.storyboard?.instantiateViewController(withIdentifier: "RecommendedVCID") as! RecommendedViewController
            self.navigationController?.pushViewController(passwordVC, animated: true)
            break
           
        case "Manage Food Items":
            let passwordVC = self.storyboard?.instantiateViewController(withIdentifier: "FoodItemsVCID") as! FoodItemsViewController
            self.navigationController?.pushViewController(passwordVC, animated: true)
            break
            
        case "Manage Categories":
            let passwordVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesVCID") as! CategoriesViewController
            self.navigationController?.pushViewController(passwordVC, animated: true)
            break
            
        default:
            break
        }
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
