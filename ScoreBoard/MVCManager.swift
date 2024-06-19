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
    func resetScores()
    
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
//    func refreshData()
    func fetchActiveTheme() -> Theme
    func saveTheme(named themeName: String, dataSource: DataSource)
    func fetchSpecializedTheme(ofType: SpecializedTheme) -> Theme
    
    // Scoreboard State
    func fetchScoreboardState() -> ScoreboardState
    func toggleUIIsHidden()
    func savePointIncrement(_ pointIncrement: Double)
}

protocol DataStorageManagerProtocol {
    // Teams
    func loadTeams() -> [Team]?
    func saveTeams(_ teams: [Team], dataSource: DataSource)
    
    // Themes
    func saveTheme(named themeName: String, dataSource: DataSource)
    
    // State
    func loadScoreboardState() -> ScoreboardState
    func savePointIncrement(_ pointIncrement: Double)
    func toggleUIIsHidden()
    
}

struct MVCArrangement {
    let databaseManager: DataStorageManagerProtocol
    let scoreboardViewController: ScoreBoardViewControllerProtocol
    let teamManager: TeamManagerProtocol
    let themeManager: ThemeManagerProtocol
}
 
//MARK: - MVCManager

class MVCManager {
    
    let mvcArrangement: MVCArrangement
    
    init(mvcArrangement: MVCArrangement) {
        self.mvcArrangement = mvcArrangement
    }
    
    func initializeMVCArrangement() {
        
        // Ensure the files conform to MVCDelegate Protocol
        let databaseManager = mvcArrangement.databaseManager
        let scoreboardViewController = mvcArrangement.scoreboardViewController
        let teamManager = mvcArrangement.teamManager
        let themesDatabase = mvcArrangement.themeManager
        let possibleMVCs: [Any] = [databaseManager, scoreboardViewController, teamManager, themesDatabase]
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
