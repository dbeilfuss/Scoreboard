//
//  ExtensionDelegate.swift
//  ScoreBoard_AppleWatch Watch App
//
//  Created by Daniel Beilfuss on 8/6/24.
//

import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate, ObservableObject {
    
    //MARK: - Observable Properties
    @Published var teamList: [Team] = Constants().defaultTeams.filter(){$0.isActive}
    
    //MARK: - Did Finish Launching
    func applicationDidFinishLaunching() {
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    //MARK: - WCSessionDelegate Methods
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let data = message["teams"] as? Data {
            do {
                let teamsFromIPhone = try JSONDecoder().decode([Team].self, from: data)
                self.teamList = teamsFromIPhone
            } catch {
                print("Failed to decode team data: \(error.localizedDescription)")
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
    }
    
}
