//
//  AppDelegate.swift
//  wwdc2018
//
//  Created by Gustavo Vergara Garcia on 24/03/18.
//  Copyright © 2018 Gustavo Vergara Garcia. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        let grid = Grid()
        
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = CustomViewController()//grid.gridView
        window.makeKeyAndVisible()
        self.window = window
        
//        grid.sort()
        
        return true
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

    class CustomViewController: UIViewController {
//        let pillarView = PillarsView()
        let pillars = Pillars()
        
        override func loadView() {
            self.view = UIView()
            self.view.backgroundColor = .darkGray
            
            self.view.addSubview(self.pillars.view)
            self.pillars.view.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
//            self.pillarView.setNeedsLayout()
//            self.pillarView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//            self.pillarView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            self.pillars.sort()
        }
        
    }

}

