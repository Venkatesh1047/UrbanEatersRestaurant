//
//  FoodItemsViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 25/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit
import JSSAlertView
import PopOverMenu

class FoodItemsViewController: UIViewController,UIAdaptivePresentationControllerDelegate,SelectGroupDelegate {

    @IBOutlet weak var foodItemsTbl: UITableView!
    var section = ["Desserts", "Snacks", "Biryani","Grill","Barbeque"]
    var items = [["item", "item1", "item2"], ["itemt3", "item4"], ["item6"], ["item7"], ["item8"]]
    
    var collapaseHandlerArray = [String]()
    var selectedSection = Int()
    var isItemAvailable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.foodItemsTbl.tableFooterView = UIView()
        
        foodItemsTbl.register(UINib(nibName: "FoodItemsTableViewCell", bundle: nil), forCellReuseIdentifier: "FoodItemsTableViewCell")
        
        let nibName = UINib(nibName:"FoodItemsTableViewCell1" , bundle: nil)
        foodItemsTbl.register(nibName, forCellReuseIdentifier: "FoodItemsTableViewCell1")
        
        foodItemsTbl.delegate = self
        foodItemsTbl.dataSource = self
        foodItemsTbl.reloadData()
    }
    
    @IBAction func addBtnClicked(_ sender: Any) {
       self.selectGroupXib()
    }
    //MARK : - Select Group XIB
    func selectGroupXib(){
        let tableView = SelectGroup(nibName: "SelectGroup", bundle: nil)
        tableView.delegate = self
        self.presentPopupViewController(tableView, animationType: MJPopupViewAnimationSlideTopTop)
    }
    func delegateForSelectedGroup(selectedGroup: [String], viewCon: SelectGroup) {
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationSlideBottomBottom)
        print("selected Items ---->>> \(selectedGroup)")

        if selectedGroup.count != 0 {
            self.section.append(contentsOf: selectedGroup)
            self.items.append(["item1"])
            self.foodItemsTbl.reloadData()
        }
    }
    
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:-----TableView Methods------
extension FoodItemsViewController : UITableViewDataSource,UITableViewDelegate {
    
    //setting number of Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return section.count
    }
    //Setting headerView Height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    //Setting Header Customised View
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //Declare cell
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "FoodItemsTableViewCell") as! FoodItemsTableViewCell
        
        //Setting Header Components
        headerCell.headerNameLbl.text = self.section[section]
        headerCell.expandBtn.tag = section
       // headerCell.closeBtn.tag = section
        //Handling Button Title
        if self.collapaseHandlerArray.contains(self.section[section]){
            //if its opened
            headerCell.expandBtn.setTitle("Hide", for: .normal)
            headerCell.expandBtn.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        else{
            //if closed
            headerCell.expandBtn.setTitle("Show", for: .normal)
            headerCell.expandBtn.transform = CGAffineTransform(rotationAngle: 0)
            
        }
        headerCell.expandBtn.addTarget(self, action: #selector(self.HandleExpandButton(sender:)), for: .touchUpInside)
     //   headerCell.closeBtn.addTarget(self, action: #selector(self.HandleCloseButton(sender:)), for: .touchUpInside)
        return headerCell.contentView
        
    }
    
    //Header cell button Action
    @objc func HandleExpandButton(sender: UIButton){
        selectedSection = sender.tag
        //check status of button
        if let buttonTitle = sender.title(for: .normal) {
            if buttonTitle == "Show"{
                //if yes
               self.collapaseHandlerArray.append(self.section[sender.tag])
               sender.setTitle("Hide", for: .normal)
            }
            else {
                //if no
                while self.collapaseHandlerArray.contains(self.section[sender.tag]){
                    if let itemToRemoveIndex = self.collapaseHandlerArray.index(of: self.section[sender.tag]) {
                        //remove title of header from array
                        self.collapaseHandlerArray.remove(at: itemToRemoveIndex)
                        sender.setTitle("Show", for: .normal)
                    }
                }
            }
        }
        //reload section
        self.foodItemsTbl.reloadSections(IndexSet(integer: sender.tag), with: .none)
    }
    
    //Setting number of rows in a section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.collapaseHandlerArray.contains(self.section[section]){
            return items[section].count
        }
        else{
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FoodItemsTableViewCell1 = tableView.dequeueReusableCell(withIdentifier: "FoodItemsTableViewCell1") as! FoodItemsTableViewCell1
        
        cell.itemNameLbl.text = items[indexPath.section][indexPath.row] //section[indexPath.row]
       // cell.itemDeleteBtn.tag = indexPath.row
        cell.itemHideBtn.tag = indexPath.row
       // cell.itemDeleteBtn.addTarget(self, action: #selector(self.itemDeleteBtnAction(sender:)), for: .touchUpInside)
        cell.itemHideBtn.addTarget(self, action: #selector(self.itemHideBtnAction(sender:)), for: .touchUpInside)
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell;
    }
    
    @objc func itemHideBtnAction(sender: UIButton){
        
        let titles:[String] = ["Make Unavailable", "Delete Item"]
        let popOverViewController = PopOverViewController.instantiate()
        popOverViewController.setTitles(titles)
        popOverViewController.setSeparatorStyle(UITableViewCellSeparatorStyle.singleLine)
        popOverViewController.popoverPresentationController?.sourceView = sender
        popOverViewController.popoverPresentationController?.sourceRect = sender.bounds
        popOverViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popOverViewController.preferredContentSize = CGSize(width: 180, height:80)
        popOverViewController.presentationController?.delegate = self
        popOverViewController.completionHandler = { selectRow in
            switch (selectRow) {
            case 0:
                self.itemHideNshowAction(sender: sender)
                break
            case 1:
                self.itemDeleteBtnAction(sender: sender)
                break

            default:
                break
            }
        };
        self.present(popOverViewController, animated: true, completion: nil)
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func itemHideNshowAction(sender: UIButton){
        var messageTxt = ""
        if isItemAvailable {
            messageTxt = "Are you sure you want to make Available " + items[selectedSection][sender.tag]
        }else{
            messageTxt = "Are you sure you want to make Unavailable " + items[selectedSection][sender.tag]
        }
        
        
        let alertView = JSSAlertView().showAlert(self,title: messageTxt ,text:nil,buttonText: "CANCEL",cancelButtonText:"CONFIRM",color: UIColor.green)
        
        alertView.addAction{
            print("no show --->>>")
        }
        alertView.addCancelAction({
            print("yes hide --->>>")
            if self.isItemAvailable {
                self.isItemAvailable = false
               // sender.setImage(#imageLiteral(resourceName: "ic_uncheck"), for: .normal)
            }else{
                self.isItemAvailable = true
               // sender.setImage(#imageLiteral(resourceName: "ic_check"), for: .normal)
                
            }
            self.foodItemsTbl.reloadData()
        })
    }
    
    func itemDeleteBtnAction(sender: UIButton){
        let messageTxt = "Are you sure you want to delete " + items[selectedSection][sender.tag]
        
        let alertView = JSSAlertView().showAlert(self,title: messageTxt ,text:nil,buttonText: "CANCEL",cancelButtonText:"CONFIRM",color: UIColor.green)
        
        alertView.addAction{
            print("no delete --->>>")
        }
        alertView.addCancelAction({
            print("yes del --->>>")
          //  self.items.remove(at: [self.selectedSection][sender.tag])
         //   self.foodItemsTbl.reloadData()
        })
    }
    
    //Setting footer height
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
}
}

