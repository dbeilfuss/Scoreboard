//
//  FractalLandscapeGreen2.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/20/23.
//

import UIKit

class FractalLandscapeGreen2: FractalLandscape {
    
    var theme: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Hunter"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeGreen2")!
        return modifiedTheme
    }
    
}
