//
//  ControlState.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 5/27/24.
//

import UIKit

struct ScoreboardState: Codable {
    var themeName: String
    var pointIncrement: Double
    var uiIsHidden: Bool
}

enum SignInState {
    case signedIn
    case notSignedIn
}

enum DataSource {
    case local
    case cloud
}
