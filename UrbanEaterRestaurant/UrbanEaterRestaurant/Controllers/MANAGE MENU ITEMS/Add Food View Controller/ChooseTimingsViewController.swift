//
//  ChooseTimingsViewController.swift
//  UrbanEaterRestaurant
//
//  Created by Vamsi on 07/02/19.
//  Copyright © 2019 Nagaraju. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class ChooseTimingsViewController: UIViewController {

    @IBOutlet weak var restaurantTimingsBtn: UIButton!
    @IBOutlet weak var chooseTimingsBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var resFromLbl: UILabel!
    @IBOutlet weak var resToLbl: UILabel!
    @IBOutlet weak var weekDaysView: UIView!
    @IBOutlet weak var dateView1: UIView!
    @IBOutlet weak var dateView2: UIView!
    @IBOutlet weak var weekDayFromLbl: UILabel!
    @IBOutlet weak var weekDayToLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var dateContainerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet var dropDownBtns: [UIButton]!
    
    var btnTag = 0
    var dateSelectedString = ""
    let dateFormatter = DateFormatter()
    var isRestTimgsSelected : Bool!
    var isDoneAnyChanges : Bool! = false
    var isComingFromEdit : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        //self.timingsBtns(self.restaurantTimingsBtn)
        for btn in dropDownBtns{
            btn.setImage(#imageLiteral(resourceName: "Drop_Down").withColor(.whiteColor), for: .normal)
            btn.isEnabled = false
        }
        weekDaysView.layer.cornerRadius = 5.0
        dateView1.customiseView()
        dateView2.customiseView()
        ez.runThisInMainThread {
            TheGlobalPoolManager.cornerAndBorder(self.saveBtn, cornerRadius: 5, borderWidth: 0, borderColor: .clear)
        }
        datePicker.datePickerMode = UIDatePickerMode.time
        dateFormatter.dateFormat = "HH:mm a"
        datePicker.locale = Locale(identifier: "en_GB")
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        if let restModel = GlobalClass.restModel{
            if let restData = restModel.data{
                if let timings = restData.timings{
                    let dates = getTimeIntervalForDate()
                    datePicker.minimumDate = dates.min
                    datePicker.maximumDate = dates.max
                    self.resFromLbl.text = timings.weekDay.startAt!
                    self.resToLbl.text = timings.weekDay.endAt!
                }
            }
        }
        self.timingsBtnsCheck(restaurantTimingsBtn, defaultCheck: true)
    }
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        sender.locale = Locale(identifier: "en_GB")
        sender.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "HH:mm a"
        dateSelectedString = dateFormatter.string(from: sender.date)
    }
    func getTimeIntervalForDate()->(min : Date, max : Date){
        let fromTime =  GlobalClass.restModel.data.timings.weekDay.startAt!
        let toTime = GlobalClass.restModel.data.timings.weekDay.endAt!
        let fromTimeResult = fromTime.split(separator: ":")
        let toTimeResult = toTime.split(separator: ":")
        
        let calendar = Calendar.current
        var minDateComponent = calendar.dateComponents([.hour], from: Date())
        minDateComponent.hour = Int(fromTimeResult[0]) // Start time
        minDateComponent.minute = Int(fromTimeResult[1])
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm a"
        let minDate = calendar.date(from: minDateComponent)
        print(" min date : \(formatter.string(from: minDate!))")
        
        var maxDateComponent = calendar.dateComponents([.hour], from: Date())
        maxDateComponent.hour = Int(toTimeResult[0])
        maxDateComponent.minute = Int(toTimeResult[1])//EndTime
        
        let maxDate = calendar.date(from: maxDateComponent)
        print(" max date : \(formatter.string(from: maxDate!))")
        return (minDate!,maxDate!)
    }
    func validateInputs(){
        if TheGlobalPoolManager.trimString(string: self.weekDayFromLbl.text!) == "HH : MM" {
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.START_TIME_EMPTY)
        }else if TheGlobalPoolManager.trimString(string: self.weekDayToLbl.text!) == "HH : MM" {
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.END_TIME_EMPTY)
        }else{
            if !self.comapreTwoTimesStrings(weekDayFromLbl.text!, t2: weekDayToLbl.text!){
                return
            }
            GlobalClass.selectedFromTime = self.weekDayFromLbl.text!
            GlobalClass.selectedToTime = self.weekDayToLbl.text!
            self.navigationController?.popViewController(animated: true)
        }
    }
    //MARK:- Compare Two Time Strings
    func comapreTwoTimesStrings(_ t1 : String , t2 : String) -> Bool{
        let time1 = t1
        let time2 = t2
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let date1: Date? = formatter.date(from: time1)
        let date2: Date? = formatter.date(from: time2)
        
        var result: ComparisonResult? = nil
        if let date2 = date2 {
            result = date1?.compare(date2)
        }
        if result == .orderedDescending {
            print("date1 is later than date2")
            TheGlobalPoolManager.showToastView("Oops! Invalid times selected")
            return false
        } else if result == .orderedAscending {
            print("date2 is later than date1")
            return true
        } else {
            print("date1 is equal to date2")
            TheGlobalPoolManager.showToastView("Oops!, From time and To time is same")
            return false
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func backBtn(_ sender: UIButton) {
        if isDoneAnyChanges{
            TheGlobalPoolManager.showAlertWith(title: "Alert", message: "Do you want to save changes?", singleAction: false, okTitle: "Save", cancelTitle: "Discard") { (success) in
                if success!{
                    if self.isRestTimgsSelected{
                        GlobalClass.selectedFromTime = self.resFromLbl.text!
                        GlobalClass.selectedToTime = self.resToLbl.text!
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        self.validateInputs()
                    }
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func timingsBtns(_ sender: UIButton) {
        self.timingsBtnsCheck(sender, defaultCheck: false)
    }
    func timingsBtnsCheck(_ sender:UIButton, defaultCheck:Bool){
        let resTimgBtn   = restaurantTimingsBtn == sender ?   #imageLiteral(resourceName: "ic_check") : #imageLiteral(resourceName: "ic_uncheck")
        let chooseTimgBtn   = chooseTimingsBtn == sender ?  #imageLiteral(resourceName: "ic_check") : #imageLiteral(resourceName: "ic_uncheck")
        if sender == restaurantTimingsBtn{
            for btn in dropDownBtns{
                btn.isEnabled = false
            }
            isRestTimgsSelected = true
        }else{
            for btn in dropDownBtns{
                btn.isEnabled = true
            }
            isRestTimgsSelected = false
        }
        restaurantTimingsBtn.setImage(resTimgBtn, for: .normal)
        chooseTimingsBtn.setImage(chooseTimgBtn, for: .normal)
        if !defaultCheck{
            self.isComingFromEditing()
        }
    }
    @IBAction func saveBtn(_ sender: UIButton) {
        if !isDoneAnyChanges{
            TheGlobalPoolManager.showToastView("Please change the timings to save")
        }else{
            if isRestTimgsSelected{
                GlobalClass.selectedFromTime = self.resFromLbl.text!
                GlobalClass.selectedToTime = self.resToLbl.text!
                self.navigationController?.popViewController(animated: true)
            }else{
                self.validateInputs()
            }
        }
    }
    @IBAction func dropDownBtns(_ sender: UIButton) {
        btnTag = sender.tag
        dateContainerView.isHidden = false
        blurView.isHidden = false
        self.isComingFromEditing()
    }
    @IBAction func datePickDoneClicked(_ sender: Any) {
        dateContainerView.isHidden = true
        blurView.isHidden = true
        if dateSelectedString.count == 0 {
            dateSelectedString =  dateFormatter.string(from: datePicker.date)
        }
        dateSelectedString = TheGlobalPoolManager.removeMeridiansfromTime(string: dateSelectedString)
        dateSelectedString = TheGlobalPoolManager.trimString(string: dateSelectedString)
        if btnTag == 1{
            weekDayFromLbl.text = dateSelectedString
            weekDayFromLbl.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        }else if btnTag == 2 {
            if weekDayFromLbl.text == "HH : MM"{
                TheGlobalPoolManager.showToastView("Please select From Time first")
                return
            }else if !self.comapreTwoTimesStrings(weekDayFromLbl.text!, t2: dateSelectedString){
                weekDayToLbl.text = "HH : MM"
                dateSelectedString = ""
                return
            }
            weekDayToLbl.text = dateSelectedString
            weekDayToLbl.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        }
        dateSelectedString = ""
        self.isComingFromEditing()
    }
    @IBAction func datePickCancelClicked(_ sender: Any) {
        blurView.isHidden = true
        dateContainerView.isHidden = true
        self.isComingFromEditing()
    }
    func isComingFromEditing(){
        if self.isComingFromEdit{
            self.isDoneAnyChanges = true
        }
    }
}
