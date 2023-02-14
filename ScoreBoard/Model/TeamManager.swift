//
//  TeamManager.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 12/2/22.
//

import Foundation
import UIKit


class TeamManager: SettingsDelegate {
    
    //MARK: - Team List
    
    let startingTeamList = [
        Team(),
        Team(number: 2, name: "Team 2", isActive: true),
        Team(number: 3, name: "Team 3", isActive: false),
        Team(number: 4, name: "Team 4", isActive: false),
        Team(number: 5, name: "Team 5", isActive: false),
        Team(number: 6, name: "Team 6", isActive: false),
        Team(number: 7, name: "Team 7", isActive: false),
        Team(number: 8, name: "Team 8", isActive: false)
        ]
    
    var teamList = [
        Team(),
        Team(number: 2, name: "Team 2", isActive: true),
        Team(number: 3, name: "Team 3", isActive: false),
        Team(number: 4, name: "Team 4", isActive: false),
        Team(number: 5, name: "Team 5", isActive: false),
        Team(number: 6, name: "Team 6", isActive: false),
        Team(number: 7, name: "Team 7", isActive: false),
        Team(number: 8, name: "Team 8", isActive: false)
        ]
    
    func resetTeams() {
        teamList = startingTeamList
    }
    
    func resetTeamNames() {
        for i in 0...(teamList.count - 1) {
            teamList[i].name = startingTeamList[i].name
        }
    }
    
    //MARK: - Scores
    
    func replaceScore(teamNumber: Int, newScore: Int) {
        teamList[teamNumber - 1].score = newScore
    }
    
    func fetchScores() -> [Int] {
        let scores = teamList.map { $0.score }
        return scores
    }
    
    func addToScore(teamNumber: Int, scoreToAdd: Int) {
        teamList[teamNumber - 1].score += scoreToAdd
    }
    
    func recordTeamInfo(teamInfo: Team) {
        let teamInfoToReplace = self.teamList[teamInfo.number - 1]
        if teamInfoToReplace.name != teamInfo.name || teamInfoToReplace.score != teamInfo.score || teamInfoToReplace.isActive != teamInfo.isActive {
            teamList[teamInfo.number - 1] = teamInfo
        }
        
    }
    
    //MARK: - TeamIsActive
    
    func updateTeamIsActive(teamNumber: Int, isActive: Bool){
        teamList[teamNumber - 1].isActive = isActive
    }
    
    func fetchTeamIsActive(teamNumber: Int) -> Bool {
        return teamList[teamNumber - 1].isActive
    }
    
    func fetchTeamIsActive(indexNumber: Int) -> Bool {
        return teamList[indexNumber].isActive
    }
    
    func fetchIsActiveList() -> [Bool] {
        let isActiveList = teamList.map { $0.isActive }
        return isActiveList
    }
    
    //MARK: - Team Names
    
    func updateTeamName(teamNumber: Int, name: String){
        teamList[teamNumber - 1].name = name
    }
    
    func fetchTeamName(teamNumber: Int) -> String {
        return teamList[teamNumber].name
    }
    
    func fetchNames() -> [String] {
        let names = teamList.map { $0.name }
        return names
    }

    
    //MARK: - Reset & Cancel
    func resetScores(resetScoreValue: Int) {
        for i in 0...teamList.count - 1 {
            teamList[i].score = resetScoreValue
        }
    }
    
    func prepForCancel() -> [Team] {
        return teamList
    }
    
    func cancel(oldTeamList: [Team]) {
        teamList = oldTeamList
    }
        
}


