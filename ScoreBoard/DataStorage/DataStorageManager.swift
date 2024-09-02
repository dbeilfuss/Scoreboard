//
//  DataStorageManager.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 6/10/24.
//

import Foundation
import FirebaseFirestore

class DataStorageManager {
    
    var constants = Constants()
    var remoteStorageManager: DataStorageProtocol = RemoteStorageManager()
    var localStorageManager: DataStorageProtocol = LocalStorageManager()
    var dataStorageDelegate: DataStorageDelegate?
    let watchDataManager: DataStorageDelegate = WatchConnection()
    
    var teamManager: DataStorageDelegate?
    var themeManager: DataStorageDelegate?
    
    init() {
        localStorageManager.listenForUpdates(completion: self.localDataUpdated(_:))
        remoteStorageManager.listenForUpdates(completion: self.remoteDataUpdated(_:))
    }
    
}

//MARK: - Extensions

extension DataStorageManager: MVCDelegate {
    func initializeMVCs(_ mvcArrangement: MVCArrangement) {
        
        // Team & Theme Managers
        teamManager = mvcArrangement.teamManager as? DataStorageDelegate
        if let watchManager = watchDataManager as? WatchConnection {
            watchManager.teamManager = self.teamManager as? any TeamManagerProtocol
        }
        themeManager = mvcArrangement.themeManager  as? DataStorageDelegate
        
        if teamManager == nil || themeManager == nil {
            print("failed to initializeMVCs: \(#fileID)")
        } else {
            print("initializeMVCs successful: \(#fileID)")
        }
                
    }
}

extension DataStorageManager: DataStorageManagerProtocol {
    
    func saveData(_ data: DataStorageBundle) {
        print("saving data - \(#fileID)")
        localStorageManager.saveData(data)
        remoteStorageManager.saveData(data)
        print("sending to Watch")
    }
    
    func requestData() -> DataStorageBundle {
        if let dataStorageBundle = localStorageManager.fetchData() {
            return dataStorageBundle
        }
        
        return constants.defaultDataStorageBundle
    }
    
    func requestData(completion: (DataStorageBundle) -> Void) {
        let localData = requestData()
        var mostRecentData: DataStorageBundle = localData
        
        if let remoteData = remoteStorageManager.fetchData() {
            mostRecentData = compareData(dataBundle1: localData, dataBundle2: remoteData)
        }
        
        completion(mostRecentData)
        
    }
    
    func remoteDataUpdated(_ dataStorageBundle: DataStorageBundle) {
        let remoteData = dataStorageBundle
        var mostRecentData = remoteData
        if let localData = localStorageManager.fetchData() {
            mostRecentData = compareData(dataBundle1: remoteData, dataBundle2: localData)
        }
        
        let mostRecentDataSource: DataSource = mostRecentData.timeStamp == remoteData.timeStamp ? .cloud : .local
        
        if mostRecentDataSource == .cloud {
            localStorageManager.saveData(mostRecentData)
        } else {
            remoteStorageManager.saveData(mostRecentData)
        }
        
    }
    
    func localDataUpdated(_ localDataStorageBundle: DataStorageBundle) {
            let localData = localDataStorageBundle
        updateDelegates(localDataStorageBundle, dataSource: .local) // Update the UI immediately with local data

            // Fetch remote data asynchronously
            remoteStorageManager.fetchData { remoteData in
                guard let remoteData = remoteData else {
                    print("Error fetching remote data - \(#fileID)")
                    return
                }

                // Compare local and remote data
                let mostRecentData = self.compareData(dataBundle1: localData, dataBundle2: remoteData)
                let mostRecentDataSource: DataSource = mostRecentData.timeStamp == remoteData.timeStamp ? .cloud : .local

                if mostRecentDataSource == .cloud {
                    self.localStorageManager.saveData(mostRecentData)
                } else {
                    self.remoteStorageManager.saveData(mostRecentData)
                }
            }
        }
    
    func compareData(dataBundle1: DataStorageBundle, dataBundle2: DataStorageBundle) -> DataStorageBundle {
        var mostRecentData: DataStorageBundle = dataBundle1

        if dataBundle1.timeStamp != dataBundle2.timeStamp {
            if dataBundle1.timeStamp.dateValue() < dataBundle2.timeStamp.dateValue() {
                mostRecentData = dataBundle2
            }
        }
        
        return mostRecentData
    }
    
    func updateDelegates(_ dataStorageBundle: DataStorageBundle, dataSource: DataSource) {
        // Parameters
        var delegates = [teamManager, themeManager, watchDataManager]
        if dataSource == .watch { delegates.removeAll(where: { $0 is WatchConnection })}
        
        // Update
        for delegate in delegates {
            delegate?.dataStorageUpdated(dataStorageBundle)
        }
    }
    
    
    //MARK: - Teams
    
    func saveTeams(_ teams: [Team]) {
        if constants.printTeamFlow {
            print("saving teams to dataStorage - \(#fileID)")
        }
        if constants.printTeamFlowDetailed {
            print(teams)
        }
        var dataStorageBundle = requestData()
        dataStorageBundle.teamScores = teams
        dataStorageBundle.timeStamp = Timestamp(date: Date())
        
        saveData(dataStorageBundle)
        if constants.printTeamFlowDetailed {
            print("‼️ teamManager == nil:  \(teamManager == nil) - \(#fileID)")
        }
        teamManager?.dataStorageUpdated(dataStorageBundle)
    }
    
    //MARK: - Themes
    
    func saveTheme(named themeName: String) {
        var dataStorageBundle = requestData()
        dataStorageBundle.themeName = themeName
        dataStorageBundle.timeStamp = Timestamp(date: Date())
        
        saveData(dataStorageBundle)
        themeManager?.dataStorageUpdated(dataStorageBundle)
        
    }

    
    //MARK: - State
    func loadScoreboardState() -> ScoreboardState {
        let defaults = UserDefaults.standard
        let key = constants.scoreboardStateKey
        
        if let savedData = defaults.data(forKey: key) {
            if let decodedState = try? JSONDecoder().decode(ScoreboardState.self, from: savedData) {
                return decodedState
            } else {
                print("⛔️ Failed to decode scoreboardState. File: \(#fileID)")
            }
        } else {
            print("⛔️ No data found for key: \(key), File: \(#fileID)")
        }
        return constants.defaultScoreboardState
    }
        
    private func saveScoreboardState(_ state: ScoreboardState) {
        let defaults = UserDefaults.standard
        let key = constants.scoreboardStateKey
        
        if let encoded = try? JSONEncoder().encode(state) {
            defaults.set(encoded, forKey: key)
            if constants.printStateFlow {
                print("ScoreboardState saved successfully. File: \(#fileID), Func: \(#function)")
            }
        } else {
            print("Failed to encode scoreboardState. File: \(#fileID)")
        }
        
        if constants.printStateFlow {
            print("Updated ScoreboardState: \(String(describing: loadScoreboardState())), File: \(#fileID), Func: \(#function)")
        }
    }
    
    func savePointIncrement(_ pointIncrement: Double) {
        var scoreboardState = loadScoreboardState()
        
        scoreboardState.pointIncrement = pointIncrement
        saveScoreboardState(scoreboardState)
    }
    
    func toggleUIIsHidden() {
        var scoreboardState = loadScoreboardState()
        
        scoreboardState.uiIsHidden = !scoreboardState.uiIsHidden
        saveScoreboardState(scoreboardState)
    }

}

protocol DataStorageProtocol {
    // Save Data
    func saveData(_: DataStorageBundle)
    
    // Fetch Data
    func fetchData(completion: @escaping (DataStorageBundle?) -> Void)
    func fetchData() -> DataStorageBundle?

    // Listen For Updates
    mutating func listenForUpdates(completion: @escaping (DataStorageBundle) -> Void)
}

protocol DataStorageDelegate {
    func dataStorageUpdated(_ updatedData: DataStorageBundle)
}
