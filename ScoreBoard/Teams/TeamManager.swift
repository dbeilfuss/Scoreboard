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
    
    let dataStorage = DataStorageManager()
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
    
    //MARK: - Data Storage
    func fetchTeamsFromDataStorage() {
        if !teamDataIsFetched {
            if let storedTeams = dataStorage.loadTeams() {
                teamList = storedTeams
            } else {
                teamList = startingTeamList
                saveTeamsToDataStorage()
            }
            teamDataIsFetched = true
        }
    }
    
    func saveTeamsToDataStorage() {
        dataStorage.saveTeams(teamList)
    }
    
    //MARK: - Teams
    
    func fetchTeamList() -> [Team] {
        fetchTeamsFromDataStorage()
        return teamList
    }
    
    func resetTeams() {
        teamList = startingTeamList
        saveTeamsToDataStorage()
    }
    
    func resetTeamNames() {
        for i in 0...(teamList.count - 1) {
            teamList[i].name = startingTeamList[i].name
        }
        saveTeamsToDataStorage()
    }
    
    func fetchTeamInfo(teamNumber: Int) -> Team? {
        fetchTeamsFromDataStorage()
        return teamList.first() {$0.number == teamNumber}
    }
    
    //MARK: - Scores
    
    func replaceScore(teamNumber: Int, newScore: Int) {
        teamList[teamNumber - 1].score = newScore
        saveTeamsToDataStorage()
    }
    
    func fetchScores() -> [Int] {
        fetchTeamsFromDataStorage()
        let scores = teamList.map { $0.score }
        return scores
    }
    
    func addToScore(teamNumber: Int, scoreToAdd: Int) {
        teamList[teamNumber - 1].score += scoreToAdd
        saveTeamsToDataStorage()
    }
    
    func recordTeamInfo(teamInfo: Team) {
        let teamInfoToReplace = self.teamList[teamInfo.number - 1]
        if teamInfoToReplace.name != teamInfo.name || teamInfoToReplace.score != teamInfo.score || teamInfoToReplace.isActive != teamInfo.isActive {
            teamList[teamInfo.number - 1] = teamInfo
        }
        saveTeamsToDataStorage()
    }
    
    func resetScores(resetScoreValue: Int) {
        for i in 0...teamList.count - 1 {
            teamList[i].score = resetScoreValue
        }
        saveTeamsToDataStorage()
    }
    
    //MARK: - TeamIsActive
    
    func updateTeamIsActive(teamNumber: Int, isActive: Bool){
        teamList[teamNumber - 1].isActive = isActive
        saveTeamsToDataStorage()
    }
    
    func fetchTeamIsActive(teamNumber: Int) -> Bool {
        fetchTeamsFromDataStorage()
        return teamList[teamNumber - 1].isActive
    }
    
    func fetchTeamIsActive(indexNumber: Int) -> Bool {
        fetchTeamsFromDataStorage()
        return teamList[indexNumber].isActive
    }
    
    func fetchActiveTeams() -> [Team] {
        fetchTeamsFromDataStorage()
        let activeTeamList = teamList.filter { $0.isActive }
        return activeTeamList
    }
    
    func fetchActiveTeamNumbers() -> [Int] {
        fetchTeamsFromDataStorage()
        let activeTeamNumbers = teamList.filter({ $0.isActive }).map() {$0.number}
        return activeTeamNumbers
    }
    
    //MARK: - Team Names
    
    func updateTeamName(teamNumber: Int, name: String){
        teamList[teamNumber - 1].name = name
        saveTeamsToDataStorage()
    }
    
    func fetchTeamName(teamNumber: Int) -> String {
        fetchTeamsFromDataStorage()
        return teamList[teamNumber].name
    }
    
    func fetchTeamNames() -> [String] {
        fetchTeamsFromDataStorage()
        let names = teamList.map { $0.name }
        return names
    }
    
}
