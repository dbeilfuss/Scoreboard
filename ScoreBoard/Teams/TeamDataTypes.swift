//
//  Team.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 12/2/22.
//

import Foundation
import FirebaseFirestore

struct Team: Codable, Equatable {
    var number: Int
    var name: String
    var score: Int
    var isActive: Bool
}
