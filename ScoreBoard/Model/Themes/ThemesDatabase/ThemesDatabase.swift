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
        "Landscapes": landscapesThemeSet
    ]}
    
    var themeGroups: [[Theme]] {[
        fracturedSkyThemeSet,
        landscapesThemeSet,
        holidays,
    ]}
    
    
    let fracturedSkyThemeSet: [Theme] = FracturedSky().themeList
    
//    let cardsAndBoardGames: [Theme] = [
//        Railway().theme
//    ]
    
    let holidays: [Theme] = [
        ChristmasTheme().theme
    ]
    
    let landscapesThemeSet: [Theme] = Landscapes().themeList
    
}
