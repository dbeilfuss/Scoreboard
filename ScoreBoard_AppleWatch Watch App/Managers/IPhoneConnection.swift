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
    
    // Connection State
    enum ConnectionState {
        case initializingConnection
        case active
        case pendingReponse
        case noResponse
        case critical
    }
    @Published var connectionState: ConnectionState = .initializingConnection
    
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
    
    //MARK: - Messages Enum
    
    enum iPhoneMessage {
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
    
    //MARK: - Messages Funtions
    
    func sendMessageToiPhone(messageType: iPhoneMessage) {
        if session.isReachable {
            
            /// Parameters
            let message = messageType.dictionaryValue
            print("message: \(message)")

            /// Send Message
            session.sendMessage(message, replyHandler: { response in
                self.responseHandler(response)
            }, errorHandler: { error in
                print("⛔️ iPhone Reported Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.connectionState = .pendingReponse
                }
                self.noResponseHandler()
            })
            
        }
        
    }
    
    func sendTeamsToiPhone(teams: [Team]) {
        let dataStorageBundle = DataStorageBundleForWatch(teamScores: teams, themeName: Constants().defaultTheme)
        do{
            let data = try JSONEncoder().encode(dataStorageBundle)
            sendMessageToiPhone(messageType: .dataStorageBundle(data))
        } catch {
            print("⛔️ Failed to encode team data: \(error.localizedDescription)")
        }
    }
    
    func responseHandler(_ response: [String : Any]) -> Void {
        /// Received Request
        if let response = response[iPhoneMessage.receivedMessage.rawValue] as? Bool {
            print("iPhone Response: \(response)")
            DispatchQueue.main.async {
                self.connectionState = .active
            }
        } else if let error = response[iPhoneMessage.error.rawValue] as? Data {
            print("⛔️ Received Error Message from iPhone \(error)")
        }
    }
    
    func requestTeamDataFromPhone() {
        sendMessageToiPhone(messageType: .requestTeamList)
    }
    
    //MARK: - Did Receive Message
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let data = message[iPhoneMessage.dataStorageBundle(Data()).rawValue] as? Data {
            print("received data from phone")
            
            /// Execution
            let decodedData = decodeDataStorageBundle(data)
            print(decodedData)
            if decodedData != nil {
                if isMoreRecentData(decodedData!) {
                    updateLocalData(decodedData!)
                } else {
                    sendTeamsToiPhone(teams: teamList)
                }
            }
            
            /// Update Parameters
            DispatchQueue.main.async {
                self.connectionState = .active
            }

            
            /// Helper Functions
            func decodeDataStorageBundle(_ data: Data) -> DataStorageBundleForWatch? {
                do {
                    let dataStorageBundle = try JSONDecoder().decode(DataStorageBundleForWatch.self, from: data)
                    return dataStorageBundle
                } catch {
                    print("Failed to decode team data: \(error.localizedDescription)")
                }
                return nil
            }
            
            func isMoreRecentData(_ data: DataStorageBundleForWatch) -> Bool {
                let oldTimeStamp: Date? = self.timeStamp
                let newTimeStamp: Date = data.timeStamp
                
                if let safeOldTimeStamp = oldTimeStamp {
                    if newTimeStamp > safeOldTimeStamp {
                        return true
                    } else {
                        return false
                    }
                } else {
                    return true
                }
            }
            
            func updateLocalData(_ dataStorageBundle: DataStorageBundleForWatch) {
                DispatchQueue.main.async {
                    self.teamList = dataStorageBundle.teamScores.filter(){$0.isActive}
                }
            }
        }
        
    }
    
    //MARK: - No Response
    var timeoutDuration: TimeInterval = 3.0
    func noResponseHandler() {
        print(#function)
        DispatchQueue.main.asyncAfter(deadline: .now() + timeoutDuration) {
            switch self.connectionState {
            case .initializingConnection:
                break
            case .active:
                break
            case .pendingReponse:
                self.timeoutDuration = 3.0
                self.connectionState = .noResponse
                self.sendMessageToiPhone(messageType: .requestTeamList)
            case .noResponse:
                self.timeoutDuration = 3.0
                self.connectionState = .critical
                self.sendMessageToiPhone(messageType: .requestTeamList)
            case .critical:
                self.timeoutDuration = self.timeoutDuration < 30 ? (self.timeoutDuration * 2) : 60
                self.sendMessageToiPhone(messageType: .requestTeamList)
            }

            print("no reponse handler operation complete: connection State is \(self.connectionState)")
        }
    }
    
    
}
