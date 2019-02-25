//
//  AppDelegate.swift
//  UrbanEaterRestaurant
//
//  Created by Nagaraju on 31/10/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import UIKit
import Reachability
import IQKeyboardManagerSwift
import SwiftyJSON
import Firebase
import FirebaseMessaging
import UserNotifications
import Fabric
import Crashlytics
import AVFoundation
import EZSwiftExtensions

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var IsInternetconnected:Bool=Bool()
    let gcmMessageIDKey = "gcm.message_id"
    var gcmNotificationIDKey = "gcm.notification.payload"
    var player = AVAudioPlayer()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
        IQKeyboardManager.shared.enable = true
        UITabBar.appearance().tintColor = .themeColor
        UITabBar.appearance().unselectedItemTintColor = .greyColor
        UITabBar.appearance().barTintColor = .whiteColor
        UITabBar.appearance().isTranslucent = false
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                GlobalClass.instanceIDTokenMessage  = result.token
            }
        }
        self.ReachabilityListener()
        self.SetInitialViewController()
        return true
    }
    func SetInitialViewController(){
        if UserDefaults.standard.value(forKey: RESTAURANT_INFO) != nil{
            let dic = TheGlobalPoolManager.retrieveFromDefaultsFor(RESTAURANT_INFO) as! NSDictionary
            let restDetails = JSON(dic)
            GlobalClass.restaurantLoginModel = RestaurantLoginModel.init(fromJson: restDetails)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller  = storyboard.instantiateViewController(withIdentifier: "NavigationViewControllerID") as! CommonNavigationController
            controller.index = 0
            ez.runThisInMainThread {
                Sockets.connectionEstablish()
                ez.runThisAfterDelay(seconds: 0.0, after: {
                    Sockets.establishConnection()
                    self.window?.rootViewController = controller
                    self.window?.makeKeyAndVisible()
                })
            }
        }
        else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller : UINavigationController = storyboard.instantiateViewController(withIdentifier: "LoginNAvigationID") as! UINavigationController
            self.window?.rootViewController = controller
            self.window?.makeKeyAndVisible()
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "OrderReceived"), object: nil, userInfo: nil)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {}
    
    //MARK:- Network Reachability Listener
    func ReachabilityListener(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: Notification.Name.reachabilityChanged,object: Reachability())
        do{
            let reachability = Reachability()!
            
            try reachability.startNotifier()
        }catch{
            //print("could not start reachability notifier")
        }
    }
    //MARK:- Network Reachability Status
    @objc func reachabilityChanged(note: NSNotification){
        let reachability = note.object as! Reachability
        if reachability.connection != .none {
            IsInternetconnected=true
            if reachability.connection == .wifi {
                //print("Reachable via WiFi")
            }else {
                //print("Reachable via Cellular")
            }
        }else{
            IsInternetconnected=false
            //print("Network not reachable")
        }
    }
    //MARK:- Chnage Restaurant Status Api
    func updateDeviceToken(token:String){
        if let restmodel = GlobalClass.restaurantLoginModel{
            if let dataS = restmodel.data{
                let param = [
                    ID: dataS.subId,
                    DEVICE_INFO: [DEVICE_TOKEN: token,
                                                 OS : iOS]] as  [String:AnyObject]
                 let header = [X_SESSION_ID : GlobalClass.restaurantLoginModel.data.sessionId!]
                URLhandler.postUrlSession(urlString: Constants.urls.UpdaterRestaurantData, params: param, header: header) { (dataResponse) in
                }
            }
        }
    }
}
extension AppDelegate : UNUserNotificationCenterDelegate, MessagingDelegate{
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo as! [String:AnyObject]
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        if let data = (userInfo[DATA] as! String).toJSON() as? [String : AnyObject]{
            if let orderID = data[ORDER_ID] as? String{
                if let key = userInfo[KEY] as? String{
                    if key == GlobalClass.ORDER_NEW_RESTAURANT || key == GlobalClass.ORDER_TABLE_NEW_RESTAURANT || key == GlobalClass.ORDER_RESTAURANT_DENIED{
                        self.playSound()
                        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "OrderReceived"), object: nil, userInfo: [ORDER_ID:orderID])
                        ez.runThisAfterDelay(seconds: 6) {
                            self.player.stop()
                        }
                    }else if key == GlobalClass.NEWS_NOTIFICATION{
                        var notificationObject = [String:[AnyObject]]()
                        var notifyJson:Notify!
                        if let notifications = TheGlobalPoolManager.retrieveFromDefaultsFor(NOTIFICATIONS){
                            if !(notifications is NSNull){
                                notificationObject = notifications as! [String:[AnyObject]]
                            }
                        }
                        if var notifyObj = notificationObject[NOTIFICATIONS]{
                            notifyObj.append(userInfo as AnyObject)
                            notificationObject[NOTIFICATIONS] = notifyObj
                        }else{
                            notificationObject[NOTIFICATIONS] = [userInfo as AnyObject]
                        }
                        notifyJson = Notify(fromJson: JSON.init(userInfo))
                        TheGlobalPoolManager.storeInDefaults(notificationObject as AnyObject, key: NOTIFICATIONS)
                        if notifyJson != nil{
                            if GlobalClass.notificationsModel != nil{
                                GlobalClass.notificationsModel.notifications.insert(notifyJson, at: 0)
                            }else{
                                GlobalClass.notificationsModel = NotificationsModel(fromJson: JSON(notificationObject as Any))
                            }
                        }else{
                            GlobalClass.notificationsModel = NotificationsModel(fromJson: JSON(notificationObject as Any))
                        }
                        NotificationCenter.default.post(name: NSNotification.Name.init("NotifyReceived"), object: nil)
                    }
                }
                let toGetAlert = userInfo[APS] as! [String:AnyObject]
                if toGetAlert[ALERT] is [String:AnyObject]{
                    let toGetTitle = toGetAlert[ALERT] as! [String:AnyObject]
                    _ = toGetTitle[TITLE] as! String
                    let body = toGetTitle[BODY] as! String
                    let applicationState = UIApplication.shared.applicationState
                    switch applicationState {
                    case .active:
                        Themes.sharedInstance.shownotificationBanner(Msg: "\(body)")
                    case .background:
                        break
                    case .inactive:
                        break
                    }
                }
                completionHandler([])
            }
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print("222",userInfo)
        completionHandler()
    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        GlobalClass.instanceIDTokenMessage  = fcmToken
        self.updateDeviceToken(token: fcmToken)
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    func playSound(){
        let path = Bundle.main.path(forResource: "Sound", ofType : "mp3")!
        let url = URL(fileURLWithPath : path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = 0
            player.play()
        } catch {
            //print ("There is an issue with this code!")
        }
    }
}
