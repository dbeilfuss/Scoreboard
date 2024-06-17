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
    var cloudDataStorageManager: CloudDataStorageManagerProtocol?
    
    var teamManager: TeamManagerProtocol?
    var themeManager: ThemeManagerProtocol?
    
    //MARK: - Teams
    
    func saveTeams(_ teams: [Team], dataSource: DataSource) {
        let defaults = UserDefaults.standard
        let key = constants.teamCollectionKey
        
        if let encoded = try? JSONEncoder().encode(teams) {
            defaults.set(encoded, forKey: key)
            
            if dataSource == .local {
                cloudDataStorageManager?.saveTeams(teams, dataSource: dataSource)
                if constants.printTeamFlow {
                    print("Teams saved successfully, file: \(#fileID).")
                }
            }
        } else {
            print("Failed to encode teams.")
        }
        
    }
    
    func loadTeams() -> [Team]? {
        let defaults = UserDefaults.standard
        let key = constants.teamCollectionKey
        
        if let savedData = defaults.data(forKey: key) {
            if let decodedTeams = try? JSONDecoder().decode([Team].self, from: savedData) {
                return decodedTeams
            } else {
                print("Failed to decode teams.")
            }
        } else {
            print("No data found for key: \(key)")
        }
        return nil
    }
    
//    func updateTeam(_ updatedTeam: Team) {
//        var teams = loadTeams() ?? []
//        if let index = teams.firstIndex(where: { $0.number == updatedTeam.number }) {
//            teams[index] = updatedTeam
//        } else {
//            teams.append(updatedTeam)
//        }
//        saveTeams(teams)
//    }
    
    //MARK: - UI
    
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
    
    func loadScoreboardState() -> ScoreboardState {
        let defaults = UserDefaults.standard
        let key = constants.scoreboardStateKey
        
        if let savedData = defaults.data(forKey: key) {
            if let decodedTeams = try? JSONDecoder().decode(ScoreboardState.self, from: savedData) {
                return decodedTeams
            } else {
                print("Failed to decode scoreboardState. File: \(#fileID), Func: \(#function)")
            }
        } else {
            print("No data found for key: \(key)")
        }
        return constants.defaultScoreboardState
    }
    
    func toggleUIIsHidden() {
        var scoreboardState = loadScoreboardState()
        
        scoreboardState.uiIsHidden = !scoreboardState.uiIsHidden
        saveScoreboardState(scoreboardState)
    }
    
    func savePointIncrement(_ pointIncrement: Double) {
        var scoreboardState = loadScoreboardState()
        
        scoreboardState.pointIncrement = pointIncrement
        saveScoreboardState(scoreboardState)
    }
        
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
        cloudDataStorageManager = RemoteControlTransmitter(teamManager: mvcArrangement.teamManager, themeManager: mvcArrangement.themeManager, viewController: mvcArrangement.scoreboardViewController)
    }
}

extension DataStorageManager: DataStorageManagerProtocol {
    func implementTheme(named themeName: String, dataSource: DataSource) {
        if constants.printThemeFlow {
            print("Implementing Theme: \(themeName), File: \(#fileID)")
        }
        saveTheme(named: themeName)
        themeManager?.refreshData()
        
        if dataSource == .local {
            cloudDataStorageManager?.saveTheme(named: themeName)
        }
    }
    
    func saveTheme(named theme: String) {
        if constants.printThemeFlow {
            print("Saving Theme: \(theme), File: \(#fileID)")
        }
        var scoreboardState = loadScoreboardState()
        scoreboardState.themeName = theme
        saveScoreboardState(scoreboardState)
    }
//    
//    func recordTeamInfo(teamInfo: Team) {
//        teamManager?.saveTeam(teamInfo, datasource: .cloud)
//    }
    
}
