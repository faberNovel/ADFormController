//
//  AppDelegate.swift
//  FormDemo
//
//  Created by Edouard Siegel on 03/03/16.
//
//

import HockeySDK
import UIKit
import Watchdog


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BITHockeyManagerDelegate {

    var window: UIWindow?
    var watchdog: Watchdog?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        setupLogger()
        setupHockeyApp()
        setupWatchdog()

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = UINavigationController(rootViewController: MenuTableViewController())
        window?.makeKeyAndVisible()
        return true
    }

    //MARK: - BITHockeyManagerDelegate

    func attachmentForCrashManager(crashManager: BITCrashManager!) -> BITHockeyAttachment! {
        return BITHockeyAttachment(
            filename: "report",
            hockeyAttachmentData: Logger.sharedInstance.fileLogs(),
            contentType: "text/plain"
        )
    }

    //MARK: - Private

    private func setupLogger() {
        guard ADTargetSettings.sharedSettings().useFileLogger else {
            return
        }
        Logger.sharedInstance.setup()
    }

    private func setupHockeyApp() {
        if (ADTargetSettings.sharedSettings().hockeyAppId ?? "").isEmpty {
            return
        }
        BITHockeyManager.sharedHockeyManager().configureWithIdentifier(ADTargetSettings.sharedSettings().hockeyAppId)
        BITHockeyManager.sharedHockeyManager().crashManager.crashManagerStatus = .AutoSend
        BITHockeyManager.sharedHockeyManager().crashManager.enableAppNotTerminatingCleanlyDetection = true
        if ADTargetSettings.sharedSettings().useFileLogger {
            BITHockeyManager.sharedHockeyManager().delegate = self
        }
        BITHockeyManager.sharedHockeyManager().startManager()
    }

    private func setupWatchdog() {
        if (!ADTargetSettings.sharedSettings().useWatchdog) {
            return;
        }
        watchdog = Watchdog(threshold: 0.2, handler: { (duration) -> () in
            DDLogWarn("[Watchdog] Block main thread for \(duration)s");
        })
    }
}
