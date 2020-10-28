//
//  AppDelegate.swift
//  FormDemo
//
//  Created by Edouard Siegel on 03/03/16.
//
//

import UIKit
import Watchdog

let useObjcProject: Bool = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var watchdog: Watchdog?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setupLogger()
        setupWatchdog()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white

        if useObjcProject {
            window?.rootViewController = UINavigationController(rootViewController: FDMenuTableViewController())
        } else {
            window?.rootViewController = UINavigationController(rootViewController: MenuTableViewController())
        }

        window?.makeKeyAndVisible()
        return true
    }

    //MARK: - Private

    private func setupLogger() {
        guard TargetSettings.shared.useFileLogger else {
            return
        }
        Logger.sharedInstance.setup()
    }

    private func setupWatchdog() {
        guard TargetSettings.shared.useWatchdog else {
            return
        }
        watchdog = Watchdog(threshold: 0.2) {
            DDLogWarn("[Watchdog] Block main thread for over 0.2s")
        }
    }
}
