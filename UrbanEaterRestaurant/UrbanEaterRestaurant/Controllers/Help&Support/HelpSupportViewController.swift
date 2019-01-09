//
//  HelpSupportViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 24/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit

class HelpSupportViewController: UIViewController {
    
    @IBOutlet weak var helpTbl: UITableView!
    var menuList = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        menuList = ["Contact Us","Feedback","FAQ","Privacy Policy","Terms of Use","Cancellations & Refunds"]
        helpTbl.delegate = self
        helpTbl.dataSource = self
        helpTbl.tableFooterView = UIView ()
    }
    //MARK:- IB Action Outlets
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension HelpSupportViewController: UITableViewDataSource,UITableViewDelegate {
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
        
    }
}
