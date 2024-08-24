//
//  WatchDataManager.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 8/3/24.
//

import Foundation
import WatchConnectivity
import Firebase

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
        
        if activationState == .activated {
            let data = createDataStorageBundleForWatch(nil)
            sendTeamDataToWatch(data)
        }
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
        } else if let _ = message["requestingTeamList"] {
            print("watch is requesting team info")
            let data = createDataStorageBundleForWatch(nil)
            sendTeamDataToWatch(data)
        } else {
            print(message)
        }
    }
    
    // Send Team Data to Watch
    func createDataStorageBundleForWatch(_ dataBundle: DataStorageBundle?) -> DataStorageBundleForWatch {
        var dataForWatch: DataStorageBundleForWatch
        
        if let data = dataBundle {
            dataForWatch = DataStorageBundleForWatch(data)
        } else {
            let constants = Constants()
            let teamList: [Team] = teamManager?.fetchTeamList() ?? constants.defaultTeams
            let themeName = constants.defaultTheme.name
            let timeStamp = Timestamp(date: Date())
            let dataStorageBundle = DataStorageBundle(teamScores: teamList, themeName: themeName, timeStamp: timeStamp)
            dataForWatch = DataStorageBundleForWatch(dataStorageBundle)
        }
        
        return dataForWatch
    }
    
    func sendTeamDataToWatch(_ dataBundle: DataStorageBundleForWatch) {
        print("sendingTeamDataToWatch")
        if WCSession.default.isReachable {
            do {
                let data = try JSONEncoder().encode(dataBundle)
                let message = ["dataStorageBundle": data]
                WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
                    print("Error sending message: \(error.localizedDescription)")
                })
            } catch {
                print("Failed to encode team data: \(error.localizedDescription)")
            }
        }
    }
}
