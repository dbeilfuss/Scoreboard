//
//  Constants.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/30/23.
//

import UIKit
import FirebaseFirestore

struct Constants {
    /// Title
    let appName: String = "Living Room ScoreBoard"
    
    /// Subtitle
    let subtitleMessage: String = ""
    
    /// Title Fonts
    let titleFontIPad: UIFont = UIFont(name: "Rubik-Medium", size: 50) ?? UIFont(name: "Helvetica Neue", size: 50)!
    let titleFontIPhone: UIFont = UIFont(name: "Rubik-Medium", size: 35) ?? UIFont(name: "Helvetica Neue", size: 35)!
    let subTitleFontIPhone: UIFont = UIFont(name: "Rubik-Light", size: 20) ?? UIFont(name: "Helvetica Neue", size: 15)!
    let subTitleFontIPad: UIFont = UIFont(name: "Rubik-Light", size: 25) ?? UIFont(name: "Helvetica Neue", size: 20)!
    
    /// Body Fonts
    let tableFontIPad: UIFont = UIFont(name: "Myriad Pro", size: 30) ?? UIFont(name: "Helvetica Neue", size: 20)!
    let tableFontIPhone: UIFont = UIFont(name: "Myriad Pro", size: 25) ?? UIFont(name: "Helvetica Neue", size: 20)!
    let tableFontiPadSmall: UIFont = UIFont(name: "Rubik-Light", size: 20) ?? UIFont(name: "Helvetica Neue", size: 20)!
    let tableFontiPhoneSmall: UIFont = UIFont(name: "Rubik-Light", size: 15) ?? UIFont(name: "Helvetica Neue", size: 15)!
    
    /// Text Field Fonts
    let textFieldIPad: UIFont = UIFont(name: "Rubik", size: 25) ?? UIFont(name: "Helvetica Neue", size: 25)!
    let textFieldIPhone: UIFont = UIFont(name: "Rubik", size: 20) ?? UIFont(name: "Helvetica Neue", size: 20)!
    
    /// Body Fonts
    let bodyIPad: UIFont = UIFont(name: "Myriad Pro", size: 20) ?? UIFont(name: "Helvetica Neue", size: 20)!
    let bodyIPhone: UIFont = UIFont(name: "Myriad Pro", size: 15) ?? UIFont(name: "Helvetica Neue", size: 15)!
    let bodyIPadSmall: UIFont = UIFont(name: "Myriad Pro", size: 15) ?? UIFont(name: "Helvetica Neue", size: 15)!
    let bodyIPhoneSmall: UIFont = UIFont(name: "Myriad Pro", size: 10) ?? UIFont(name: "Helvetica Neue", size: 10)!
    
    /// Screen Orientations
    let screenOrientationStandardiPhone: UIInterfaceOrientationMask = UIInterfaceOrientationMask.portrait
    let screenOrientationToRotateTo: UIInterfaceOrientation = UIInterfaceOrientation.portrait
    let screenOrientationStandardiPad: UIInterfaceOrientationMask = UIInterfaceOrientationMask.all

    // Defaults
    let defaultTeams: [Team] = [
        Team(number: 1, name: "Team 1", score: 0, isActive: true),
        Team(number: 2, name: "Team 2", score: 0, isActive: true),
        Team(number: 3, name: "Team 3", score: 0, isActive: false),
        Team(number: 4, name: "Team 4", score: 0, isActive: false),
        Team(number: 5, name: "Team 5", score: 0, isActive: false),
        Team(number: 6, name: "Team 6", score: 0, isActive: false),
        Team(number: 7, name: "Team 7", score: 0, isActive: false),
        Team(number: 8, name: "Team 8", score: 0, isActive: false)
    ]
    let defaultTheme = FractalLandscapeBlue1().theme
    let defaultScoreboardState: ScoreboardState = ScoreboardState(pointIncrement: 1, uiIsHidden: false)
    lazy var defaultDataStorageBundle: DataStorageBundle = DataStorageBundle.init(teamScores: defaultTeams, themeName: defaultTheme.name, timeStamp: Timestamp(date: Date(timeIntervalSince1970: 0)))
    
    // DataStorage
    let teamCollectionKey: String = "teams"
    let scoreboardStateKey: String = "scoreboardState"
    
    // Print(Logging)
    let printTeamFlow = true
    let printTeamFlowDetailed = false
    let printThemeFlow = false
    let printStateFlow = false
}
