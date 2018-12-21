//
//  NewsViewController.swift
//  UrbanEaterRestaurant
//
//  Created by Nagaraju on 29/11/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewsViewController: UIViewController {

    @IBOutlet weak var newsTbl: UITableView!
    @IBOutlet weak var clearAllBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        newsTbl.tableFooterView = UIView()
        newsTbl.delegate = self
        newsTbl.dataSource = self
    }
    //MARK:- IB Action Outlets
    @IBAction func clearAllBtn(_ sender: UIButton) {
    }
}
extension NewsViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell : NotificationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationTableViewCell
        cell.titleLbl.text = "Notification 0\(indexPath.row + 1)"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

