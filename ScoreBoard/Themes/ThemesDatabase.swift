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
    
    
    let fractalLandscapeThemeSet: [Theme] = [
        FractalLandscapeBlue1().theme,
        FractalLandscapeBlue2().theme,
        FractalLandscapeBlue3().theme,
        FractalLandscapeBlue4().theme,
        FractalLandscapeFire1().theme,
        FractalLandscapeGreen1().theme,
        FractalLandscapeGreen2().theme,
        FractalLandscapeGreen3().theme,
        FractalLandscapeGreen4().theme,
        FractalLandscapeOcean1().theme,
        FractalLandscapeOcean2().theme,
        FractalLandscapeOcean3().theme,
        FractalLandscapePurple1().theme,
        FractalLandscapePurple2().theme,
        FractalLandscapePurple3().theme,
        FractalLandscapeWhite1().theme,
        FractalLandscapeWhite2().theme
    ]
    
    let cardsAndBoardGames: [Theme] = [
        Railway().theme
    ]
    
    let holidays: [Theme] = [
        ChristmasTheme().theme
    ]
    
}
