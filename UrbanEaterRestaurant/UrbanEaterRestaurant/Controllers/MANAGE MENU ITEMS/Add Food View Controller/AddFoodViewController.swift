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
    @IBOutlet weak var foodItemImageView: UIImageView!
    @IBOutlet weak var choosePhotoBtn: UIButton!
    @IBOutlet weak var takePhotoBtn: UIButton!
    @IBOutlet weak var recommendedSwitch: UISwitch!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var selectCategoryBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var availableBgView: UIView!
    @IBOutlet weak var setAvailablityTF: UITextField!
    
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
    var categoryName : String!
    var imageString : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        GlobalClass.selectedFromTime = nil
        GlobalClass.selectedToTime = nil
    }
    override func viewWillAppear(_ animated: Bool) {
         self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        self.setAvailablityTF.isUserInteractionEnabled = false
        if !isComingFromEdit{
            self.titleLbl.text = "Add Food"
            self.recommendedSwitch.isOn = false
            if GlobalClass.selectedFromTime  != nil{
                self.setAvailablityTF.text = "Change Availability Time: \(GlobalClass.selectedFromTime!) to \(GlobalClass.selectedToTime!)"
            }else{
                self.setAvailablityTF.text = "Set Availability Time:"
            }
        }else{
            self.titleLbl.text = "Edit Food"
            if let data = editItemData{
                GlobalClass.selectedFromTime = data.timings.startAt!
                GlobalClass.selectedToTime = data.timings.endAt!
                self.selectedImageBase64String = data.avatar!
                self.vorousType = data.vorousType!
                self.recommendedType = data.recommended!
                self.mainCategoryID = data.mainCategoryId!
                self.discountStatus = data.offer.status!
                self.selectCategoryTF.text = self.categoryName
                self.enterFoodNameTF.text = data.name!
                self.imageString = data.avatar!
                self.setAvailablityTF.text = "Change Availability Time: \(GlobalClass.selectedFromTime!) to \(GlobalClass.selectedToTime!)"
                if data.vorousType! == 1{
                    self.vorousTypeBtns(vegBtn)
                }else{
                    self.vorousTypeBtns(nonVegBtn)
                }
                self.actualPriceTF.text = data.price!.toString
                self.discountTF.text = data.offer.value!.toString
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
        TheGlobalPoolManager.cornerAndBorder(availableBgView, cornerRadius: 10, borderWidth: 1, borderColor: .lightGray)
        TheGlobalPoolManager.cornerAndBorder(self.actualPriceTF, cornerRadius: 10, borderWidth: 1, borderColor: .lightGray)
        TheGlobalPoolManager.cornerAndBorder(self.discountTF, cornerRadius: 10, borderWidth: 1, borderColor: .lightGray)
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
        }else if GlobalClass.selectedFromTime == nil{
            TheGlobalPoolManager.showToastView("Invalid Start Timing")
            return false
        }else if GlobalClass.selectedToTime == nil{
            TheGlobalPoolManager.showToastView("Invalid End Timing")
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
            "recommended":self.recommendedType!,
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
        let viewCon = self.storyboard?.instantiateViewController(withIdentifier: "ChooseTimingsViewController") as! ChooseTimingsViewController
        self.navigationController?.pushViewController(viewCon, animated: true)
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
