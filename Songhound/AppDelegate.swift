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


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // My personal key to access the maps service
        GMSServices.provideAPIKey("AIzaSyBqwX1XCTzvEdNZH-WydmpTf3dVgUgUhes")
        GIDSignIn.sharedInstance().clientID = "288110944258-ridgqi0r03ttme394kd3ch2s7toggpa9.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        // activate firebase core
        FirebaseApp.configure()
        return true
    }

    func  application(_ app: UIApplication, open url: URL,  options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
           saveGoogleUserInfo(user: user)
        }
    }
    
    private func saveGoogleUserInfo(user: GIDGoogleUser) {
        let userId = user.userID
        let idToken = user.authentication.idToken
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        
//        let user = User(userId: userId,
//                        idToken: idToken,
//                        fullName: fullName,
//                        givenName: givenName,
//                        familyName: familyName,
//                        email: email)
        
        let preferences = UserDefaults.standard
        // pitty I cannot do this save one by one
        //preferences.set(user, forKey: USER_DEFAULTS_KEY)  // save the user object permantaly on a simple storage
        //
      //  preferences.se
        
        
        
        preferences.set(userId, forKey: USER_ID)
        preferences.set(idToken, forKey: ID_TOKEN)
        preferences.set(fullName, forKey: FULL_NAME)
        preferences.set(givenName, forKey: GIVEN_NAME)
        preferences.set(familyName, forKey: FAMILY_NAME)
        preferences.set(email, forKey: EMAIL)

        let sync = preferences.synchronize()
        print("it sycned \(sync)")
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("oopps user signed out yoh")
        
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                accessToken: authentication.accessToken)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("user not signed in there was an error bro \(error)")
                return
            }
            print("Yey user signed in bro")
            self.saveGoogleUserInfo(user: user)
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


}

