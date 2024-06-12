//
//  WelcomeScreenDatabase.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/31/23.
//

import UIKit

struct WelcomeScreenDatabase {
    
    /// Data
    let tableData: [String] = [
        "Scoreboard",
        "Remote Control"
        ]
    
    /// Themes
    var themeAssignments: [String: Theme] {[
        tableData[0]: ThemesDatabase().fetchTheme(for: Constants().defaultScoreboardState.themeName),
        tableData[1]: RemoteControlTheme().theme
    ]}
    
    /// Icons
    var buttonIcons: [String: UIImage] {[
        tableData[0]: scoreboardIcon,
        tableData[1]: UIImage(systemName: "appletvremote.gen2")!
    ]}
    
    var scoreboardIcon: UIImage {
        if UIDevice.current.localizedModel == "iPad" {
            return UIImage(systemName: "ipad.gen2.landscape")!
        } else if UIDevice.current.localizedModel == "iPhone" {
            return UIImage(systemName: "iphone.gen2.landscape")!
        } else {
            return UIImage(systemName: "tv")!
        }
    }
    
}
