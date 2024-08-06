//
//  Team.swift
//  scoreboardWatchPreview Watch App
//
//  Created by Daniel Beilfuss on 8/3/24.
//

import Foundation

struct Team: Codable, Equatable {    
    var number: Int
    var name: String
    var score: Int
    var isActive: Bool
}
