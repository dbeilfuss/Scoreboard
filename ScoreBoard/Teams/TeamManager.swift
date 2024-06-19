//
//  TeamManager.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 12/2/22.
//

import Foundation
import UIKit


class TeamManager {
    
    let constants = Constants()
    var databaseManager: DataStorageManagerProtocol?
    var viewController: ScoreBoardViewControllerProtocol?
    
    var teamDataIsFetched = false
    
    //MARK: - Team List
    
    let startingTeamList = [
        Team(number: 1, name: "Team 1", score: 0, isActive: true),
        Team(number: 2, name: "Team 2", score: 0, isActive: true),
        Team(number: 3, name: "Team 3", score: 0, isActive: false),
        Team(number: 4, name: "Team 4", score: 0, isActive: false),
        Team(number: 5, name: "Team 5", score: 0, isActive: false),
        Team(number: 6, name: "Team 6", score: 0, isActive: false),
        Team(number: 7, name: "Team 7", score: 0, isActive: false),
        Team(number: 8, name: "Team 8", score: 0, isActive: false)
    ]
    
    private var teamList = [
        Team(number: 1, name: "Team 1", score: 0, isActive: true),
        Team(number: 2, name: "Team 2", score: 0, isActive: true),
        Team(number: 3, name: "Team 3", score: 0, isActive: false),
        Team(number: 4, name: "Team 4", score: 0, isActive: false),
        Team(number: 5, name: "Team 5", score: 0, isActive: false),
        Team(number: 6, name: "Team 6", score: 0, isActive: false),
        Team(number: 7, name: "Team 7", score: 0, isActive: false),
        Team(number: 8, name: "Team 8", score: 0, isActive: false)
    ]
    
    //MARK: - Reset
    
    func resetTeams() {
        teamList = startingTeamList
        saveTeamsToDataStorage(dataSource: .local)
    }
    
    func resetTeamNames() {
        for i in 0...(teamList.count - 1) {
            teamList[i].name = startingTeamList[i].name
        }
        saveTeamsToDataStorage(dataSource: .local)
    }
    
    func resetScores() {
        for i in 0...teamList.count - 1 {
            teamList[i].score = 0
        }
        saveTeamsToDataStorage(dataSource: .local)
    }
    
    //MARK: - Fetch
    
    func fetchTeamsFromDataStorage() {
        if !teamDataIsFetched {
            if constants.printTeamFlow {
                print("fetching teams from dataStorage, \(#fileID)")
            }
            if let storedTeams = databaseManager?.loadTeams() {
                teamList = storedTeams
            } else {
                teamList = startingTeamList
                saveTeamsToDataStorage(dataSource: .local)
            }
            teamDataIsFetched = true
        }
    }
    
    func fetchTeamList() -> [Team] {
        if constants.printTeamFlowDetailed {
            print("fetching teamList, \(#fileID)")
        }
        fetchTeamsFromDataStorage()
        return teamList
    }
    
    func fetchTeamInfo(teamNumber: Int) -> Team? {
        if constants.printTeamFlowDetailed {
            print("fetching teamInfo, \(#fileID)")
        }
        fetchTeamsFromDataStorage()
        return teamList.first() {$0.number == teamNumber}
    }
    
    func fetchScores() -> [Int] {
        if constants.printTeamFlowDetailed {
            print("fetching scores, \(#fileID)")
        }
        fetchTeamsFromDataStorage()
        let scores = teamList.map { $0.score }
        return scores
    }
    
    func fetchTeamIsActive(teamNumber: Int) -> Bool {
        if constants.printTeamFlowDetailed {
            print("fetching teamIsActive, \(#fileID)")
        }
        fetchTeamsFromDataStorage()
        return teamList[teamNumber - 1].isActive
    }
    
    func fetchTeamIsActive(indexNumber: Int) -> Bool {
        if constants.printTeamFlowDetailed {
            print("fetching teamIsActive, \(#fileID)")
        }
        fetchTeamsFromDataStorage()
        return teamList[indexNumber].isActive
    }
    
    func fetchActiveTeams() -> [Team] {
        if constants.printTeamFlowDetailed {
            print("fetching activeTeams, \(#fileID)")
        }
        fetchTeamsFromDataStorage()
        let activeTeamList = teamList.filter { $0.isActive }
        return activeTeamList
    }
    
    func fetchActiveTeamNumbers() -> [Int] {
        if constants.printTeamFlowDetailed {
            print("fetching activeTeamNumbers, \(#fileID)")
        }
        fetchTeamsFromDataStorage()
        let activeTeamNumbers = teamList.filter({ $0.isActive }).map() {$0.number}
        return activeTeamNumbers
    }
    
    func fetchTeamName(teamNumber: Int) -> String { // Deprecate?
        if constants.printTeamFlowDetailed {
            print("fetching teamName, \(#fileID)")
        }
        fetchTeamsFromDataStorage()
        return teamList[teamNumber].name // Shouldn't this be teamNumber - 1 ?
    }
    
    func fetchTeamNames() -> [String] {
        if constants.printTeamFlowDetailed {
            print("fetching teamNames, \(#fileID)")
        }
        fetchTeamsFromDataStorage()
        let names = teamList.map { $0.name }
        return names
    }
    
    //MARK: - Update
    
    func refreshData() {
        if constants.printTeamFlow {
            print("refreshing Data, \(#fileID)")
        }
        teamDataIsFetched = false
        teamList = fetchTeamList()
        viewController?.refreshUIForTeams()
    }
    
    func saveTeamsToDataStorage(dataSource: DataSource) {
        if databaseManager == nil {
            print("databaseManager == nil ? \(databaseManager == nil)")
        } else {
            if constants.printTeamFlow {
                print("savingTeamsToDataStorage, datasource: \(dataSource), \(#fileID)")
            }
        }
        
        databaseManager?.saveTeams(teamList, dataSource: dataSource)
    }
    
    func replaceScore(teamNumber: Int, newScore: Int) {
        if constants.printTeamFlow {
            print("replacing score, \(#fileID)")
        }
        teamList[teamNumber - 1].score = newScore
        saveTeamsToDataStorage(dataSource: .local)
    }
    
    func addToScore(teamNumber: Int, scoreToAdd: Int) {
        if constants.printTeamFlow {
            print("adding to score, \(#fileID)")
        }
        teamList[teamNumber - 1].score += scoreToAdd
        saveTeamsToDataStorage(dataSource: .local)
    }
    
    func saveTeam(_ team: Team, datasource: DataSource) {
        
        if constants.printTeamFlow {
            print("saving team, \(#fileID)")
        }
        
        let teamIndex = team.number - 1
        teamList[teamIndex] = team
        
        saveTeamsToDataStorage(dataSource: datasource)
        
        if datasource == .cloud {
            viewController?.refreshUIForTeams()
        }
    }
    
    func updateTeamIsActive(teamNumber: Int, isActive: Bool){
        if constants.printTeamFlow {
            print("updating teamIsActive, \(#fileID)")
        }
        teamList[teamNumber - 1].isActive = isActive
        saveTeamsToDataStorage(dataSource: .local)
    }
    
    func updateTeamName(teamNumber: Int, name: String){
        if constants.printTeamFlow {
            print("updating team, \(#fileID)")
        }
        teamList[teamNumber - 1].name = name
        saveTeamsToDataStorage(dataSource: .local)
    }
}

//MARK: - Extensions

extension TeamManager: MVCDelegate {
    func initializeMVCs(_ mvcArrangement: MVCArrangement) {
        viewController = mvcArrangement.scoreboardViewController
        databaseManager = mvcArrangement.databaseManager
        
        if viewController == nil || databaseManager == nil {
            print("failed to initializeMVCs: \(#fileID)")
        } else {
            print("initializeMVCs successful: \(#fileID)")
        }
    }
}

extension TeamManager: TeamManagerProtocol {
}
