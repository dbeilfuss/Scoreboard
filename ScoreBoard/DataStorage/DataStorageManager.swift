//
//  DataStorageManager.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 6/10/24.
//

import Foundation
import Firebase

class DataStorageManager {
    
    let constants = Constants()
    var remoteDataManager: RemoteDataManagerProtocol?
    
    var teamManager: TeamManagerProtocol?
    var themeManager: ThemeManagerProtocol?
    
}

//MARK: - Extensions

extension DataStorageManager: MVCDelegate {
    func initializeMVCs(_ mvcArrangement: MVCArrangement) {
        teamManager = mvcArrangement.teamManager
        themeManager = mvcArrangement.themeManager
        
        if teamManager == nil || themeManager == nil {
            print("failed to initializeMVCs: \(#fileID)")
        } else {
            print("initializeMVCs successful: \(#fileID)")
        }
        
        // Cloud Storage
        setupRemoteDataManager(
            teamManager: mvcArrangement.teamManager,
            themeManager: mvcArrangement.themeManager,
            scoreboardViewController: mvcArrangement.scoreboardViewController)
    }
}

extension DataStorageManager: DataStorageManagerProtocol {
    //MARK: - Setup
    
    func setupRemoteDataManager(
        teamManager: TeamManagerProtocol?,
        themeManager: ThemeManagerProtocol?,
        scoreboardViewController: ScoreBoardViewControllerProtocol?) {
        remoteDataManager = RemoteDataManager(
            teamManager: teamManager,
            themeManager: themeManager,
            viewController: scoreboardViewController)
    }
    
    //MARK: - Teams

    var storedTeams: [Team]? {
        let defaults = UserDefaults.standard
        let key = constants.teamCollectionKey
        
        if let savedData = defaults.data(forKey: key) {
            if let decodedTeams = try? JSONDecoder().decode([Team].self, from: savedData) {
                return decodedTeams
            } else {
                print("⛔️ Failed to decode teams. File: \(#fileID)")
            }
        } else {
            print("⛔️ No data found for key: \(key). File: \(#fileID)")
        }
        return nil
    }
    
    func populateInitialTeamData() {
        remoteDataManager?.fetchTeams(closure: saveRemoteTeamData(_:))
        
        func saveRemoteTeamData (_ teamData:[Team]?) {
            if teamData != nil {
                saveTeams(teamData!, dataSource: .cloud)
            }
        }
    }
    
    func saveTeams(_ teams: [Team], dataSource: DataSource) {
        let defaults = UserDefaults.standard
        let key = constants.teamCollectionKey
        
        if let encodedTeamData = try? JSONEncoder().encode(teams) {
            if constants.printTeamFlow {
                print("saving Teams to local storage, \(#fileID)")
            }
            defaults.set(encodedTeamData, forKey: key)
            
            if dataSource == .local {
                if constants.printTeamFlow {
                    print("saving Teams to remote storage, \(#fileID)")
                }
                remoteDataManager?.saveTeams(teams, dataSource: dataSource)
                if constants.printTeamFlow {
                    print("Teams saved successfully, file: \(#fileID).")
                }
            }
        } else {
            print("Failed to encode teams.")
        }
        
    }

    
    //MARK: - State
    
    
    func populateInitialThemeData() {
        remoteDataManager?.fetchTheme(closure: saveRemoteThemeData(_:))
        
        func saveRemoteThemeData (_ themeName:String?) {
            if themeName != nil {
                saveTheme(named: themeName!, dataSource: .cloud)
            }
        }
    }
    
    func saveTheme(named themeName: String, dataSource: DataSource) {
        if constants.printThemeFlow {
            print("Saving Theme: \(themeName), File: \(#fileID)")
        }
        
        var scoreboardState = storedState
        scoreboardState.themeName = themeName
        saveScoreboardState(scoreboardState)
        
        remoteDataManager?.saveTheme(named: themeName, dataSource: dataSource)
    }
    
    var storedState: ScoreboardState {
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
        return constants.defaultScoreboardState    }
        
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
            print("Updated ScoreboardState: \(String(describing: storedState)), File: \(#fileID), Func: \(#function)")
        }
    }
    
    func savePointIncrement(_ pointIncrement: Double) {
        var scoreboardState = storedState
        
        scoreboardState.pointIncrement = pointIncrement
        saveScoreboardState(scoreboardState)
    }
    
    func toggleUIIsHidden() {
        var scoreboardState = storedState
        
        scoreboardState.uiIsHidden = !scoreboardState.uiIsHidden
        saveScoreboardState(scoreboardState)
    }

    
}
