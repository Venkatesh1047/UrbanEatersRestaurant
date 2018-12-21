//
//  ItemsDetailView.swift
//  UrbanEaterRestaurant
//
//  Created by Vamsi on 07/12/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import UIKit

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
        doneBtn.isEnabled = false
        [enterCodeTf].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
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
        layout.scrollDirection = .horizontal
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
        }else{
            self.orderIDLbl.text = "Order ID: \(schedule.order[0].subOrderId!)"
            self.driverIDLbl.text = "ID: \(schedule.order[0].code!)"
            self.priceLbl.text = "₹ \(schedule.order[0].billing.orderTotal!.toString)"
        }
    }
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let code = enterCodeTf.text, !code.isEmpty
            else {
                doneBtn.isEnabled = false
                return
        }
        doneBtn.isEnabled = true
    }
    @IBAction func doneBtn(_ sender: UIButton) {
        if enterCodeTf.text?.length != 4{
            TheGlobalPoolManager.showToastView("Invalid Order Code")
        }else{
            if isComingFromHome{
                self.foodOrderUpdateRequestApiHitting(scheduledFromHome.id!, resID: GlobalClass.restaurantLoginModel.data.subId!, status: "DRI_PICKED")
            }else{
                self.foodOrderUpdateRequestApiHitting(schedule.id!, resID: GlobalClass.restaurantLoginModel.data.subId!, status: "DRI_PICKED")
            }
        }
    }
    //MARK:- Food Order Update  Request
    func foodOrderUpdateRequestApiHitting(_ orderId : String , resID : String , status : String){
        Themes.sharedInstance.activityView(View: self.view)
        let param = ["id": orderId,
                                "restaurantId": [resID],
                                "status": status] as [String : Any]
        URLhandler.postUrlSession(urlString: Constants.urls.FoodOrderUpdateReqURL, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
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
            if data.items[indexPath.row].vorousType == 1{
                cell.vorousTypeImage.image = #imageLiteral(resourceName: "NonVeg")
            }else{
                cell.vorousTypeImage.image = #imageLiteral(resourceName: "Veg")
            }
            cell.itemLbl.text = data.items[indexPath.row].name!
            cell.itemsLbl.text = "✕\(data.items[indexPath.row].quantity!)"
            cell.priceLbl.text =  "₹ \(data.items[indexPath.row].price!.toString)"
        }else{
            let data = schedule!
            if data.items[indexPath.row].vorousType == 2{
                cell.vorousTypeImage.image = #imageLiteral(resourceName: "NonVeg")
            }else{
                cell.vorousTypeImage.image = #imageLiteral(resourceName: "Veg")
            }
            cell.itemLbl.text = data.items[indexPath.row].name!
            cell.itemsLbl.text = "✕\(data.items[indexPath.row].quantity!)"
            cell.priceLbl.text =  "₹ \(data.items[indexPath.row].price!.toString)"
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
