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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var IsInternetconnected:Bool=Bool()
    let googleApiKey = "AIzaSyAufQUMZP7qdjtOcGIuNFRSL-8uU6uuvGY"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        GMSPlacesClient.provideAPIKey(googleApiKey)
        GMSServices.provideAPIKey(googleApiKey)
        IQKeyboardManager.shared.enable = true
        UITabBar.appearance().tintColor = .themeColor
        UITabBar.appearance().unselectedItemTintColor = .greyColor
        UITabBar.appearance().barTintColor = .whiteColor
        UITabBar.appearance().isTranslucent = false
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


}

