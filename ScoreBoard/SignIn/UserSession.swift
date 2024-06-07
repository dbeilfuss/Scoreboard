//
//  UserSession.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 6/6/24.
//

import Foundation

class UserSession {
    static let shared = UserSession()

    // Logged In
    var loggedInState: SignInState = .notSignedIn
    var userEmail: String?

    private init() { } // Prevents direct initialization

}
