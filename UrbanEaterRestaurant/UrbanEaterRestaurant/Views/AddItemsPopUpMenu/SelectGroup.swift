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
    var selectedGroup : [String] = []
   // var selectedTags = [String]()
    var itemsList = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemsList = ["Manchow Soup","Chicken Roll","Hot Dogg","Brownie","Donut","French Fries","Sweet Corn Soup","Veg Manchurain"]
        updateUI()
    }
    //MARK : - Methods
    func updateUI(){
        selectClubLbl.backgroundColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        nextBtn.backgroundColor = #colorLiteral(red: 0.2823529412, green: 0.7058823529, blue: 0.2549019608, alpha: 1)
        //self.view.layer.cornerRadius = 10
        self.tableView.register(UINib(nibName: "SelectGroupCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        nextBtn.layer.cornerRadius = 5.0
        nextBtn.layer.masksToBounds = true
        
//        TheGlobalPoolManager.groupNamesApiHitting(self) { (success, reponse) -> (Void) in
//            if success{
//                if TheGlobalPoolManager.groupNamesModel.data.count == 0{
//                    self.nextBtn.isEnabled = false
//                    self.nextBtn.alpha = 0.5
//                }else{
//                     self.nextBtn.isEnabled = true
//                    self.nextBtn.alpha = 1.0
//                     self.tableView.reloadData()
//                }
//            }
//        }
        
        if itemsList.count == 0{
            self.nextBtn.isEnabled = false
            self.nextBtn.alpha = 0.5
        }else{
            self.nextBtn.isEnabled = true
            self.nextBtn.alpha = 1.0
            self.tableView.reloadData()
        }
    }
    //MARK : -  IB Action Outlets
    @IBAction func nextBtn(_ sender: UIButton) {
       // If checklist not update, setting previous data
        if selectedGroup.count == 0 {
            self.selectedGroup = Constants.sharedInstance.selectedTags
        }
        if selectedGroup != nil{
            if delegate != nil{
                self.delegate.delegateForSelectedGroup(selectedGroup: selectedGroup, viewCon:self)
            }
        }
        else{
           // TheGlobalPoolManager.showToastView("Please select your Group")
            print("Please select your Group --->>")
        }
    }
}
// MARK : - Table View Methods
extension SelectGroup : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if TheGlobalPoolManager.groupNamesModel == nil{
//            return 0
//        }
//        return TheGlobalPoolManager.groupNamesModel.data.count
        return itemsList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SelectGroupCell
       // cell.titleLbl.text = TheGlobalPoolManager.groupNamesModel.data[indexPath.row].groupName!
        cell.titleLbl.text = itemsList[indexPath.row]
        cell.titleLbl.font = UIFont(name: Constants.FontName.Regular, size: 15)
        let selectedValue = Constants.sharedInstance.selectedTags.contains((itemsList[indexPath.row]))
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
        let data = itemsList[indexPath.row]
        let selectedValue = Constants.sharedInstance.selectedTags.contains(data)
        if !selectedValue{
            Constants.sharedInstance.selectedTags.append(data)
        }else{
            let indx = Constants.sharedInstance.selectedTags.index(of: data)
            Constants.sharedInstance.selectedTags.remove(at: indx!)
        }
        tableView.reloadData()
        print(Constants.sharedInstance.selectedTags)
        self.selectedGroup = Constants.sharedInstance.selectedTags
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let data = itemsList[indexPath.row]
        let selectedValue = Constants.sharedInstance.selectedTags.contains(data)
        if selectedValue{
            let indx = Constants.sharedInstance.selectedTags.index(of: data)
            Constants.sharedInstance.selectedTags.remove(at: indx!)
        }
        tableView.reloadData()
        print(Constants.sharedInstance.selectedTags)
        self.selectedGroup = Constants.sharedInstance.selectedTags
    }
}


//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! SelectGroupCell
//        cell.cellSelected(true)
//        self.selectedGroup = itemsList[indexPath.row]
//    }

