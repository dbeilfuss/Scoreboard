//
//  WatchDataManager.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 8/3/24.
//

import Foundation
import WatchConnectivity

struct WatchDataManager {
    func sendTeamDataToWatch(_ teams: [Team]) {
        if WCSession.default.isReachable {
            do {
                let data = try JSONEncoder().encode(teams)
                let message = ["teams": data]
                WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
                    print("Error sending message: \(error.localizedDescription)")
                })
            } catch {
                print("Failed to encode team data: \(error.localizedDescription)")
            }
        }
    }
}
