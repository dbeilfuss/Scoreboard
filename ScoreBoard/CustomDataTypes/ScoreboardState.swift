//
//  ControlState.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 5/27/24.
//

import UIKit

struct ScoreboardState {
    var theme: Theme
    var pointIncrement: Double
    var uiIsHidden: Bool
}

enum SignInState {
    case signedIn
    case notSignedIn
}
