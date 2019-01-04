//
//  ItemsDetailView.swift
//  UrbanEaterRestaurant
//
//  Created by Vamsi on 07/12/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class ItemsDetailView: UIViewController {

    @IBOutlet weak var viewInView: UIView!
    @IBOutlet weak var orderIDLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var driverIDLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var enterOrderCodeBgView: viewWithShadow!
    @IBOutlet weak var enterCodeTf: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
    var schedule:FoodOrderModelData!
    var scheduledFromHome : RestaurantAllOrdersData!
    var isComingFromHome : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.doneBtn.backgroundColor = #colorLiteral(red: 0.2823529412, green: 0.7058823529, blue: 0.2549019608, alpha: 0.2997645548)
        self.enterCodeTf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        TheGlobalPoolManager.cornerAndBorder(enterOrderCodeBgView, cornerRadius: enterOrderCodeBgView.frame.h/2, borderWidth: 0, borderColor: .clear)
        collectionView.register(UINib(nibName: "ItemsDetailCell", bundle: nil), forCellWithReuseIdentifier: "ItemsDetailCell")
        TheGlobalPoolManager.cornerAndBorder(viewInView, cornerRadius: 15, borderWidth: 0, borderColor: .clear)
        TheGlobalPoolManager.cornerAndBorder(doneBtn, cornerRadius: 5, borderWidth: 0, borderColor: .clear)
        self.collectionView.register(UINib.init(nibName: "ItemsDetailCell", bundle: nil), forCellWithReuseIdentifier: "ItemsDetailCell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left:0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: collectionView.frame.width, height: 30)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        collectionView!.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        self.enterCodeTf.delegate = self
        self.enterCodeTf.keyboardType = .numberPad
        if isComingFromHome{
            self.orderIDLbl.text = "Order ID: \(scheduledFromHome.order[0].subOrderId!)"
            self.driverIDLbl.text = "ID: \(scheduledFromHome.order[0].code!)"
            self.priceLbl.text = "₹ \(scheduledFromHome.order[0].billing.orderTotal!.toString)"
            if scheduledFromHome.driverId != nil{
                if scheduledFromHome.driverIdData != nil {
                    self.nameLbl.text = scheduledFromHome.driverIdData.name!
                }else{
                   self.nameLbl.text = GlobalClass.DRIVER_NOT_ALLOCATED
                }
            }else{
                self.nameLbl.text = GlobalClass.DRIVER_NOT_ALLOCATED
            }
        }else{
            self.orderIDLbl.text = "Order ID: \(schedule.order[0].subOrderId!)"
            self.driverIDLbl.text = "ID: \(schedule.order[0].code!)"
            self.priceLbl.text = "₹ \(schedule.order[0].billing.orderTotal!.toString)"
            if schedule.driverId != ""{
                if schedule.driverIdData != nil {
                    self.nameLbl.text = schedule.driverIdData.name!
                }else{
                    self.nameLbl.text = GlobalClass.DRIVER_NOT_ALLOCATED
                }
            }else{
                self.nameLbl.text = GlobalClass.DRIVER_NOT_ALLOCATED
            }
        }
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.length == 0{
            self.doneBtn.backgroundColor = #colorLiteral(red: 0.2823529412, green: 0.7058823529, blue: 0.2549019608, alpha: 0.2997645548)
        }else if textField.text?.length == 4{
           self.doneBtn.backgroundColor = .greenColor
        }else{
            self.doneBtn.backgroundColor = #colorLiteral(red: 0.2823529412, green: 0.7058823529, blue: 0.2549019608, alpha: 0.2997645548)
        }
    }
    @IBAction func doneBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        if enterCodeTf.text?.length != 4{
            TheGlobalPoolManager.showToastView("Invalid Order Code")
        }else{
            if isComingFromHome{
                self.foodOrderUpdateRequestApiHitting(scheduledFromHome.id!, resID: GlobalClass.restaurantLoginModel.data.subId!, status: "DRI_PICKED", code: enterCodeTf.text!)
            }else{
                self.foodOrderUpdateRequestApiHitting(schedule.id!, resID: GlobalClass.restaurantLoginModel.data.subId!, status: "DRI_PICKED", code: enterCodeTf.text!)
            }
        }
    }
    //MARK:- Food Order Update  Request
    func foodOrderUpdateRequestApiHitting(_ orderId : String , resID : String , status : String, code:String){
        Themes.sharedInstance.activityView(View: self.view)
        let param = ["id": orderId,
                     "restaurantId": [resID],
                     "status": status,
                     "code":code] as [String : AnyObject]
        URLhandler.postUrlSession(urlString: Constants.urls.FoodOrderUpdateReqURL, params: param, header: [:]) { (dataResponse) in
            if dataResponse.json.exists(){
                 NotificationCenter.default.post(name: Notification.Name("DoneButtonClicked"), object: nil)
            }
        }
    }
}
extension ItemsDetailView : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isComingFromHome{
            return scheduledFromHome.items.count
        }
       return schedule.items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemsDetailCell", for: indexPath as IndexPath) as! ItemsDetailCell
        if isComingFromHome{
            let data = scheduledFromHome!
            ez.runThisInMainThread {
                if data.items.count > 0{
                    self.view.frame.h = CGFloat(185 + data.items.count * 30)
                }else if data.items.count > 5 {
                    self.view.frame.h = 335
                }else{
                    self.view.frame.h = 205
                }
            }
            if data.items[indexPath.row].vorousType! == 2{
                cell.vorousTypeImage.image = #imageLiteral(resourceName: "NonVeg")
            }else{
                cell.vorousTypeImage.image = #imageLiteral(resourceName: "Veg")
            }
            cell.itemLbl.text = data.items[indexPath.row].name!
            cell.itemsLbl.text = "✕\(data.items[indexPath.row].quantity!)"
            cell.priceLbl.text =  "₹ \(data.items[indexPath.row].finalPrice!.toString)"
        }else{
            let data = schedule!
            ez.runThisInMainThread {
                if data.items.count > 0{
                    self.view.frame.h = CGFloat(185 + data.items.count * 30)
                }else if data.items.count > 5 {
                    self.view.frame.h = 335
                }else{
                    self.view.frame.h = 205
                }
            }
            if data.items[indexPath.row].vorousType! == 2{
                cell.vorousTypeImage.image = #imageLiteral(resourceName: "NonVeg")
            }else{
                cell.vorousTypeImage.image = #imageLiteral(resourceName: "Veg")
            }
            cell.itemLbl.text = data.items[indexPath.row].name!
            cell.itemsLbl.text = "✕\(data.items[indexPath.row].quantity!)"
            cell.priceLbl.text =  "₹ \(data.items[indexPath.row].finalPrice!.toString)"
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.item)!")
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 30)
    }
}
extension ItemsDetailView:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length == 1{
            return true
        }
        return (textField.text?.length)! < 4
    }
}
