//
//  Team.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 12/2/22.
//

import Foundation
#if !os(watchOS)
import FirebaseFirestore
#endif

struct Team: Codable, Equatable {
    var number: Int
    var name: String
    var score: Int
    var isActive: Bool
}
