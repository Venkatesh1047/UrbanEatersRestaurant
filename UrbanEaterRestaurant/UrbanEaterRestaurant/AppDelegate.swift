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
import Fabric
import Crashlytics
import AVFoundation
import EZSwiftExtensions

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var IsInternetconnected:Bool=Bool()
    let googleApiKey = "AIzaSyAufQUMZP7qdjtOcGIuNFRSL-8uU6uuvGY"
    let gcmMessageIDKey = "gcm.message_id"
    var gcmNotificationIDKey = "gcm.notification.payload"
    var player = AVAudioPlayer()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
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
    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("Heloooo......")
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
            print("could not start reachability notifier")
        }
    }
    //MARK:- Network Reachability Status
    @objc func reachabilityChanged(note: NSNotification){
        let reachability = note.object as! Reachability
        if reachability.connection != .none {
            IsInternetconnected=true
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            }else {
                print("Reachable via Cellular")
            }
        }else{
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
                URLhandler.postUrlSession(urlString: Constants.urls.UpdaterRestaurantData, params: param, header: [:]) { (dataResponse) in
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
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        if let key = userInfo["key"] as? String{
            if key == GlobalClass.ORDER_NEW_RESTAURANT || key == GlobalClass.ORDER_TABLE_NEW_RESTAURANT{
                self.playSound()
                NotificationCenter.default.post(name:NSNotification.Name(rawValue: "OrderReceived"), object: nil, userInfo: nil)
                ez.runThisAfterDelay(seconds: 4) {
                    self.player.stop()
                }
            }
        }
        let toGetAlert = userInfo["aps"] as! [String:AnyObject]
        if toGetAlert["alert"] is [String:AnyObject]{
            let toGetTitle = toGetAlert["alert"] as! [String:AnyObject]
            let title = toGetTitle["title"] as! String
            let body = toGetTitle["body"] as! String
            let applicationState = UIApplication.shared.applicationState
            switch applicationState {
            case .active:
                print("App is active")
                AGPushNoteView.show(withNotificationMessage: title, description: body)
            case .background:
                print("App is in background")
            case .inactive:
                print("App is in InActive")
            }
        }
        completionHandler([])
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
        print("Firebase registration token: \(fcmToken)")
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
            print ("There is an issue with this code!")
        }
    }
}
