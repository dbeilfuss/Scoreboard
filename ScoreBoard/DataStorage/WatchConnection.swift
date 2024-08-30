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
    
    //MARK: - Init
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
    
    //MARK: - Messages Enum
    
    enum watchMessage {
        case dataStorageBundle(Data)
        case requestTeamList
        case receivedMessage
        case error
        
        var rawValue: String {
            switch self {
            case .dataStorageBundle: return "dataStorageBundle"
            case .requestTeamList: return "requestTeamList"
            case .receivedMessage: return "receivedMessage"
            case .error: return "error"
            }
        }
        
        var dictionaryValue: [String: Any] {
            switch self {
            case .dataStorageBundle(let data): return [self.rawValue: data]
            case .requestTeamList: return [self.rawValue: true]
            case .receivedMessage: return [self.rawValue: true]
            case .error: return [self.rawValue: true]
            }
        }
    }
    
    //MARK: - Did Receive Message
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        if let data = message[watchMessage.dataStorageBundle(Data()).rawValue] as? Data {
            let decodedData = decodeDataStorageBundle(data)
            if decodedData != nil {
                print("received data from watch")
                updateLocalData(decodedData!)

            }
        } else if let data = message[watchMessage.requestTeamList.rawValue] as? Bool {
            let data = self.createDataStorageBundleForWatch(nil)
            print("received team data request from watch")
            sendTeamDataToWatch(data)
        }
        
        /// Reply
        replyHandler(craftResponse(.receivedMessage))
        
    }
    
    // Send Team Data to Watch
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
    
    //MARK: - Helper Functions
    
    /// Craft Response
    func craftResponse(_ messageType: watchMessage) -> [String: Any] {
        var message: [String: Any]
        switch messageType {
        case .receivedMessage:
            message = messageType.dictionaryValue
        default:
            let error: watchMessage = .error
            message = error.dictionaryValue
        }
        return message
    }
    
    /// Decode Data Data Storage Bundle
    func decodeDataStorageBundle(_ data: Data) -> DataStorageBundleForWatch? {
        do {
            let dataStorageBundle = try JSONDecoder().decode(DataStorageBundleForWatch.self, from: data)
            print(dataStorageBundle)
            return dataStorageBundle
        } catch {
            print("Failed to decode team data: \(error.localizedDescription)")
            print(data)
        }
        return nil
    }
    
    /// Create Data Storage Bundle
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
    
    /// Update Local Data
    func updateLocalData(_ dataStorageBundle: DataStorageBundleForWatch) {
        print("Updating Team Info")
        let teamList = dataStorageBundle.teamScores.filter(){$0.isActive}
        DispatchQueue.main.async {
            for team in teamList {
                self.teamManager?.saveTeam(team)
            }
        }

    }

}
