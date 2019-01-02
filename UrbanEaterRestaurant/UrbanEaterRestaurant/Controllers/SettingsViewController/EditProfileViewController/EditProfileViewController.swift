//
//  EditProfileViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 27/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit
import SDWebImage

class EditProfileViewController: UIViewController {
    @IBOutlet weak var profilePicImgView: UIImageView!
    @IBOutlet weak var offerBtn: UIButton!
    @IBOutlet weak var offerTypeBtn: UIButton!
    @IBOutlet weak var offersViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollviewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var cuisineTxt: UITextField!
    @IBOutlet weak var phoneNumberTxt: UITextField!
    @IBOutlet weak var ownerTxt: UITextField!
    
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var localityTxt: UITextField!
    @IBOutlet weak var flotNoTxt: UITextField!
    @IBOutlet weak var landmarkTxt: UITextField!
    @IBOutlet weak var offerAmtTxt: UITextField!
    @IBOutlet weak var targetAmtTxt: UITextField!
    @IBOutlet weak var maxOffAmtTxt: UITextField!
    var editProfileParams:EditProfileParameters!
    
    var isOffersExpanded = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if let value = GlobalClass.restModel{
            print("value ---->>",value)
            self.updateUI()
        }else{
            getRestarentProfile()
        }
    }
    func getRestarentProfile(){
        Themes.sharedInstance.activityView(View: self.view)
        let param = ["id": GlobalClass.restaurantLoginModel.data.subId!]
        URLhandler.postUrlSession(urlString: Constants.urls.getRestaurantDataURL, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                GlobalClass.restModel = RestaurantHomeModel(fromJson: dataResponse.json)
                self.updateUI()
            }
        }
    }
    //MARK:- Update UI
    func updateUI(){
        let restarent = GlobalClass.restModel!
        let sourceString = restarent.data.logo!.contains("http", compareOption: .caseInsensitive) ? restarent.data.logo! : Constants.BASEURL_IMAGE + restarent.data.logo!
        let logoUrl = NSURL(string:sourceString)!
        self.profilePicImgView.sd_setImage(with: logoUrl as URL, placeholderImage: #imageLiteral(resourceName: "PlaceHolderImage"), options: .cacheMemoryOnly, completed: nil)
        self.nameTxt.text = restarent.data.name!
        self.cuisineTxt.text = restarent.data.cuisineIdData[0].name!
        self.phoneNumberTxt.text = restarent.data.phone.code! + "-" + restarent.data.phone.number!
        self.ownerTxt.text = restarent.data.userName!
        
        self.addressTxt.text = restarent.data.address.line1!
        self.localityTxt.text = restarent.data.address.line2!
        self.flotNoTxt.text = restarent.data.address.city!
        self.landmarkTxt.text = restarent.data.address.state!
        
        self.offerTypeBtn.setTitle(restarent.data.offer.type!, for: .normal)
        self.targetAmtTxt.text = String(restarent.data.offer.value!)
        self.offerAmtTxt.text = String(restarent.data.offer.minAmount!)
        self.maxOffAmtTxt.text = String(restarent.data.offer.maxDiscountAmount!)
    }
    func updateProfile(){
        let restarentInfo = UserDefaults.standard.object(forKey: "restaurantInfo") as! NSDictionary
        let data = restarentInfo.object(forKey: "data") as! NSDictionary
        
        self.editProfileParams = EditProfileParameters.init(id: data.object(forKey: "subId") as! String, name: nameTxt.text!, userName: ownerTxt.text!, address: addressTxt.text!, locality: localityTxt.text!, city: flotNoTxt.text!, state: landmarkTxt.text!, mobileNumber: phoneNumberTxt.text!, offerType: (self.offerTypeBtn.titleLabel?.text!)!, value: Int(targetAmtTxt.text!)!, minAmount: Int(offerAmtTxt.text!)!, MaxDiscountAmt: Int(maxOffAmtTxt.text!)!)
        
        URLhandler.postUrlSession(urlString: Constants.urls.businessHourUrl, params: self.editProfileParams.parameters, header: [:]) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                Themes.sharedInstance.showToastView(dict.object(forKey: "message") as! String)
                self.getRestarentProfile()
            }
        }
    }
     //MARK:- IB Action Outlets
    @IBAction func profilePicButtonClicked(_ sender: Any) {
    }
    @IBAction func saveBtnClicked(sender: UIButton) {
        self.updateProfile()
    }
    @IBAction func offersButtonClicked(_ sender: Any) {
        if isOffersExpanded {
            isOffersExpanded = false
            offersViewHeightConstraint.constant = 0
            scrollviewHeightConstraint.constant = 800
        }else{
            isOffersExpanded = true
            offersViewHeightConstraint.constant = 310
            scrollviewHeightConstraint.constant = 1100
            _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.goNext(timer:)), userInfo: nil, repeats: false)
        }
    }
    @objc func goNext(timer:Timer){
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
        scrollView.setContentOffset(bottomOffset, animated: true)
    }
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
class EditProfileParameters{
    var id:String!
    var name:String!
    var userName:String!
    var address = [String:AnyObject]()
    var phone = [String:AnyObject]()
    var offer = [String:AnyObject]()
    
    var parameters = [String:AnyObject]()
    
    init( id:String, name:String, userName:String, address:String, locality:String, city:String, state:String, mobileNumber:String, offerType:String, value:Int, minAmount:Int,MaxDiscountAmt:Int) {
        self.id = id
        self.name = name
        self.userName = userName
        let fullAddress = address + "," + locality
        self.address =  [
            "line1": address,
            "line2": locality,
            "city": city,
            "state": state,
            "country": "India",
            "zipcode": "50008",
            "fulladdress": fullAddress
            ] as [String : AnyObject]
        
        self.phone = [
            "code": "91",
            "number": mobileNumber
            ] as [String : AnyObject]
        
        self.offer = [
            "type": offerType,
            "value": value,
            "minAmount": minAmount,
            "maxDiscountAmount": MaxDiscountAmt,
            "status": 1
            ] as [String:AnyObject]
        
        parameters = ["id":self.id,
                      "name":self.name,
                      "userName":self.userName,
                      "phone":self.phone,
                      "address":self.address,
                      "offer":self.offer] as [String : AnyObject]
    }
}
