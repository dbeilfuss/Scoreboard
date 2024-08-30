//
//  ControlState.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 5/27/24.
//

import UIKit

struct ScoreboardState: Codable {
    var pointIncrement: Double
    var uiIsHidden: Bool
}

enum SignInState {
    case signedIn
    case notSignedIn
}

enum DataSource: String, Codable {
    case local
    case cloud
    case watch
}


