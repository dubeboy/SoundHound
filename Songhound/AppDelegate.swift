//
//  AppDelegate.swift
//  Songhound
//
//  Created by Divine Dube on 2019/02/15.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import GoogleSignIn
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // My personal key to access the maps service
        GMSServices.provideAPIKey("AIzaSyBqwX1XCTzvEdNZH-WydmpTf3dVgUgUhes")
        GIDSignIn.sharedInstance().clientID = "288110944258-ridgqi0r03ttme394kd3ch2s7toggpa9.apps.googleusercontent.com"

        // init our 
        let songsList = SongsListWireFrame.createSongsListModule()
        // I guess this is where we set the windows size when we open apps for iPhone on iPad ie. Instagram
        window?.backgroundColor = .white // set the default color for the window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = songsList
        // what is a key window is it the laucher screen?
        window?.makeKeyAndVisible()
        FirebaseApp.configure()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation])
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


}

