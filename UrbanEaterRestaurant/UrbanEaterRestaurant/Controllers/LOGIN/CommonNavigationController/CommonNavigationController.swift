//
//  CommonNavigationController.swift
//  DinedooRestaurant
//
//  Created by casperonIOS on 4/3/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit

class CommonNavigationController: UINavigationController {
    
    var index: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let tabBarController = self.tabBarController as? RAMAnimatedTabBarController
//        tabBarController?.setSelectIndex(from: 0, to: index)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
