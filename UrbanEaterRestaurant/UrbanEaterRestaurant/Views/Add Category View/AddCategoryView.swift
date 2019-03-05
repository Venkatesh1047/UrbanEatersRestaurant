//
//  AddCategoryView.swift
//  UrbanEaterRestaurant
//
//  Created by Vamsi on 05/02/19.
//  Copyright © 2019 Nagaraju. All rights reserved.
//

import UIKit

class AddCategoryView: UIViewController {

    @IBOutlet weak var categoryNameTF: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.categoryNameTF.delegate = self
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        TheGlobalPoolManager.cornerAndBorder(self.view, cornerRadius: 10, borderWidth: 0, borderColor: .clear)
        self.categoryNameTF.setBottomBorder()
        self.saveBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35 ,cornerRadius : 10)
    }
    func validate() -> Bool{
        if categoryNameTF.text?.length == 0{
            TheGlobalPoolManager.showToastView("Invalid Category name")
            return false
        }
        return true
    }
    //MARK:- Add New Category
    func addNewCategoryApi(){
        Themes.sharedInstance.activityView(View: self.view)
        let param = [NAME: categoryNameTF.text!,
                               LEVEL: 1,
                               RES_ID: GlobalClass.restaurantLoginModel.data.subId!,
                               STATUS: 1
            ] as [String : Any]
        let header = [X_SESSION_ID : GlobalClass.restaurantLoginModel.data.sessionId!]
        URLhandler.postUrlSession(urlString: Constants.urls.Create_Category, params: param as [String : AnyObject], header: header) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            print(dataResponse.json)
            if dataResponse.json.exists(){
                NotificationCenter.default.post(name: Notification.Name("NewCategoryAdded"), object: nil)
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func saveBtn(_ sender: UIButton) {
        if validate(){
            self.addNewCategoryApi()
        }
    }
}
extension AddCategoryView : UITextFieldDelegate{
    //MARK:- UI Text Field Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         if textField == self.categoryNameTF{
            let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return (string == filtered) && newLength <= 30
        }
        return false
    }
}

