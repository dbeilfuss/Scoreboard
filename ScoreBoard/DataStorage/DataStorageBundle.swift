//
//  DataStorageBundle.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 7/8/24.
//

import Foundation
import FirebaseFirestore

struct DataStorageBundle: Codable {
    var teamScores: [Team]
    var themeName: String
    var timeStamp: Timestamp
    let dataVersion: Double
    
    init(teamScores: [Team], themeName: String, timeStamp: Timestamp?) {
        self.teamScores = teamScores
        self.themeName = themeName
        self.timeStamp = timeStamp ?? Timestamp(date: Date())
        self.dataVersion = 1.0
    }
}
