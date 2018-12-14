//
//  Utilities.swift
//  UrbanEaterRestaurant
//
//  Created by Nagaraju on 31/10/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import Foundation
import UIKit

class Utilities: NSObject {
    
    
    func ReplaceNullWithString(string : AnyObject) -> String
    {
        if string is NSNull
        {
            return ""
        }
        else if (String(describing: type(of: string)) != "__NSCFString")
        {
            return String(describing: string)
        }
        else
        {
            return string as! String
        }
    }
    
    func getDateRTimeFromiSO(string: String, formate:String) -> String {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        // "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let date = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = formate //"dd-MM-yyyy HH:mm:ss"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)
        print("EXACT_DATE ---->>>: \(dateString)")
        return dateString
    }
    
    func trimString(string : String) -> String
    {
        let trimmedString = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmedString;
    }
    
    func isValidEmail(testStr:String) -> Bool
    {
        print("validate emailId: \(testStr)")
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func removeMeridiansfromTime(string : String) -> String
    {
        var trimmedString = ""
        if string.range(of:"PM") != nil {
            //print("exists")
            trimmedString = string.replacingOccurrences(of: "PM", with: "")
        }
        
        
        if string.range(of:"AM") != nil {
            trimmedString = string.replacingOccurrences(of: "AM", with: "")
        }
        
        // let trimmedString = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmedString;
    }
    
    
}
