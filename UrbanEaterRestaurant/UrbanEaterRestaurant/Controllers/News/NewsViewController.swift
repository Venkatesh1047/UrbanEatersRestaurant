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

    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var newsTbl: UITableView!
    @IBOutlet weak var clearAllBtn: UIButton!
    @IBOutlet weak var noDataAvailableLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationsReceived(_:)), name: NSNotification.Name.init("NotifyReceived"), object: nil)
        self.updateUI()
    }
    //MARK:- Received Notifications
    @objc func notificationsReceived(_ notification:Notification){
        self.newsTbl.reloadData()
    }
    //MARK:- Update UI
    func updateUI(){
        newsTbl.tableFooterView = UIView()
        newsTbl.delegate = self
        newsTbl.dataSource = self
        self.clearAllBtn.isHidden = true
        var notificationObject = [String:[AnyObject]]()
        if let notifications = TheGlobalPoolManager.retrieveFromDefaultsFor("Notifications"){
            if !(notifications is NSNull){
                notificationObject = notifications as! [String:[AnyObject]]
                GlobalClass.notificationsModel = NotificationsModel(fromJson: JSON(notificationObject as Any))
                self.clearAllBtn.isHidden = false
                self.noDataAvailableLbl.isHidden = true
            }else{
                self.noDataAvailableLbl.isHidden = false
            }
        }else{
            self.noDataAvailableLbl.isHidden = false
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK:- IB Action Outlets
    @IBAction func clearAllBtn(_ sender: UIButton) {
        GlobalClass.notificationsModel = nil
        TheGlobalPoolManager.removeFromDefaultsFor("Notifications")
        self.newsTbl.reloadData()
    }
}
extension NewsViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return GlobalClass.notificationsModel == nil ? 0 : GlobalClass.notificationsModel.notifications.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell : NotificationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationTableViewCell
        let data = GlobalClass.notificationsModel.notifications[indexPath.row]
        cell.titleLbl.text = data.aps.alert.title
        cell.descLbl.text = data.aps.alert.body
        cell.dateLbl.text = data.date
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

