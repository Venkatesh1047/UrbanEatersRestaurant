//
//  RecommendedViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 25/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit
import JSSAlertView

class RecommendedViewController:UIViewController,UITableViewDelegate,UITableViewDataSource,SelectGroupDelegate {

    @IBOutlet weak var recommendItemTbl: UITableView!
    var itemsList = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let nibName = UINib(nibName:"RecommendedTableViewCell" , bundle: nil)
        recommendItemTbl.register(nibName, forCellReuseIdentifier: "RecommendedTableViewCell")
        
        itemsList = ["Biryani","Snacks"]
        recommendItemTbl.delegate = self
        recommendItemTbl.dataSource = self
        recommendItemTbl.tableFooterView = UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell : RecommendedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RecommendedTableViewCell") as! RecommendedTableViewCell
        
        cell.itemNameLbl.text = itemsList[indexPath.row]
        cell.itemDeleteBtn.tag = indexPath.row
        cell.itemDeleteBtn.addTarget(self, action: #selector(self.itemDeleteBtnAction(_:)), for: .touchUpInside)
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    @objc func itemDeleteBtnAction(_ sender:UIButton){
        
        let messageTxt = "Are you sure you want to delete " + itemsList[sender.tag]
        
        let alertView = JSSAlertView().showAlert(self,title: messageTxt ,text:nil,buttonText: "CANCEL",cancelButtonText:"CONFIRM",color: UIColor.green)
        
        alertView.addAction{
            print("no logout --->>>")
        }
        alertView.addCancelAction({
            print("yes logot --->>>")
            self.itemsList.remove(at: sender.tag)
            self.recommendItemTbl.reloadData()
        })

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
            self.itemsList.append(contentsOf: selectedGroup)
            self.recommendItemTbl.reloadData()
        }
    }

    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
