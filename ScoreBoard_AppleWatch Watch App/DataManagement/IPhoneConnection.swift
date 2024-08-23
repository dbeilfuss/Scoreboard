//
//  ExtensionDelegate.swift
//  ScoreBoard_AppleWatch Watch App
//
//  Created by Daniel Beilfuss on 8/6/24.
//

import WatchKit
import WatchConnectivity

class IPhoneConnection: NSObject, WCSessionDelegate, ObservableObject {
    
        var session: WCSession
    
    //MARK: - Observable Properties
    @Published var teamList: [Team] = Constants().defaultTeams.filter(){$0.isActive}
        
    //MARK: - Init
        init(session: WCSession = .default) {
            self.session = session
            super.init()
            session.delegate = self
            session.activate()
        }

        func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
            
        }
    
    func sendTeamsToiOS() {
        print("sendingTeamsToiOS")
        if session.isReachable {
            print("session is reachable")
            do{
            let data = try JSONEncoder().encode(teamList)
                let message = ["teamList": data]
                print(message)
            session.sendMessage(message, replyHandler: nil)
            } catch {
                print("Failed to encode team data: \(error.localizedDescription)")
            }
        } else {
            print("session is not reachable \(#fileID)")
        }
    }


    
    //MARK: - Old functions from ChatGPT
    
    //MARK: - Did Finish Launching
    func applicationDidFinishLaunching() {
        print("applicationDidFinishLaunching")
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    //MARK: - WCSessionDelegate Methods
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("session triggered on watch")
        if let data = message["teams"] as? Data {
            do {
                let teamsFromIPhone = try JSONDecoder().decode([Team].self, from: data)
                self.teamList = teamsFromIPhone
            } catch {
                print("Failed to decode team data: \(error.localizedDescription)")
            }
        }
    }
    
}
