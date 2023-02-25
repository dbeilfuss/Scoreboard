//
//  ThemesDatabase.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/21/23.
//

import UIKit

class ThemesDatabase {
    
    var themeGroupsByName: [String: [Theme]] {[
        "Fractured Sky": fracturedSkyThemeSet,
//        "Board Games": cardsAndBoardGames,
        "Holidays": holidays,
        "Landscapes": landscapes
    ]}
    
    var themeGroups: [[Theme]] {[
        fracturedSkyThemeSet,
        cardsAndBoardGames,
        holidays,
    ]}
    
    
    let fracturedSkyThemeSet: [Theme] = FracturedSky().themeList
    
//    let cardsAndBoardGames: [Theme] = [
//        Railway().theme
//    ]
    
    let holidays: [Theme] = [
        ChristmasTheme().theme
    ]
    
    let landscapes: [Theme] = [
        Railway().theme,
        
    ]
    
}
