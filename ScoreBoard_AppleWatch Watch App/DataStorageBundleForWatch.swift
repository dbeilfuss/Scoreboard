//
//  DataStorageBundle.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 7/8/24.
//

import Foundation

struct DataStorageBundleForWatch: Codable {
    var teamScores: [Team]
    var themeName: String
    var timeStamp: Date
    let dataVersion: Double
    
    init(teamScores: [Team], themeName: String) {
        self.teamScores = teamScores
        self.themeName = themeName
        self.timeStamp = Date()
        self.dataVersion = 1.0
    }
}
