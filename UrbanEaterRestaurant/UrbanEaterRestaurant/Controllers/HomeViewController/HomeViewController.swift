//
//  HomeViewController.swift
//  DriverReadyToEat
//
//  Created by casperonios on 10/11/17.
//  Copyright © 2017 CasperonTechnologies. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class HomeViewController: UIViewController {
    
    //After Designed Changed Outlets
    @IBOutlet weak var lastPaidEarningsLbl: UILabel!
    @IBOutlet weak var supportBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bookTblCollectionView: UICollectionView!
    @IBOutlet weak var earningsViewInView: UIView!
    @IBOutlet weak var onlineSwitch: UISwitch!
    @IBOutlet weak var slidetoOpenView: UIView!
    @IBOutlet weak var tblBookingViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var earningViewHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var onlineOptionsContainerView: UIView!
    @IBOutlet weak var earningsHeaderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableBookingsHeight: NSLayoutConstraint!
    @IBOutlet weak var tableBookingsHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var onlineSwitchHeight: NSLayoutConstraint!
    @IBOutlet weak var noDataAvailableLbl: UILabel!
    
    var mainTheme:Themes = Themes()
    var past7Dates = [String]()
    var past7Days = [String]()
    
    var onlineString:NSAttributedString{
        let attributeString = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Swipe right to come ", attr2Text: "Online", attr1Color: .secondaryTextColor, attr2Color: .textColor, attr1Font: UIDevice.isPhone() ? 14 : 18, attr2Font: UIDevice.isPhone() ? 16 : 20, attr1FontName: .Regular, attr2FontName: .Medium)
        return attributeString
    }
    var offlineString:NSAttributedString{
        let attributeString = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Swipe left to go ", attr2Text: "Offline", attr1Color: .secondaryTextColor, attr2Color: .textColor, attr1Font: UIDevice.isPhone() ? 14 : 18, attr2Font: UIDevice.isPhone() ? 16 : 20, attr1FontName: .Regular, attr2FontName: .Medium)
        return attributeString
    }
    
    lazy var slideToOpen: SlideToOpenView = {
        let slide = SlideToOpenView(frame: CGRect(x: 0, y: 0, width: self.slidetoOpenView.frame.size.width, height: self.slidetoOpenView.frame.size.height))
        slide.sliderViewTopDistance = 0
        slide.textLabelLeadingDistance = 40
        slide.sliderCornerRadious = self.slidetoOpenView.frame.size.height/2.0
        slide.defaultLabelAttributeText = onlineString
        slide.thumnailImageView.image = #imageLiteral(resourceName: "offline_switch").imageWithInsets(insetDimen: 5)
        slide.thumnailImageView.backgroundColor = .clear
        slide.draggedView.backgroundColor = .clear
        slide.draggedView.alpha = 0.8
        slide.delegate = self
        return slide
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.onlineOptionsContainerView.isHidden = true
        self.slidetoOpenView.isHidden = false
        self.onlineSwitch.isHidden = true
        past7Dates = Date.getDates(forLastNDays: 2).0 as [String]
        past7Days  =  Date.getDates(forLastNDays: 2).1 as [String]
        collectionView.register(UINib(nibName: "EarningsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EarningsCollectionViewCell")
        collectionView.register(UINib(nibName: "EarningsSeeAllACollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EarningsSeeAllACollectionViewCell")
        bookTblCollectionView.register(UINib(nibName: "DateCell", bundle: nil), forCellWithReuseIdentifier: "DateCell")
        bookTblCollectionView.register(UINib(nibName: "DateSeeAll", bundle: nil), forCellWithReuseIdentifier: "DateSeeAll")
        self.allocateCollectionView()
        ez.runThisInMainThread {
            if UIDevice.current.screenType == .iPhones_5_5s_5c_SE{
                self.earningViewHightConstraint.constant = 250
                self.earningsHeaderViewHeight.constant = 45
                self.tableBookingsHeight.constant = 110
                self.tableBookingsHeaderHeight.constant = 45
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "OrderReceived"), object: nil, userInfo: nil)
        self.getRestarentDataModel()
        self.updateUI()
    }
    //MARK:- Prepare For Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeSegue"{
            if let viewCon = segue.destination as? HomeOnlineOptionsView{
                viewCon.isFromHome = true
            }
        }
    }
    //MARK :- Collection View
    func allocateCollectionView(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: UIDevice.isPhone() ? 100 : 140, height: self.collectionView.frame.height)
        layout.minimumInteritemSpacing = UIDevice.isPhone() ? 5 : 10
        layout.minimumLineSpacing = UIDevice.isPhone() ? 5 : 10
        layout.scrollDirection = .horizontal
        collectionView!.collectionViewLayout = layout
        collectionView.tag = 111
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layoutBookTbl: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutBookTbl.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if UIDevice.current.screenType == .iPhones_5_5s_5c_SE{
            layoutBookTbl.itemSize = CGSize(width: 100, height: 50)
        }else{
            layoutBookTbl.itemSize = CGSize(width: UIDevice.isPhone() ? 100 : 150, height: UIDevice.isPhone() ? 60 : 80)
        }
        layoutBookTbl.minimumInteritemSpacing = UIDevice.isPhone() ? 5 : 10
        layoutBookTbl.minimumLineSpacing = UIDevice.isPhone() ? 5 : 10
        layoutBookTbl.scrollDirection = .horizontal
        bookTblCollectionView!.collectionViewLayout = layoutBookTbl
        bookTblCollectionView.tag = 222
        bookTblCollectionView.delegate = self
        bookTblCollectionView.dataSource = self
    }
    //MARK:- Update UI
    func updateUI(){
        self.noDataAvailableLbl.isHidden = true
        onlineSwitch.layer.cornerRadius = 16
        //self.collectionView.isHidden = true
        TheGlobalPoolManager.cornerAndBorder(self.earningsViewInView, cornerRadius: 8, borderWidth: 0.5, borderColor: .lightGray)
        TheGlobalPoolManager.cornerRadiusForParticularCornerr(self.earningsViewInView, corners: [.bottomRight,.topRight], size: CGSize(width: 8, height: 0))
        self.slidetoOpenView.addSubview(self.slideToOpen)
        self.slidetoOpenView.layer.cornerRadius = self.slidetoOpenView.frame.size.height/2.0
    }
    //MARK:- Get Restaurant  Data Api
    func getRestarentDataModel(){
        Themes.sharedInstance.activityView(View: self.view)
        let param = [ "id": GlobalClass.restaurantLoginModel.data.subId!]
        let header = [X_SESSION_ID : GlobalClass.restaurantLoginModel.data.sessionId!]
        URLhandler.postUrlSession(urlString: Constants.urls.getRestaurantDataURL, params: param as [String : AnyObject], header: header) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                GlobalClass.restModel = RestaurantHomeModel(fromJson: dataResponse.json)
                let data = GlobalClass.restModel.data
                if data?.available == 0{
                    ez.runThisInMainThread {
                        self.onlineSwitch.isOn = false
                        self.onlineOptionsContainerView.isHidden = true
                        self.slideToOpen.isFinished = false
                        self.slideToOpen.updateThumbnailViewLeadingPosition(0)
                        self.SlideToOpenChangeImage(self.slideToOpen, switchStatus: false)
                        self.supportBtn.isHidden = false
                    }
                }else{
                    ez.runThisInMainThread {
                        self.slideToOpen.isFinished = true
                        self.slideToOpen.updateThumbnailViewLeadingPosition(self.slideToOpen.xEndingPoint)
                        self.SlideToOpenChangeImage(self.slideToOpen, switchStatus: true)
                        self.onlineSwitch.isOn = true
                        self.onlineOptionsContainerView.isHidden = false
                        self.supportBtn.isHidden = true
                    }
                }
                if !TheGlobalPoolManager.isShow{
                    if data?.available == 1{
                        if data?.statIdData != nil{
                            if data?.statIdData.food.total != data?.statIdData.food.available!{
//                                TheGlobalPoolManager.showAlertWith(title: "Some items are still unavailable?", message: "\n Do you want to Manage?", singleAction: false, okTitle:"Yes", cancelTitle: "No") { (sucess) in
//                                    if sucess!{
//                                         TheGlobalPoolManager.isShow = true
//                                        let viewCon = self.storyboard?.instantiateViewController(withIdentifier: "FoodItemsVCID") as! FoodItemsViewController
//                                        self.navigationController?.pushViewController(viewCon, animated: true)
//                                    }else{
//                                        TheGlobalPoolManager.isShow = true
//                                    }
//                                }
                            }
                        }
                    }
                }
                if data?.earningIdData.count == 0{
                    self.noDataAvailableLbl.isHidden = false
                    self.collectionView.isHidden = true
                    self.collectionView.reloadData()
                }else{
                    self.collectionView.isHidden = false
                    self.noDataAvailableLbl.isHidden = true
                    self.collectionView.reloadData()
                }
            }
        }
    }   
    //MARK:- Chnage Restaurant Status Api
    func changeRestarentStatusWebHit(status:Int){
        let param = [
            "id": GlobalClass.restaurantLoginModel.data.subId,
            "available": status] as  [String:AnyObject]
        let header = [X_SESSION_ID : GlobalClass.restaurantLoginModel.data.sessionId!]
        URLhandler.postUrlSession(urlString: Constants.urls.UpdaterRestaurantData, params: param, header: header) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                Themes.sharedInstance.showToastView(dict.object(forKey: "message") as! String)
                self.getRestarentDataModel()
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func supportBtn(_ sender: UIButton) {
        self.pushingToSupportVC()
    }
    @IBAction func onlineOfflineSwitchValueChanged(sender: UISwitch) {
        var titleText : String = "Are you sure you want to Go"
        if sender.isOn {
            titleText = titleText + " Online?"
        }else{
            titleText = titleText + " Offline?"
        }
        TheGlobalPoolManager.showAlertWith(title: titleText, message: "", singleAction: false, okTitle:"Confirm") { (sucess) in
            if sucess!{
                let data = GlobalClass.restModel.data!
                if data.available == 0{
                    self.onlineSwitch.isOn = true
                    self.changeRestarentStatusWebHit(status: 1)
                }else{
                    self.onlineSwitch.isOn = false
                    self.changeRestarentStatusWebHit(status: 0)
                }
            }else{
                if sender.isOn{
                    self.onlineSwitch.isOn = false
                }else{
                    self.onlineSwitch.isOn = true
                }
            }
        }
    }
}
extension UIImage {
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
extension HomeViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  collectionView.tag == 111 {
            return  GlobalClass.restModel == nil ? 0 : GlobalClass.restModel.data.earningIdData.count + 1
        }
        return past7Dates.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { //
        if collectionView.tag == 111 {
            if indexPath.row == GlobalClass.restModel.data.earningIdData.count{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EarningsSeeAllACollectionViewCell", for: indexPath as IndexPath) as! EarningsSeeAllACollectionViewCell
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EarningsCollectionViewCell", for: indexPath as IndexPath) as! EarningsCollectionViewCell
            let data =  GlobalClass.restModel.data.earningIdData[indexPath.row]
            let weekday = Date.init(fromString: data.dateString!, format: "yyyy-MM-dd")?.dayOfWeek()!
            cell.dateLbl.text =  "\(weekday!)\n\(TheGlobalPoolManager.convertDateFormater(data.dateString!))"
            cell.ordersLbl.text = data.orderCount.toString
            cell.amountLbl.text = data.earnAmount.toString
            if data.billingStatus! == 0{
                cell.paidStatusLbl.backgroundColor = .themeColor
            }else{
                cell.paidStatusLbl.backgroundColor = .greenColor
            }
            return cell
        }else {
            if indexPath.row == past7Days.count{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateSeeAll", for: indexPath) as! DateSeeAll
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
            cell.daylbl.text = past7Days[indexPath.row]
            cell.dateLbl.text = TheGlobalPoolManager.convertDateFormater(past7Dates[indexPath.row])
            if UIDevice.current.screenType == .iPhones_5_5s_5c_SE{
                cell.daylbl.font = UIFont.appFont(.Medium, size: 12)
                cell.dateLbl.font = UIFont.appFont(.Regular, size: 12)
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 111{
            if indexPath.row == GlobalClass.restModel.data.earningIdData.count{
                self.pushingToEarningsVC("")
            }else{
                let data =  GlobalClass.restModel.data.earningIdData[indexPath.row]
                let dateString = data.dateString!
                self.pushingToEarningsVC(dateString)
            }
        }else{
            if indexPath.row  == past7Dates.count{
                self.pushingToOrderVC("")
            }else{
                self.pushingToOrderVC(past7Dates[indexPath.row])
            }
        }
    }
    //MARK: - Pushing to Order VC
    func pushingToOrderVC(_ dateString : String){
        if let viewCon = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrdersViewController") as? OrdersViewController {
            viewCon.hidesBottomBarWhenPushed = true
            viewCon.isFoodSelectedFlag = false
            viewCon.isScheduledTabSelected = true
            viewCon.selectedDate  = dateString
            self.navigationController?.pushViewController(viewCon, animated: true)
        }
    }
    //MARK: - Pushing to Earnings VC
    func pushingToEarningsVC(_ dateString : String){
        if let viewCon = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EarningSummuryVCID") as? EarningSummuryViewController {
            viewCon.hidesBottomBarWhenPushed = true
            viewCon.selectedDate  = dateString
            self.navigationController?.pushViewController(viewCon, animated: true)
        }
    }
    //MARK: - Pushing to Support VC
    func pushingToSupportVC(){
        if let viewCon = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HelpSupportVCID") as? HelpSupportViewController {
            viewCon.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewCon, animated: true)
        }
    }
}
extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}
extension HomeViewController : SlideToOpenDelegate{
    func SlideToOpenChangeImage(_ slider:SlideToOpenView, switchStatus: Bool){
        if switchStatus {
            slider.defaultLabelAttributeText = offlineString
            slider.thumnailImageView.image = #imageLiteral(resourceName: "online_switch").imageWithInsets(insetDimen: 15)
            slider.textLabelLeadingDistance = 0
        }else{
            slider.defaultLabelAttributeText = onlineString
            slider.thumnailImageView.image = #imageLiteral(resourceName: "offline_switch").imageWithInsets(insetDimen: 5)
            slider.textLabelLeadingDistance = 40
        }
    }
    func SlideToOpenDelegateDidFinish(_ slider:SlideToOpenView, switchStatus: Bool) {
        var titleText : String = "Are you sure you want to Go"
        if switchStatus {
            titleText = titleText + " Online?"
           //TheGlobalPoolManager.isShow = false
            ez.runThisInMainThread {
                if let model = GlobalClass.restModel{
                    let data = model.data!
                    if data.available == 0{
                        self.SlideToOpenChangeImage(self.slideToOpen, switchStatus: true)
                        self.onlineSwitch.isOn = true
                        self.changeRestarentStatusWebHit(status: 1)
                    }else{
                        self.SlideToOpenChangeImage(self.slideToOpen, switchStatus: false)
                        self.onlineSwitch.isOn = false
                        self.changeRestarentStatusWebHit(status: 0)
                    }
                }
            }
        }else{
            titleText = titleText + " Offline?"
            TheGlobalPoolManager.showAlertWith(title: "\(titleText)", message: "", singleAction: false, okTitle:"Confirm") { (sucess) in
                if sucess!{
                    if let model = GlobalClass.restModel{
                        let data = model.data!
                        if data.available == 0{
                            self.SlideToOpenChangeImage(self.slideToOpen, switchStatus: true)
                            self.onlineSwitch.isOn = true
                            self.changeRestarentStatusWebHit(status: 1)
                        }else{
                            self.SlideToOpenChangeImage(self.slideToOpen, switchStatus: false)
                            self.onlineSwitch.isOn = false
                            self.changeRestarentStatusWebHit(status: 0)
                        }
                    }
                }else{
                    if switchStatus{
                        self.onlineSwitch.isOn = false
                        self.SlideToOpenChangeImage(self.slideToOpen, switchStatus: false)
                        self.slideToOpen.updateThumbnailViewLeadingPosition(0)
                        self.slideToOpen.isFinished = false
                    }else{
                        self.SlideToOpenChangeImage(self.slideToOpen, switchStatus: true)
                        self.onlineSwitch.isOn = true
                        self.slideToOpen.updateThumbnailViewLeadingPosition(self.slideToOpen.xEndingPoint)
                        self.slideToOpen.isFinished = true
                    }
                }
            }
        }
    }
}

