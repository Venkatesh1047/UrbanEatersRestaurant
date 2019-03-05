//
//  BusinessHoursViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 24/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class BusinessHoursViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var weekDaysView: UIView!
    @IBOutlet weak var weekEndsView: UIView!
    @IBOutlet weak var dateView1: UIView!
    @IBOutlet weak var dateView2: UIView!
    @IBOutlet weak var dateView3: UIView!
    @IBOutlet weak var dateView4: UIView!
    @IBOutlet weak var minutesBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var minutesBgView: ShadowView!
    @IBOutlet weak var minLbl: UILabel!
    
    @IBOutlet weak var weekDayFromLbl: UILabel!
    @IBOutlet weak var weekDayToLbl: UILabel!
    @IBOutlet weak var weekEndFromLbl: UILabel!
    @IBOutlet weak var weekEndToLbl: UILabel!
    
    @IBOutlet weak var dateContainerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var minutesPicker: UIPickerView!
    @IBOutlet weak var minutesContainerView: UIView!
    
    @IBOutlet var dropDownBtns: [UIButton]!
    var btnTag = 0
    var gradePickerValues = ["15","20","25","30","35","40"]
    var dateSelectedString = ""
    var minutesSelectedString = ""
    let dateFormatter = DateFormatter()
    var businessHoursParams:BusinessHourParameters!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        for i in 0..<60 {
//            gradePickerValues.append(String(i))
//        }
        for btn in dropDownBtns{
            btn.setImage(#imageLiteral(resourceName: "Drop_Down").withColor(.whiteColor), for: .normal)
        }
        weekDaysView.layer.cornerRadius = 5.0
        weekEndsView.layer.cornerRadius = 5.0
        
        dateView1.customiseView()
        dateView2.customiseView()
        dateView3.customiseView()
        dateView4.customiseView()
        
        ez.runThisInMainThread {
            TheGlobalPoolManager.cornerAndBorder(self.saveBtn, cornerRadius: 5, borderWidth: 0, borderColor: .clear)
            TheGlobalPoolManager.cornerAndBorder(self.minutesBgView, cornerRadius: self.minutesBgView.layer.bounds.h/2, borderWidth: 0, borderColor: .clear)
        }
        datePicker.datePickerMode = UIDatePickerMode.time
        dateFormatter.dateFormat = "HH:mm a"
        datePicker.locale = Locale(identifier: "en_GB")
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        minutesPicker.dataSource = self
        minutesPicker.delegate = self
        if let restModel = GlobalClass.restModel{
            self.updateUI()
        }else{
            self.getRestarentProfile()
        }
    }
    func getRestarentProfile(){
        Themes.sharedInstance.activityView(View: self.view)
        let param = [ "id": GlobalClass.restaurantLoginModel.data.subId!]
        let header = [X_SESSION_ID : GlobalClass.restaurantLoginModel.data.sessionId!]
        URLhandler.postUrlSession(urlString: Constants.urls.getRestaurantDataURL, params: param as [String : AnyObject], header: header) { (dataResponse) in
             Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                GlobalClass.restModel = RestaurantHomeModel(fromJson: dataResponse.json)
                self.updateUI()
            }
        }
    }
    func updateUI(){
        if let restModel = GlobalClass.restModel{
            if let restData = restModel.data{
                if let timings = restData.timings{
                    self.weekDayFromLbl.text = timings.weekDay.startAt!
                    self.weekDayToLbl.text = timings.weekDay.endAt!
                    self.weekEndFromLbl.text = timings.weekEnd.startAt!
                    self.weekEndToLbl.text = timings.weekEnd.endAt!
                    self.minutesSelectedString = String(restData.deliveryTime!)
                    self.minLbl.text = "\(minutesSelectedString) min"
                }
            }
        }
    }
    
    func validateInputs(){
        let delivaryTime = minutesBtn.titleLabel?.text
        if TheGlobalPoolManager.trimString(string: self.weekDayFromLbl.text!) == "" {
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.WEEKDAY_START_TIME_EMPTY)
        }else if TheGlobalPoolManager.trimString(string: self.weekDayToLbl.text!) == "" {
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.WEEKDAY_END_TIME_EMPTY)
        }else if TheGlobalPoolManager.trimString(string: self.weekEndFromLbl.text!) == "" {
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.WEEKEND_START_TIME_EMPTY)
        }else if TheGlobalPoolManager.trimString(string: self.weekEndToLbl.text!) == "" {
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.WEEKEND_END_TIME_EMPTY)
        }else if delivaryTime == "" {
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.DELIVARY_TIME_EMPTY)
        }else{
            updateBusinessHoursWebHit()
        }
    }
    func updateBusinessHoursWebHit(){
        Themes.sharedInstance.activityView(View: self.view)
        let restarentInfo = UserDefaults.standard.object(forKey: RESTAURANT_INFO) as! NSDictionary
        let data = restarentInfo.object(forKey: DATA) as! NSDictionary
        self.businessHoursParams = BusinessHourParameters.init(data.object(forKey: SUB_ID) as! String, deliveryTime: Int(minutesSelectedString)!, weekday_startAt: weekDayFromLbl.text!, weekday_endAt: weekDayToLbl.text!, weekend_startAt: weekEndFromLbl.text!, weekend_endAt: weekEndToLbl.text!)
        let header = [X_SESSION_ID : GlobalClass.restaurantLoginModel.data.sessionId!]
        URLhandler.postUrlSession(urlString: Constants.urls.UpdaterRestaurantData, params: self.businessHoursParams.parameters, header: header) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                Themes.sharedInstance.showToastView(dict.object(forKey: "message") as! String)
                self.getRestarentProfile()
            }
        }
    }
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        sender.locale = Locale(identifier: "en_GB")
        sender.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "HH:mm a"
        dateSelectedString = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func timeChangeBtnClicked(_ sender: UIButton) {
        btnTag = sender.tag
        dateContainerView.isHidden = false
        blurView.isHidden = false
    }
    
    @IBAction func datePickDoneClicked(_ sender: Any) {
        dateContainerView.isHidden = true
        blurView.isHidden = true
        if dateSelectedString.count == 0 {
            dateSelectedString =  dateFormatter.string(from: datePicker.date)
        }
        dateSelectedString = TheGlobalPoolManager.removeMeridiansfromTime(string: dateSelectedString)
        dateSelectedString = TheGlobalPoolManager.trimString(string: dateSelectedString)

        if btnTag == 1 {
            weekDayFromLbl.text = dateSelectedString
            weekDayFromLbl.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        }else if btnTag == 2 {
            weekDayToLbl.text = dateSelectedString
            weekDayToLbl.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        }else if btnTag == 3 {
            weekEndFromLbl.text = dateSelectedString
            weekEndFromLbl.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        }else if btnTag == 4 {
            weekEndToLbl.text = dateSelectedString
            weekEndToLbl.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        }
        dateSelectedString = ""
    }
    
    @IBAction func datePickCancelClicked(_ sender: Any) {
        blurView.isHidden = true
        dateContainerView.isHidden = true
    }
    
    @IBAction func minutesBtnClicked(_ sender: Any) {
        minutesContainerView.isHidden = false
        blurView.isHidden = false
    }
    
    @IBAction func minutesPickDoneClicked(_ sender: Any) {
        minutesContainerView.isHidden = true
        blurView.isHidden = true
        if (minutesSelectedString ).isEmpty {
            minutesSelectedString =  "0"
        }
        self.minLbl.text = "\(minutesSelectedString) min"
    }
    
    @IBAction func minutesPickCancelClicked(_ sender: Any) {
        minutesContainerView.isHidden = true
        blurView.isHidden = true
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        validateInputs()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return gradePickerValues.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gradePickerValues[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        minutesSelectedString = gradePickerValues[row]
        self.view.endEditing(true)
    }
}

extension UIView {
    func customiseView(){
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.2509803922, green: 0.2901960784, blue: 0.4078431373, alpha: 0.5)
        self.clipsToBounds = true
    }
}

class BusinessHourParameters{
    var id:String!
    var deliveryTime:Int!
    
    var parameters = [String:AnyObject]()
    var timings = [String:AnyObject]()
    
    init(_ id:String, deliveryTime:Int, weekday_startAt:String, weekday_endAt:String, weekend_startAt:String, weekend_endAt:String) {
        self.id = id
        self.deliveryTime = deliveryTime
        self.timings[GlobalClass.KEY_WEEKDAY] = [
            GlobalClass.KEY_STARTAT:weekday_startAt,
            GlobalClass.KEY_ENDAT:weekday_endAt,
            GlobalClass.KEY_STATUS:"1"
            ] as AnyObject
        
        self.timings[GlobalClass.KEY_WEEKEND] = [
            GlobalClass.KEY_STARTAT:weekend_startAt,
            GlobalClass.KEY_ENDAT:weekend_endAt,
            GlobalClass.KEY_STATUS:"1"
            ] as AnyObject
        
        parameters = [GlobalClass.KEY_TIMINGS:self.timings,
                      GlobalClass.KEY_ID:self.id,
                      GlobalClass.KEY_DELIVERYTIME:self.deliveryTime] as [String : AnyObject]
    }
}
