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
        
        if isComingFromHome{
            self.orderIDLbl.text = scheduledFromHome.order[0].subOrderId!
            self.driverIDLbl.text = scheduledFromHome.order[0].code!
            self.priceLbl.text = "₹ \(scheduledFromHome.order[0].billing.orderTotal!.toString)"
        }else{
            self.orderIDLbl.text = schedule.order[0].subOrderId!
            self.driverIDLbl.text = schedule.order[0].code!
            self.priceLbl.text = "₹ \(schedule.order[0].billing.orderTotal!.toString)"
        }
    }
    @IBAction func doneBtn(_ sender: UIButton) {
    }
}
extension ItemsDetailView : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return schedule.items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemsDetailCell", for: indexPath as IndexPath) as! ItemsDetailCell
        if isComingFromHome{
            let data = scheduledFromHome!
            if data.items[indexPath.row].vorousType == 2{
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
