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
import ImageIO
import EZSwiftExtensions

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
//MARK:- UITeaxt Field
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
        return #colorLiteral(red: 0, green: 0.7333333333, blue: 0.3176470588, alpha: 0.5) //00BB51 Opacity 50%
    }
    static var disableColor:UIColor{
        return #colorLiteral(red: 0.6666666667, green: 0.6666666865, blue: 0.6666666865, alpha: 0.5) //AAAAAA Opacity 50%
    }
}
//MARK:- UIFont
extension UIFont{
    static func appFont(_ font:AppFonts, size:CGFloat = 16.0) -> UIFont{
        return UIFont(name: font.fonts, size: size) ??  UIFont(name: AppFonts.Regular.fonts, size: size)!
    }
}
//MARK:- UIButton
extension UIButton{
    func cornerRadius(_ radius:CGFloat = 5.0){
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
//MARK:- String
extension StringProtocol where Index == String.Index {
    func nsRange(from range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }
}
//MARK:- UILabel
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
    func strikeSomeText(_ strikeText:String, wholeString:String, size:CGFloat = 14.0, available:Bool){
        let firstColor = available ? UIColor.secondaryTextColor : UIColor.lightGray
        let secondColor = available ? UIColor.strikeColor : UIColor.lightGray
        let somePartStringRange = (wholeString as NSString).range(of: strikeText)
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: wholeString, attributes: [NSAttributedStringKey.foregroundColor : firstColor, NSAttributedStringKey.font : UIFont.appFont(.Regular,size: size)])
        attributeString.addAttributes([NSAttributedStringKey.strikethroughStyle: 2, NSAttributedStringKey.foregroundColor : secondColor, NSAttributedStringKey.font : UIFont.appFont(.Medium,size: size)], range: somePartStringRange)
        self.attributedText = attributeString
    }
    func attributeText(_ mainText:String, wholeString:String, wholesize:CGFloat = 12.0, mainSize:CGFloat = 14.0, available:Bool){
        let firstColor = available ? UIColor.secondaryTextColor : UIColor.lightGray
        let secondColor = available ? UIColor.secondaryBGColor : UIColor.lightGray
        let somePartStringRange = (wholeString as NSString).range(of: mainText)
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: wholeString, attributes: [NSAttributedStringKey.foregroundColor : firstColor, NSAttributedStringKey.font : UIFont.appFont(.Regular,size: wholesize)])
        attributeString.addAttributes([NSAttributedStringKey.foregroundColor : secondColor, NSAttributedStringKey.font : UIFont.appFont(.Medium,size: mainSize)], range: somePartStringRange)
        self.attributedText = attributeString
    }
}
//MARK:- NSRange
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
//MARK:- View Controller
extension UIViewController{
    func disableKeyBoardOnTap(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    @objc func tapped(_ sender:UIGestureRecognizer){
        self.view.endEditing(true)
    }
}
//MARK:- Date
extension Date {
    var convertedDate:Date {
        let dateFormatter = DateFormatter();
        let dateFormat = "yyyy-MM-dd HH:mm:ss";
        dateFormatter.dateFormat = dateFormat;
        let formattedDate = dateFormatter.string(from: self);
        dateFormatter.locale = NSLocale.current;
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00");
        dateFormatter.dateFormat = dateFormat as String;
        let sourceDate = dateFormatter.date(from: formattedDate as String);
        return sourceDate!;
    }
}
//MARK:- Version number and Build Number
extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
//MARK:- Captilaize First Letter
extension String {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
    func toJSON() -> AnyObject? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
    }
}
//MARK:- Text Field Padding
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
//MARK:- UIView Animation
extension UIView{
    func animShow(){
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseOut],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()
                        
        },  completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
        })
    }
}
//MARK:- Getting Past 7 days
extension Date {
    static func getDates(forLastNDays nDays: Int) -> ([String],[String],[String]) {
        let cal = NSCalendar.current
        var date = cal.startOfDay(for: Date())
        var day = cal.startOfDay(for: Date())
        var datesArray = [String]()
        var daysArray = [String]()
        var weekDaysName = [String]()
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
            weekDaysName.append(day.weekday)
        }
        return (datesArray, daysArray, weekDaysName)
    }
    func adding(minutes: Int) -> (String, String, Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let convertedDate: String = dateFormatter.string(from: Calendar.current.date(byAdding: .minute, value: minutes, to: self)!)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm"
        let convertedDateAndTime = dateFormatter1.string(from: Calendar.current.date(byAdding: .minute, value: minutes, to: self)!)
        let date = dateFormatter1.date(from: convertedDateAndTime)
        return (convertedDate, convertedDateAndTime, date!)
    }
    func addingOneDayExtra(_ time:String) -> (String, Date){
        let cal = NSCalendar.current
        var date = cal.startOfDay(for: Date())
        date = cal.date(byAdding: Calendar.Component.day, value: 1, to: date)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date) + " " + time
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString1 = dateFormatter1.date(from: dateString)
        return (dateString, dateString1!)
    }
}

extension Float{
    var toString:String{
        return "\(self)"
    }
    var toDouble:Double{
        return Double(self)
    }
    var toInt:Int{
        return Int(self)
    }
}

extension Double{
    var dateString:String{
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd, MMM - hh:mm a" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
}

/// Extend UITextView and implemented UITextViewDelegate to listen for changes
extension UITextView: UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.length > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.length > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}


//MARK:- GIF Image
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}



extension UIImage {
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL? = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL!) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        
        return animation
    }
    
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

//MARK:- UI Devices
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
