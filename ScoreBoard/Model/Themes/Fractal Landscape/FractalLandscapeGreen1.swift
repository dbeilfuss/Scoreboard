//
//  FractalLandscapeGreen1.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/20/23.
//

import UIKit

class FractalLandscapeGreen1: FractalLandscape {
    
    var theme: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Emerald"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeGreen1")!
        return modifiedTheme
    }
    
}
