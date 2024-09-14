//
//  ExtensionDelegate.swift
//  ScoreBoard_AppleWatch Watch App
//
//  Created by Daniel Beilfuss on 9/13/24.
//

import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate, ObservableObject {
    
    @Published var iPhoneConnection: IPhoneConnection?
    
    func applicationDidBecomeActive() {
        print("App did become active")
        iPhoneConnection?.requestTeamDataFromPhone()
    }
    
}
