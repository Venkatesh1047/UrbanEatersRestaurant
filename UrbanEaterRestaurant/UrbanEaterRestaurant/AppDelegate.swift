//
//  AppDelegate.swift
//  UrbanEaterRestaurant
//
//  Created by Nagaraju on 31/10/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import UIKit
import Reachability
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import SwiftyJSON
import Firebase
import FirebaseMessaging
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var IsInternetconnected:Bool=Bool()
    let googleApiKey = "AIzaSyAufQUMZP7qdjtOcGIuNFRSL-8uU6uuvGY"
    let gcmMessageIDKey = "gcm.message_id"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GMSPlacesClient.provideAPIKey(googleApiKey)
        GMSServices.provideAPIKey(googleApiKey)
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
        if UserDefaults.standard.value(forKey: "restaurantInfo") != nil{
            let dic = TheGlobalPoolManager.retrieveFromDefaultsFor("restaurantInfo") as! NSDictionary
            let restDetails = JSON(dic)
            GlobalClass.restaurantLoginModel = RestaurantLoginModel.init(fromJson: restDetails)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller  = storyboard.instantiateViewController(withIdentifier: "NavigationViewControllerID") as! CommonNavigationController
            controller.index = 0
            self.window?.rootViewController = controller
            self.window?.makeKeyAndVisible()
        }
        else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller : UINavigationController = storyboard.instantiateViewController(withIdentifier: "LoginNAvigationID") as! UINavigationController
            self.window?.rootViewController = controller
            self.window?.makeKeyAndVisible()
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func ReachabilityListener(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: Notification.Name.reachabilityChanged,object: Reachability())
        do{
            let reachability = Reachability()!
            
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    @objc func reachabilityChanged(note: NSNotification){
        let reachability = note.object as! Reachability
        
        if reachability.connection != .none //reachability.isReachable
        {
            IsInternetconnected=true
            
            if reachability.connection == .wifi //reachability.isReachableViaWiFi
            {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        else
        {
            IsInternetconnected=false
            print("Network not reachable")
        }
    }
    //MARK:- Chnage Restaurant Status Api
    func updateDeviceToken(token:String){
        if let restmodel = GlobalClass.restaurantLoginModel{
            if let dataS = restmodel.data{
                let param =     [
                    "id": dataS.subId,
                    "deviceInfo": ["deviceToken": token]] as  [String:AnyObject]
                URLhandler.postUrlSession(urlString: Constants.urls.businessHourUrl, params: param, header: [:]) { (dataResponse) in
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
        let userInfo = notification.request.content.userInfo
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // Print full message.
        print(userInfo)
        // Change this to your preferred presentation option
        if let key = userInfo["key"] as? String{
            if key == "ORDER_NEW_RESTAURANT"{
                NotificationCenter.default.post(name:NSNotification.Name(rawValue: "OrderReceived"), object: nil, userInfo: nil)
            }
        }
        completionHandler([])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // Print full message.
        print("222",userInfo)
        completionHandler()
    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        GlobalClass.instanceIDTokenMessage  = fcmToken
        self.updateDeviceToken(token: fcmToken)
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
}
