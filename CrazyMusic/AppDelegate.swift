//
//  AppDelegate.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/6.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Application.shared.configureDependencies()
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        LibManager.shared.register(launchOptions: launchOptions)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        self.window = window
        Application.shared.configureMainInterface(in: window)
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let result = UMSocialManager.default()?.handleOpen(url, options: options) ?? false
        return result
    }

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        let result = UMSocialManager.default()?.handleOpen(url) ?? false
        return result
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        UMSocialManager.default()?.handleUniversalLink(userActivity, options: nil)
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenStr = deviceToken.map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
        print("deviceToken: \(deviceTokenStr)")
        LibManager.shared.deviceToken = deviceTokenStr
        UserManager.shared.login.subscribe(onNext: {[weak self] (u, s) in
            guard let self = self else { return }
            guard let _ = u else { return }
            guard s == .login else { return }
            NetManager.requestResponse(.updateDeviceToken(token: deviceTokenStr)).subscribe(onSuccess: { _ in
                print("success to regist deviceToken: \(deviceTokenStr)")
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
    }
}

