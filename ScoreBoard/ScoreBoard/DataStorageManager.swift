//
//  DataStorageManager.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 6/10/24.
//

import Foundation

struct DataStorageManager {
    
    let constants = Constants()
    
    //MARK: - Teams
    
    func saveTeams(_ teams: [Team]) {
        let defaults = UserDefaults.standard
        let key = constants.teamCollectionKey
        
        if let encoded = try? JSONEncoder().encode(teams) {
            defaults.set(encoded, forKey: key)
            print("Teams saved successfully.")
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
    
    func updateTeam(_ updatedTeam: Team) {
        var teams = loadTeams() ?? []
        if let index = teams.firstIndex(where: { $0.number == updatedTeam.number }) {
            teams[index] = updatedTeam
        } else {
            teams.append(updatedTeam)
        }
        saveTeams(teams)
    }
    
    //MARK: - UI
    
    private func saveScoreboardState(_ state: ScoreboardState) {
        let defaults = UserDefaults.standard
        let key = constants.scoreboardStateKey
        
        if let encoded = try? JSONEncoder().encode(state) {
            defaults.set(encoded, forKey: key)
            print("scoreboardState saved successfully.")
        } else {
            print("Failed to encode scoreboardState.")
        }
        
        print("saving state: \(state)")
        print("checking it was saved: \(String(describing: loadScoreboardState()))")
    }
    
    func loadScoreboardState() -> ScoreboardState {
        let defaults = UserDefaults.standard
        let key = constants.scoreboardStateKey
        
        if let savedData = defaults.data(forKey: key) {
            if let decodedTeams = try? JSONDecoder().decode(ScoreboardState.self, from: savedData) {
                return decodedTeams
            } else {
                print("Failed to decode scoreboardState.")
            }
        } else {
            print("No data found for key: \(key)")
        }
        return constants.defaultScoreboardState
    }
    
    func saveTheme(_ theme: Theme) {
        var scoreboardState = loadScoreboardState()

        scoreboardState.themeName = theme.name
        saveScoreboardState(scoreboardState)
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
