//
//  ExtensionClass.swift
//  UrbanEats
//
//  Created by Venkat@Hexadots on 06/11/18.
//  Copyright © 2018 Hexadots. All rights reserved.
//

/**
    * This class was written according to the app recuriment, these are the extension of an existing Types.
 */

import Foundation
import UIKit
let APP_FONT = "Roboto"
enum AppFonts {
    case Bold, Medium, Regular, Black, BlackItalic, BoldItalic, ExtraBold, ExtraBoldItalic, ExtraLight, Italic, Light, LightItalic, MediumItalic, SemiBold, SemiBoldItalic, Thin, ThinItalic
    
    var fonts:String{
        switch self {
        case .Bold:
            return "\(APP_FONT)-Bold"
        case .Medium:
            return "\(APP_FONT)-Medium"
        case .Regular:
            return "\(APP_FONT)-Regular"
        case .Black:
            return "\(APP_FONT)-Black"
        case .BlackItalic:
            return "\(APP_FONT)-BlackItalic"
        case .BoldItalic:
            return "\(APP_FONT)-BoldItalic"
        case .ExtraBold:
            return "\(APP_FONT)-ExtraBold"
        case .ExtraBoldItalic:
            return "\(APP_FONT)-ExtraBoldItalic"
        case .ExtraLight:
            return "\(APP_FONT)-ExtraLight"
        case .Italic:
            return "\(APP_FONT)-Italic"
        case .Light:
            return "\(APP_FONT)-Light"
        case .LightItalic:
            return "\(APP_FONT)-LightItalic"
        case .MediumItalic:
            return "\(APP_FONT)-MediumItalic"
        case .SemiBold:
            return "\(APP_FONT)-SemiBold"
        case .SemiBoldItalic:
            return "\(APP_FONT)-SemiBoldItalic"
        case .Thin:
            return "\(APP_FONT)-Thin"
        case .ThinItalic:
            return "\(APP_FONT)-ThinItalic"
        }
    }
}

extension UITextField{
    func placeholderColor(_ placeholder:String, color:UIColor){
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor : color])
    }
    
    func leftViewImage(_ image:UIImage){
        self.leftViewMode = UITextFieldViewMode.always
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        self.leftView = view
    }
    
    func rightViewImage(_ image:UIImage){
        self.rightViewMode = UITextFieldViewMode.always
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        self.rightView = view
    }
}

//MARK:- UIColor
extension UIColor{
    static var themeColor:UIColor{
        return #colorLiteral(red: 0.9529411765, green: 0.7529411765, blue: 0.1843137255, alpha: 1) //F3C02F
    }
    static var greenColor:UIColor{
        return #colorLiteral(red: 0, green: 0.7333333333, blue: 0.3176470588, alpha: 1) //00BB51
    }
    static var themeDisableColor:UIColor{
        return #colorLiteral(red: 0.9529411765, green: 0.7529411765, blue: 0.1843137255, alpha: 0.5) //F3C02F Opacity 50%
    }
    static var placeholderColor:UIColor{
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7980789812) //FFFFFF Opacity 80%
    }
    static var textFieldTintColor:UIColor{
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) //FFFFFF
    }
    static var buttonBGColor:UIColor{
        return #colorLiteral(red: 0.2509803922, green: 0.2901960784, blue: 0.4078431373, alpha: 0.2018942637) //404A68 Opacity 20%
    }
    static var whiteColor:UIColor{
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) //FFFFFF
    }
    static var blackColor:UIColor{
        return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) //000000
    }
    static var greyColor:UIColor{
        return #colorLiteral(red: 0.4980392157, green: 0.5019607843, blue: 0.5098039216, alpha: 1) //7F8082
    }
    static var redColor:UIColor{
        return #colorLiteral(red: 1, green: 0.3607843137, blue: 0.4117647059, alpha: 1) //FF5C69
    }
    static var strikeColor:UIColor{
        return #colorLiteral(red: 0.3294117647, green: 0.3294117647, blue: 0.3294117647, alpha: 0.7992562072) //545454 Opacity 80%
    }
    static var restBGColor:UIColor{
        return #colorLiteral(red: 0.9647058824, green: 0.9725490196, blue: 0.9960784314, alpha: 1) //F6F8FE
    }
    static var textColor:UIColor{
        return #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1) //333333
    }
    static var secondaryTextColor:UIColor{
        return #colorLiteral(red: 0.3294117647, green: 0.3294117647, blue: 0.3294117647, alpha: 1) //545454
    }
    static var secondaryBGColor:UIColor{
        return #colorLiteral(red: 0.2509803922, green: 0.2901960784, blue: 0.4078431373, alpha: 1) //404A68
    }
    static var secondaryBGColorOpacity:UIColor{
        return #colorLiteral(red: 0.2509803922, green: 0.2901960784, blue: 0.4078431373, alpha: 0.5) //404A68 Opacity 50%
    }
    static var bookATableBG:UIColor{
        return #colorLiteral(red: 0, green: 0.7333333333, blue: 0.3176470588, alpha: 0.5)
    }
}

extension UIFont{
    static func appFont(_ font:AppFonts, size:CGFloat) -> UIFont{
        return UIFont(name: font.fonts, size: size) ??  UIFont(name: AppFonts.Regular.fonts, size: size)!
    }
}

extension UIButton{
    func cornerRadius(_ radius:CGFloat = 5.0){
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}

extension StringProtocol where Index == String.Index {
    func nsRange(from range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }
}

extension UILabel {
    ///Find the index of character (in the attributedText) at point
    func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int {
        assert(self.attributedText != nil, "This method is developed for attributed string")
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)
        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return index
    }
}

extension NSRange{
    /**
     Used to check textfiled condition.
     ## Example:
     
     If mobile number textfiled lenght has 10 digits then need to enable button otherwise disable the button.
     ````
     let enableBtn = range.locAndLen >= 9
     button.isEnabled = enableBtn
     ````
     */
    var locAndLen:Int{
        let location = self.location
        let length = self.length == 1 ? (location - 1) : location
        return length
    }
}

extension UIViewController{
    func disableKeyBoardOnTap(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    @objc func tapped(_ sender:UIGestureRecognizer){
        self.view.endEditing(true)
    }
}
//MARK:- Getting Past 7 days
extension Date {
    static func getDates(forLastNDays nDays: Int) -> ([String],[String]) {
        let cal = NSCalendar.current
        var date = cal.startOfDay(for: Date())
        var day = cal.startOfDay(for: Date())
        var datesArray = [String]()
        var daysArray = [String]()
        var value = 0
        for val in 0 ... nDays {
            if val != 0{
                value = 1
            }
            date = cal.date(byAdding: Calendar.Component.day, value: +value, to: date)!
            day = cal.date(byAdding: Calendar.Component.weekday, value: +value, to: day)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: date)
            let dayString = day.isToday ? "Today" : day.weekday
            datesArray.append(dateString)
            daysArray.append(dayString)
        }
        return (datesArray, daysArray)
    }
    func adding(minutes: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let convertedDate: String = dateFormatter.string(from: Calendar.current.date(byAdding: .minute, value: minutes, to: self)!)
        return convertedDate
    }
}
extension UIImage{
    func imageWithInsets(insetDimen: CGFloat) -> UIImage {
        return imageWithInset(insets: UIEdgeInsets(top: insetDimen, left: insetDimen, bottom: insetDimen, right: insetDimen))
    }
    func imageWithInset(insets: UIEdgeInsets) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(self.renderingMode)
        UIGraphicsEndImageContext()
        return imageWithInsets!
    }
}
class UILabelPadded: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
}
extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhones_4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhones_X_XS = "iPhone X or iPhone XS"
        case iPhone_XR = "iPhone XR"
        case iPhone_XSMax = "iPhone XS Max"
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhones_4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1792:
            return .iPhone_XR
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhones_X_XS
        case 2688:
            return .iPhone_XSMax
        default:
            return .unknown
        }
    }
}
