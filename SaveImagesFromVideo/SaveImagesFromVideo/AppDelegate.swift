//
//  AppDelegate.swift
//  SaveImagesFromVideo
//
//  Created by Ahmed Abuelmagd on 22/11/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = HomeVC()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        return true
    }
    
}
