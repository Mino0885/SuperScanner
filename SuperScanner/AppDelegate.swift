//
//  AppDelegate.swift
//  SuperScanner
//
//  Created by Mino on 2021/5/6.
//

import UIKit
import XCGLogger

let sLog = XCGLogger.default

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow.init()
        //初始化日志
        initBaseSetting()
        
        let nav = SuperNavigationController.init(rootViewController: TestViewController.init())
        nav.setNavigationBarHidden(true, animated: false)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        return true
    }
    
    
}

extension AppDelegate {
    func initBaseSetting() {
        let logPath = FileManager.default.urls(for: .cachesDirectory,
                                               in: .userDomainMask)[0]
        let logUrl = logPath.appendingPathComponent("superScannerLog.txt")
        sLog.setup(level: .verbose, showLogIdentifier: true, showFunctionName: true, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, showDate: true, writeToFile: logUrl, fileLevel: .verbose)
    }
}
