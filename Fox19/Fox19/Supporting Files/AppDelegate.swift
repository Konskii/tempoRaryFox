//
//  AppDelegate.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 20.10.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = RootViewController()
     //   let nav = UINavigationController(rootViewController: GamesViewControllerTest())
    //  window?.rootViewController = nav
  //     window?.rootViewController = DetailGameViewController()
        
        return true
    }
}
extension AppDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var rootViewController: RootViewController {
        return window!.rootViewController as! RootViewController
    }
}
