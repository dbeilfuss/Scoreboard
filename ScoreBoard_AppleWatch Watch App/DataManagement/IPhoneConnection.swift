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
    @Published var didReveiveUpdatedTeamData = false
    var timeStamp: Date?
    
    
    //MARK: - Init
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
        print("activated session")
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        print("activation did complete with state: \(activationState)")
        if activationState == .activated {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Delay of 1 second
                self.requestTeamDataFromPhone()
            }
        }
    }
    
    func sendTeamsToiOS(teams: [Team]) {
        print("sendingTeamsToiOS")
        if session.isReachable {
            print("session is reachable")
            do{
                let data = try JSONEncoder().encode(teams)
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
    
    func requestTeamDataFromPhone() {
        print("requesting teams from iOS")
        if session.isReachable {
            let message = ["requestingTeamList": true]
            print(message)
            session.sendMessage(message, replyHandler: nil)
        } else {
            print("session is not reachable \(#fileID)")
        }
    }
    
    //MARK: - Did Receive Message
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let data = message["dataStorageBundle"] as? Data {
            do {
                let decodedData = try JSONDecoder().decode(DataStorageBundleForWatch.self, from: data)
                DispatchQueue.main.async {
                    updateTeamData(decodedData)                }
                self.didReveiveUpdatedTeamData = true
            } catch {
                print("Failed to decode team data: \(error.localizedDescription)")
            }
        }
        
        func updateTeamData(_ dataStorageBundle: DataStorageBundleForWatch) {
            let oldTimeStamp: Date? = timeStamp
            let newTimeStamp: Date = dataStorageBundle.timeStamp
            
            if let safeOldTimeStamp = oldTimeStamp {
                print(oldTimeStamp)
                print(newTimeStamp)
                if newTimeStamp > safeOldTimeStamp {
                    updateWithNewTeamData()
                } else {
                    sendTeamsToiOS(teams: teamList)
                }
            } else {
                updateWithNewTeamData()
            }
            
            func updateWithNewTeamData() {
                self.teamList = dataStorageBundle.teamScores.filter(){$0.isActive}
            }
            
        }
    }
    
}
