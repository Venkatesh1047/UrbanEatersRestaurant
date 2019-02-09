//
//  AddFoodViewController.swift
//  UrbanEaterRestaurant
//
//  Created by Vamsi on 05/02/19.
//  Copyright © 2019 Nagaraju. All rights reserved.
//

import UIKit
import PopOverMenu
import EZSwiftExtensions
import UserNotifications

class AddFoodViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAdaptivePresentationControllerDelegate,UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var selectCategoryTF: UITextField!
    @IBOutlet weak var enterFoodNameTF: UITextField!
    @IBOutlet weak var vegBtn: UIButton!
    @IBOutlet weak var nonVegBtn: UIButton!
    @IBOutlet weak var actualPriceTF: UITextField!
    @IBOutlet weak var discountTF: UITextField!
    @IBOutlet weak var avaialbleBtn: UIButton!
    @IBOutlet weak var unavailableBtn: UIButton!
    @IBOutlet weak var foodItemImageView: UIImageView!
    @IBOutlet weak var choosePhotoBtn: UIButton!
    @IBOutlet weak var takePhotoBtn: UIButton!
    @IBOutlet weak var recommendedSwitch: UISwitch!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var selectCategoryBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    
    var selectedImage :UIImage!
    var selectedImageBase64String : String = ""
    var vorousType : Int!
    var recommendedType : Int! = 0
    var mainCategoryID : String!
    let popOverViewController = PopOverViewController.instantiate()
    var categories = [String]()
    var isComingFromEdit : Bool = false
    var editItemData : ManageCategoriesItemList!
    var discountStatus : Int = 0
    var availableStatus : Int!
    var categoryName : String!
    var nextAvailableTime : String = ""
    var imageString : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        if !isComingFromEdit{
            self.titleLbl.text = "Add Food"
            self.unavailableBtn.isEnabled = false
            self.unavailableBtn.setBackgroundColor(.lightGray, forState: .normal)
            self.recommendedSwitch.isOn = false
        }else{
            self.titleLbl.text = "Edit Food"
            if let data = editItemData{
                GlobalClass.selectedFromTime = data.timings.startAt!
                GlobalClass.selectedToTime = data.timings.endAt!
                self.selectedImageBase64String = data.avatar!
                self.vorousType = data.vorousType!
                self.recommendedType = data.recommended!
                self.availableStatus = data.available!
                self.mainCategoryID = data.mainCategoryId!
                self.discountStatus = data.offer.status!
                self.selectCategoryTF.text = self.categoryName
                self.enterFoodNameTF.text = data.name!
                self.imageString = data.avatar!
                self.nextAvailableTime = data.nextAvailableTime!
                if data.vorousType! == 1{
                    self.vorousTypeBtns(vegBtn)
                }else{
                     self.vorousTypeBtns(nonVegBtn)
                }
                self.actualPriceTF.text = data.price!.toString
                self.discountTF.text = data.offer.value!.toString
                if data.available! == 0{
                    let un_available   = unavailableBtn == unavailableBtn ?   #colorLiteral(red: 0.9529411765, green: 0.7529411765, blue: 0.1843137255, alpha: 1) : #colorLiteral(red: 0.2509803922, green: 0.2901960784, blue: 0.4078431373, alpha: 1)
                    self.unavailableBtn.backgroundColor = un_available
                }else{
                    let available   = avaialbleBtn == avaialbleBtn ?   #colorLiteral(red: 0.9529411765, green: 0.7529411765, blue: 0.1843137255, alpha: 1) : #colorLiteral(red: 0.2509803922, green: 0.2901960784, blue: 0.4078431373, alpha: 1)
                    self.avaialbleBtn.backgroundColor = available
                }
                if data.recommended! == 0{
                    self.recommendedType = 0
                    self.recommendedSwitch.isOn = false
                }else{
                    self.recommendedType = 1
                    self.recommendedSwitch.isOn = true
                }
                let sourceString = data.avatar!.contains("http", compareOption: .caseInsensitive) ? data.avatar! : Constants.BASEURL_IMAGE + data.avatar!
                let url = URL.init(string: sourceString)
                self.foodItemImageView.sd_setImage(with: url ,placeholderImage:  #imageLiteral(resourceName: "PlaceHolderImage")) { (image, error, cache, url) in
                    if error != nil{
                    }else{
                        self.foodItemImageView.image = image
                    }
                }
            }
        }
        recommendedSwitch.onTintColor = .themeColor
        recommendedSwitch.tintColor = .secondaryBGColor
        recommendedSwitch.backgroundColor = .secondaryBGColor
        recommendedSwitch.layer.cornerRadius = recommendedSwitch.bounds.height / 2
        if let categories = GlobalClass.manageCategoriesModel.data{
            for data in categories{
                self.categories.append(data.name!)
            }
        }
        self.enterFoodNameTF.setBottomBorder()
        self.vegBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35 ,cornerRadius : 10)
        self.nonVegBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35 ,cornerRadius : 10)
        TheGlobalPoolManager.cornerAndBorder(self.actualPriceTF, cornerRadius: 10, borderWidth: 1, borderColor: .lightGray)
        TheGlobalPoolManager.cornerAndBorder(self.discountTF, cornerRadius: 10, borderWidth: 1, borderColor: .lightGray)
        TheGlobalPoolManager.cornerAndBorder(self.avaialbleBtn, cornerRadius: 10, borderWidth: 0, borderColor: .clear)
        TheGlobalPoolManager.cornerAndBorder(self.unavailableBtn, cornerRadius: 10, borderWidth: 0, borderColor: .clear)
        TheGlobalPoolManager.cornerAndBorder(self.choosePhotoBtn, cornerRadius: 10, borderWidth: 0, borderColor: .clear)
        TheGlobalPoolManager.cornerAndBorder(self.takePhotoBtn, cornerRadius: 10, borderWidth: 0, borderColor: .clear)
        TheGlobalPoolManager.cornerAndBorder(self.foodItemImageView, cornerRadius: 10, borderWidth: 0, borderColor: .clear)
    }
    // MARK: - Image picker from gallery and camera
    private func imagePicker(clickedButtonat buttonIndex: Int) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        switch buttonIndex {
        case 0:
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                picker.sourceType = .camera
                present(picker, animated: true, completion: nil)
            }
            else{
                print("Camera not available....")
            }
        case 1:
            picker.sourceType = .photoLibrary
            present(picker, animated: true, completion:nil)
        default:
            break
        }
    }
    // MARK: - UIImagePickerController delegate methods
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImage = image
        }else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = image
        }else{
            print("Something went wrong")
        }
        convertImage(image: selectedImage)
        print(selectedImage)
        foodItemImageView.image = selectedImage
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func convertImage(image: UIImage) {
        let imageData = UIImageJPEGRepresentation(image, 0.1)! as NSData
        let dataString = imageData.base64EncodedString()
        selectedImageBase64String = dataString
        print(" *************** Base 64 String =========\(selectedImageBase64String)")
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    //MARK:- Drop Down
    @objc func dropDownMethod(_ btn :UIButton, array : [String]){
        //POP MENU
        self.popOverViewController.setTitles(array)
        self.popOverViewController.setSeparatorStyle(UITableViewCellSeparatorStyle.singleLine)
        self.popOverViewController.popoverPresentationController?.sourceView = btn
        self.popOverViewController.popoverPresentationController?.sourceRect = btn.bounds
        self.popOverViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        self.popOverViewController.preferredContentSize = CGSize(width: 150, height:180)
        self.popOverViewController.presentationController?.delegate = self
        ez.runThisInMainThread {
            self.popOverViewController.completionHandler = { selectRow in
                self.selectCategoryTF.text = GlobalClass.manageCategoriesModel.data[selectRow].name!
                self.mainCategoryID = GlobalClass.manageCategoriesModel.data[selectRow].categoryId!
            }
        }
        self.present(self.popOverViewController, animated: true, completion: nil)
    }
    //MARK:- Validate
    func validate() -> Bool{
        if self.selectCategoryTF.text?.length == 0{
            TheGlobalPoolManager.showToastView("Please select Category")
            return false
        }else  if self.enterFoodNameTF.text?.length == 0{
            TheGlobalPoolManager.showToastView("Please enter food name")
            return false
        }else  if self.vorousType == nil{
            TheGlobalPoolManager.showToastView("Please select Non-Veg or Veg")
            return false
        }else  if self.actualPriceTF.text?.length == 0{
            TheGlobalPoolManager.showToastView("Please provide actual price")
            return false
        }else if self.selectedImageBase64String == ""{
            TheGlobalPoolManager.showToastView("Please provide food image for customers")
            return false
        }else if self.availableStatus == nil{
            TheGlobalPoolManager.showToastView("Please provide available timings")
            return false
        }
        return true
    }
    //MARK:- Create Food Api
    func createFoodApi(){
        Themes.sharedInstance.activityView(View: self.view)
        if !isComingFromEdit{
            self.imageString = ""
        }
        var param = [String:AnyObject]()
         param = [
            "name": self.enterFoodNameTF.text!,
            "description": self.enterFoodNameTF.text!,
            "avatar": self.imageString,
            "restaurantId": GlobalClass.restaurantLoginModel.data.subId!,
            "price": self.actualPriceTF.text!.toDouble() as AnyObject,
            "vorousType": self.vorousType!,
            "timings": [
                "startAt": GlobalClass.selectedFromTime!,
                "endAt": GlobalClass.selectedToTime!,
                "status": 1
            ],
            "offer": [
                "type": "PERCENTAGE",
                "value": self.discountTF.text!.toInt() as AnyObject,
                "status": self.discountStatus
            ],
            "mainCategoryId": self.mainCategoryID!,
            "categoryId": [self.mainCategoryID!],
            "default": "",
            "available": 1,
            "recommended":self.recommendedType!,
            "nextAvailableTime": self.nextAvailableTime,
            "status": 1
            ] as [String : AnyObject]
        
        if isComingFromEdit{
            param["id"] =  editItemData.itemId! as AnyObject
        }
        
        let header = [X_SESSION_ID : GlobalClass.restaurantLoginModel.data.sessionId!]
        URLhandler.postUrlSession(urlString: self.isComingFromEdit ? Constants.urls.Food_Update_ID : Constants.urls.Create_Food, params: param, header: header) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            print(dataResponse.json)
            if dataResponse.json.exists(){
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    func setUnavailable(_ itemID: String ,  itemName : String ) {
        let titleText = [NSAttributedStringKey.font : UIFont.appFont(.Medium, size: 16), NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)] as [NSAttributedStringKey : Any]
        let titleAttributed = NSMutableAttributedString(string: "\(itemName) Unavailable ...", attributes:titleText)
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let firstAction: UIAlertAction = UIAlertAction(title: "Upto 1 Hour", style: .default) { action -> Void in
            let dateString = Date().adding(minutes: 60)
            let body = itemName + " was unavailable since 1 hour"
            let identifier = itemID
            let timeInterval = dateString.2.timeIntervalSinceNow
            self.cancelScheduleNotification(identifier)
            self.scheduleLocalNotification(body, identifier: identifier, timeInterval: timeInterval)
            self.availableStatus = 0
            self.nextAvailableTime = dateString.0
        }
        let secondAction: UIAlertAction = UIAlertAction(title: "Upto 4 Hours", style: .default) { action -> Void in
            let dateString = Date().adding(minutes: 240)
            let body = itemName + " was unavailable since 4 hours"
            let identifier = itemID
            let timeInterval = dateString.2.timeIntervalSinceNow
            self.cancelScheduleNotification(identifier)
            self.scheduleLocalNotification(body, identifier: identifier, timeInterval: timeInterval)
            self.availableStatus = 0
            self.nextAvailableTime = dateString.0
        }
        let thirdAction: UIAlertAction = UIAlertAction(title: "Upto 8 Hours", style: .default) { action -> Void in
            let dateString = Date().adding(minutes: 480)
            let body = itemName + " was unavailable since 8 hours"
            let identifier = itemID
            let timeInterval = dateString.2.timeIntervalSinceNow
            self.cancelScheduleNotification(identifier)
            self.scheduleLocalNotification(body, identifier: identifier, timeInterval: timeInterval)
            self.availableStatus = 0
            self.nextAvailableTime = dateString.0
        }
        let fourthAction: UIAlertAction = UIAlertAction(title: "Next Start Time", style: .default) { action -> Void in
            var timeString = GlobalClass.restModel.data.timings.weekDay.startAt
            if Date().weekday.lowercased() == "friday" || Date().weekday.lowercased() == "saturday"{
                timeString = GlobalClass.restModel.data.timings.weekEnd.startAt
            }
            let dateString = Date().addingOneDayExtra(timeString!)
            let body = itemName + " was unavailable since Yesterday"
            let identifier = itemID
            let timeInterval = dateString.1.timeIntervalSinceNow
            self.cancelScheduleNotification(identifier)
            self.scheduleLocalNotification(body, identifier: identifier, timeInterval: timeInterval)
            self.availableStatus = 0
            self.nextAvailableTime = dateString.0
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(thirdAction)
        actionSheetController.addAction(fourthAction)
        actionSheetController.addAction(cancelAction)
        actionSheetController.setValue(titleAttributed, forKey : "attributedTitle")
        if UIDevice.current.userInterfaceIdiom == .pad {
            print("IPAD")
            actionSheetController.modalPresentationStyle = .popover
            let popover = actionSheetController.popoverPresentationController!
            popover.delegate = self
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
            self.present(actionSheetController, animated: true, completion: nil )
        }
        else if UIDevice.current.userInterfaceIdiom == .phone{
            print("IPHONE")
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    func setAvailable(_ itemID: String ,  itemName : String ) {
        let titleText = [NSAttributedStringKey.font : UIFont.appFont(.Medium, size: 16), NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)] as [NSAttributedStringKey : Any]
        let titleAttributed = NSMutableAttributedString(string: "\(itemName) Unavailable ...", attributes:titleText)
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let firstAction: UIAlertAction = UIAlertAction(title: "Change Unavailable Time", style: .default) { action -> Void in
            self.availableStatus = 1
            self.nextAvailableTime = ""
            self.setUnavailable(self.editItemData.itemId!, itemName: self.editItemData.name!)
        }
        let secondAction: UIAlertAction = UIAlertAction(title: "Available This Item", style: .default) { action -> Void in
            self.cancelScheduleNotification(itemID)
            self.availableStatus = 1
            self.nextAvailableTime = ""
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)
        actionSheetController.setValue(titleAttributed, forKey : "attributedTitle")
        if UIDevice.current.userInterfaceIdiom == .pad {
            print("IPAD")
            actionSheetController.modalPresentationStyle = .popover
            let popover = actionSheetController.popoverPresentationController!
            popover.delegate = self
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
            self.present(actionSheetController, animated: true, completion: nil )
        }
        else if UIDevice.current.userInterfaceIdiom == .phone{
            print("IPHONE")
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    func scheduleLocalNotification(_ body:String, identifier:String, timeInterval:TimeInterval){
        let content = UNMutableNotificationContent()
        content.title = "Manage UnAvailable Item"
        content.body = body
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    func cancelScheduleNotification(_ identifier:String){
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == identifier {
                    identifiers.append(notification.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func vorousTypeBtns(_ sender: UIButton) {
        let veg   = vegBtn == sender ?   #colorLiteral(red: 0.9529411765, green: 0.7529411765, blue: 0.1843137255, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let non_veg   = nonVegBtn == sender ?   #colorLiteral(red: 0.9529411765, green: 0.7529411765, blue: 0.1843137255, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        vegBtn.backgroundColor = veg
        nonVegBtn.backgroundColor = non_veg
        if sender == vegBtn{
            print("Veg Button")
            vorousType = 1
        }else{
           print("Non-Veg Button")
            vorousType = 2
        }
    }
    @IBAction func availableStatusBtns(_ sender: UIButton) {
        let available   = avaialbleBtn == sender ?   #colorLiteral(red: 0.9529411765, green: 0.7529411765, blue: 0.1843137255, alpha: 1) : #colorLiteral(red: 0.2509803922, green: 0.2901960784, blue: 0.4078431373, alpha: 1)
        let un_available   = unavailableBtn == sender ?   #colorLiteral(red: 0.9529411765, green: 0.7529411765, blue: 0.1843137255, alpha: 1) : #colorLiteral(red: 0.2509803922, green: 0.2901960784, blue: 0.4078431373, alpha: 1)
        if sender == avaialbleBtn{
            print("Available Button")
            if isComingFromEdit{
                self.setAvailable(editItemData.itemId!, itemName: editItemData.name!)
            }else{
                availableStatus = 1
                let viewCon = self.storyboard?.instantiateViewController(withIdentifier: "ChooseTimingsViewController") as! ChooseTimingsViewController
                self.navigationController?.pushViewController(viewCon, animated: true)
            }
        }else{
            if !isComingFromEdit{
                availableStatus = 0
                TheGlobalPoolManager.showToastView("Sorry, Not possible while adding new item.")
                return
            }
            print("Un-Available Button")
            self.setUnavailable(editItemData.itemId!, itemName: editItemData.name!)
        }
        self.avaialbleBtn.backgroundColor = available
        self.unavailableBtn.backgroundColor = un_available
    }
    @IBAction func selectCategoryBtns(_ sender: UIButton) {
        if sender == selectCategoryBtn{
            self.dropDownMethod(sender, array: self.categories)
        }
    }
    @IBAction func recommendedSwitch(_ sender: UISwitch) {
        if sender.isOn{
            self.recommendedType = 1
        }else{
            self.recommendedType = 0
        }
    }
    @IBAction func saveBtn(_ sender: UIButton) {
        if validate(){
            if self.discountTF.text?.length == 0{
                self.discountTF.text = ""
                self.discountStatus = 0
            }else{
                self.discountStatus = 1
            }
            self.createFoodApi()
        }
    }
    @IBAction func choosePhotoBtn(_ sender: UIButton) {
         self.imagePicker(clickedButtonat: 1)
    }
    @IBAction func takePhotoBtn(_ sender: UIButton) {
         self.imagePicker(clickedButtonat: 0)
    }
}
