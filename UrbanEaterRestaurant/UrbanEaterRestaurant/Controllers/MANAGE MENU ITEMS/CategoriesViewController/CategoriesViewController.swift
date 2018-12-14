//
//  CategoriesViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 25/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit
import JSSAlertView

class CategoriesViewController: UIViewController,SelectGroupDelegate {

    @IBOutlet weak var categoryTbl: UITableView!
    var section = ["Desserts", "Snacks", "Biryani","Grill","Barbeque","Pizza"]

    var collapaseHandlerArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.categoryTbl.tableFooterView = UIView()

        categoryTbl.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")

        let nibName = UINib(nibName:"EditCatagoryTableViewCell" , bundle: nil)
        categoryTbl.register(nibName, forCellReuseIdentifier: "EditCatagoryTableViewCell")
        
        categoryTbl.delegate = self
        categoryTbl.dataSource = self
        categoryTbl.reloadData()
    }
    
    @IBAction func addBtnClicked(_ sender: Any) {
        self.selectGroupXib()
    }
    
    //MARK : - Select Group XIB 405
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
            self.categoryTbl.reloadData()
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
extension CategoriesViewController : UITableViewDataSource,UITableViewDelegate {
    
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
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        
        //Setting Header Components
        headerCell.headerNameLbl.text = self.section[section]
        headerCell.showBtn.tag = section
        headerCell.closeBtn.tag = section
        //Handling Button Title
        if self.collapaseHandlerArray.contains(self.section[section]){
            //if its opened
            headerCell.showBtn.setTitle("Hide", for: .normal)
        }
        else{
            //if closed
            headerCell.showBtn.setTitle("Show", for: .normal)
        }
        headerCell.showBtn.addTarget(self, action: #selector(self.HandleheaderButton(sender:)), for: .touchUpInside)
        headerCell.closeBtn.addTarget(self, action: #selector(self.HandleCloseButton(sender:)), for: .touchUpInside)
        return headerCell.contentView
        
    }
    
    //Setting number of rows in a section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.collapaseHandlerArray.contains(self.section[section]){
            return 1
        }
        else{
            return 0
        }
    }
    
    
    //Setting cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : EditCatagoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EditCatagoryTableViewCell") as! EditCatagoryTableViewCell
        cell.catagoryTxt.text = section[indexPath.section]
        cell.updateBtn.tag = indexPath.section
        cell.updateBtn.addTarget(self, action: #selector(self.HandleCategoryUpdateButton(sender:)), for: .touchUpInside)
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell;
    }
    
    //Setting footer height
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    @objc func HandleCloseButton(sender: UIButton) {
        
        let messageTxt = "Are you sure you want to delete " + section[sender.tag]
        
        let alertView = JSSAlertView().showAlert(self,title: messageTxt ,text:nil,buttonText: "CANCEL",cancelButtonText:"CONFIRM",color: UIColor.green)
        
        alertView.addAction{
            print("no logout --->>>")
        }
        alertView.addCancelAction({
            print("yes logot --->>>")
            self.section.remove(at: sender.tag)
            self.categoryTbl.reloadData()
        })
        
    }
    
    func logoutAction(){

    }
    
    @objc func HandleCategoryUpdateButton(sender: UIButton) {
        print("to Colopse cell position ----->>>> \(sender.tag)")
        
        let indexPath = IndexPath(row: 0, section: sender.tag)
        let cell = categoryTbl.cellForRow(at: indexPath) as! EditCatagoryTableViewCell
        let editedCat:String = cell.catagoryTxt.text!
        while self.collapaseHandlerArray.contains(self.section[sender.tag]){
            if let itemToRemoveIndex = self.collapaseHandlerArray.index(of: self.section[sender.tag]) {
                //remove title of header from array
                self.collapaseHandlerArray.remove(at: itemToRemoveIndex)
            }
        }
        self.section[sender.tag] = editedCat
        print("section arrafter edit  ---------->>> \(self.section)")
        self.categoryTbl.reloadSections(IndexSet(integer: sender.tag), with: .none)
    }
    
    //Header cell button Action
    @objc func HandleheaderButton(sender: UIButton){
        
        self.collapaseHandlerArray.append(self.section[sender.tag])
        //reload section
        self.categoryTbl.reloadSections(IndexSet(integer: sender.tag), with: .none)
    }
}
