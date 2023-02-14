//
//  Team.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 12/2/22.
//

import Foundation

struct Team: Encodable, Decodable {
    var number: Int = 1
    var name: String = "Team 1"
    var score: Int = 0
    var isActive: Bool = true
}
