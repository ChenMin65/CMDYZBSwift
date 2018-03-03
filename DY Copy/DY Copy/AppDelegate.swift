//
//  AppDelegate.swift
//  DY Copy
//
//  Created by 陈敏 on 2018/2/28.
//  Copyright © 2018年 ChenMin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UITabBar.appearance().tintColor = UIColor.orange
        
        
        return true
    }

}

