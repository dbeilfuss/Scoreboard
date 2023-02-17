//
//  ThemesDatabase.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/21/23.
//

import UIKit

class ThemesDatabase {
    
    var themeGroupsByName: [String: [Theme]] {[
        "Fractal Landscape": fractalLandscapeThemeSet,
        "Board Games": cardsAndBoardGames,
        "Holidays": holidays
    ]}
    
    var themeGroups: [[Theme]] {[
        fractalLandscapeThemeSet,
        cardsAndBoardGames,
        holidays
    ]}
    
    
    let fractalLandscapeThemeSet: [Theme] = FractalLandscape().themeList
    
    let cardsAndBoardGames: [Theme] = [
        Railway().theme
    ]
    
    let holidays: [Theme] = [
        ChristmasTheme().theme
    ]
    
}
