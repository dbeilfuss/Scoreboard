//
//  SceneDelegate.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 12/2/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var externalWindow: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
//        if windowScene.session.role == .windowApplication {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            if let initialViewController = storyboard.instantiateInitialViewController() {
//                let window = UIWindow(windowScene: windowScene)
//                window.rootViewController = initialViewController
//                self.window = window
//                window.makeKeyAndVisible()
//            }
            
//        } else if windowScene.session.role == .windowExternalDisplayNonInteractive {
//            print("Configuring external display")
//            let storyboard = UIStoryboard(name: "External Display", bundle: nil)
//            if let externalViewController = storyboard.instantiateInitialViewController() as? MainDisplayViewController {
//                let externalWindow = UIWindow(windowScene: windowScene)
//                externalWindow.rootViewController = externalViewController
//                self.externalWindow = externalWindow
//                externalWindow.isHidden = false
//                externalWindow.makeKeyAndVisible()
//                print("External display window configured and made key, \(externalWindow.isKeyWindow)")
//                print("External display window configured and made key with rootViewController: \(String(describing: externalWindow.rootViewController))")
//            }
//        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        
        if scene.session.role == .windowExternalDisplayNonInteractive {
            self.externalWindow = nil
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

