//
//  AppDelegate.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 12/2/22.
//

import UIKit
import WatchConnectivity
#if !os(watchOS)
    import IQKeyboardManagerSwift
    import FirebaseCore
    import FirebaseAuth
    import FirebaseFirestore
#endif


@main
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Detect Device Type
        _ = Utilities.DeviceInfo().deviceType
        
        // IQKeyboard
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        // Firebase
        FirebaseApp.configure()
        let _ = Firestore.firestore()
        
        // Apple Watch Session
//        if WCSession.isSupported() {
//            WCSession.default.delegate = self
//            WCSession.default.activate()
//        }
        
        return true
    }
    
    //MARK: - Apple Watch Session Delegate Methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }

    //MARK: - Orientation Lock
        
    var orientation: UIInterfaceOrientationMask = .all
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientation
    }
    
    struct AppUtility {
        static func lockOrientation(to orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientation = orientation
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        if connectingSceneSession.role == .windowApplication {
            return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        } else if connectingSceneSession.role == .windowExternalDisplayNonInteractive {
            return UISceneConfiguration(name: "External Display Configuration", sessionRole: connectingSceneSession.role)
        } else {
            // Return a default configuration in case of any other roles (if any)
            return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        }
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

