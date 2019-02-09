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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        self.timingsBtns(self.restaurantTimingsBtn)
        for btn in dropDownBtns{
            btn.setImage(#imageLiteral(resourceName: "Drop_Down").withColor(.whiteColor), for: .normal)
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
                    self.resFromLbl.text = timings.weekDay.startAt!
                    self.resToLbl.text = timings.weekDay.endAt!
                }
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
    func validateInputs(){
        if TheGlobalPoolManager.trimString(string: self.weekDayFromLbl.text!) == "" {
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.WEEKDAY_START_TIME_EMPTY)
        }else if TheGlobalPoolManager.trimString(string: self.weekDayToLbl.text!) == "" {
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.WEEKDAY_END_TIME_EMPTY)
        }else{
            GlobalClass.selectedFromTime = self.weekDayFromLbl.text!
            GlobalClass.selectedToTime = self.weekDayToLbl.text!
            self.navigationController?.popViewController(animated: true)
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func timingsBtns(_ sender: UIButton) {
        let resTimgBtn   = restaurantTimingsBtn == sender ?   #imageLiteral(resourceName: "ic_check") : #imageLiteral(resourceName: "ic_uncheck")
        let chooseTimgBtn   = chooseTimingsBtn == sender ?  #imageLiteral(resourceName: "ic_check") : #imageLiteral(resourceName: "ic_uncheck")
        if sender == restaurantTimingsBtn{
            isRestTimgsSelected = true
        }else{
            isRestTimgsSelected = false
        }
        restaurantTimingsBtn.setImage(resTimgBtn, for: .normal)
        chooseTimingsBtn.setImage(chooseTimgBtn, for: .normal)
    }
    @IBAction func saveBtn(_ sender: UIButton) {
        if isRestTimgsSelected{
            GlobalClass.selectedFromTime = self.resFromLbl.text!
            GlobalClass.selectedToTime = self.resToLbl.text!
            self.navigationController?.popViewController(animated: true)
        }else{
            self.validateInputs()
        }
    }
    @IBAction func dropDownBtns(_ sender: UIButton) {
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
        }
        dateSelectedString = ""
    }
    @IBAction func datePickCancelClicked(_ sender: Any) {
        blurView.isHidden = true
        dateContainerView.isHidden = true
    }
}
