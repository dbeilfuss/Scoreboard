//
//  WatchDataManager.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 8/3/24.
//

import Foundation
import WatchConnectivity

class WatchConnection: NSObject, WCSessionDelegate {
    var printFunctions = true

    var session: WCSession
    var teamManager: TeamManagerProtocol?
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        print(printFunctions ? "watch session did complete with \(activationState)":"")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print(printFunctions ? "watch session did become active":"")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print(printFunctions ? "watch session did deactivate":"")
    }
    
    // DidReceiveMessage
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let data = message["teamList"] as? Data {
            do {
                let teamData = try JSONDecoder().decode([Team].self, from: data)
                print(teamData)
                print("teamManager == nil ? \(teamManager == nil)")
                for team in teamData {
                    teamManager?.saveTeam(team)
                }
                print("session function without replyHandler")
            } catch {
                print("data received from watch, could not decode")
                print(error.localizedDescription)
            }
        }
    }

    
    // Old Function from ChatGPT
    func sendTeamDataToWatch(_ teams: [Team]) {
        print("sendingTeamDataToWatch")
        if WCSession.default.isReachable {
            do {
                let data = try JSONEncoder().encode(teams)
                let message = ["teams": data]
                WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
                    print("Error sending message: \(error.localizedDescription)")
                })
            } catch {
                print("Failed to encode team data: \(error.localizedDescription)")
            }
        }
    }
}
