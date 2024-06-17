//
//  MVCManager.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 6/12/24.
//

import Foundation

//MARK: - Protocols

protocol MVCDelegate {
    func initializeMVCs(_ mvcArrangement: MVCArrangement)
}

protocol ScoreBoardViewControllerProtocol {
    // Refresh
    func refreshUIForTheme()
    func refreshUIForTeams()
    
    // Other
    func userFeedback(feedback: String)
}

protocol TeamManagerProtocol {
    
    // Reset
    func resetTeams()
    func resetTeamNames()
    func resetScores(resetScoreValue: Int)
    
    // Fetch
    func fetchTeamList() -> [Team]
    func fetchTeamInfo(teamNumber: Int) -> Team?
    func fetchScores() -> [Int]
    func fetchActiveTeams() -> [Team]
    func fetchActiveTeamNumbers() -> [Int]
    
    // Update
    func refreshData()
    func replaceScore(teamNumber: Int, newScore: Int)
    func addToScore(teamNumber: Int, scoreToAdd: Int)
    func updateTeamIsActive(teamNumber: Int, isActive: Bool)
    func updateTeamName(teamNumber: Int, name: String)
    func saveTeam(_ team: Team, datasource: DataSource)
}

protocol ThemeManagerProtocol {
    // Themes
    func refreshData()
    func fetchActiveTheme() -> Theme
    func implementTheme(named themeName: String, dataSource: DataSource)
    
    // Scoreboard State
    func fetchScoreboardState() -> ScoreboardState
    func toggleUIIsHidden()
    func savePointIncrement(_ pointIncrement: Double)
}

protocol DataStorageManagerProtocol {
    // Teams
//    func recordTeamInfo(teamInfo: Team)
    func loadTeams() -> [Team]?
    func saveTeams(_ teams: [Team], dataSource: DataSource)
    
    // Themes
    func implementTheme(named themeName: String, dataSource: DataSource)
    func saveTheme(named theme: String)
    
    // State
    func loadScoreboardState() -> ScoreboardState
    func toggleUIIsHidden()
    func savePointIncrement(_ pointIncrement: Double)

}

struct MVCArrangement {
    let scoreboardViewController: ScoreBoardViewControllerProtocol
    let teamManager: TeamManagerProtocol
    let themeManager: ThemeManagerProtocol
    let databaseManager: DataStorageManagerProtocol
}
 
//MARK: - MVCManager

class MVCManager {
    
    let mvcArrangement: MVCArrangement
    
    init(mvcArrangement: MVCArrangement) {
        self.mvcArrangement = mvcArrangement
    }
    
    func initializeMVCArrangement() {
        
        // Ensure the files conform to MVCDelegate Protocol
        let scoreboardViewController = mvcArrangement.scoreboardViewController
        let teamManager = mvcArrangement.teamManager
        let themesDatabase = mvcArrangement.themeManager
        let databaseManager = mvcArrangement.databaseManager
        let possibleMVCs: [Any] = [scoreboardViewController, teamManager, themesDatabase, databaseManager]
        var mvcArray: [MVCDelegate] = []
        var i = 0
        
        for possibleMVC in possibleMVCs {
            if let mvc = possibleMVC as? MVCDelegate {
                mvcArray.append(mvc)
            } else {
                let error = "possibleMVC at index \(i) does not conform to the MVCDelegate Protocol"
                print("Error: \(error) - File: \(#fileID)")
            }
            i += 1
        }
        
        // Initialize the MVCs
        for i in 0...(mvcArray.count - 1) {
            mvcArray[i].initializeMVCs(self.mvcArrangement)
        }
        
    }

}
