//
//  AppDelegate.swift
//  GAAppUpdate
//
//  Created by MaciOS on 2021/7/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let about = AboutUSVC()
        window?.rootViewController = about
        window?.makeKeyAndVisible()
        
        // 每天自动弹一次更新提示
        if Date.appUpdateIsNewToday() {
            UpdateAPI.requestVersionAPI(GlobalConst.RJAPPID, greatThan: true) {

            } completion: { (responseDict) in
                DispatchQueue.main.async {
                    let alert = AppVersionUpdateAlertVC()
                    alert.responseDict = responseDict
                    alert.modalPresentationStyle = .overCurrentContext
                    alert.modalTransitionStyle = .coverVertical
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: false, completion: nil)
                }
            }
        }
        
        return true
    }

}

