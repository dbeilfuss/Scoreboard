//
//  FractalLandscapeWhite1.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/20/23.
//

import UIKit

class FractalLandscapeWhite1: FractalLandscape {
    
    var theme: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Alabaster"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeWhite1")!
        return modifiedTheme
    }
    
}
