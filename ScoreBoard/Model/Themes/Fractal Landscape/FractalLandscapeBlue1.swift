//
//  Blue1.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/20/23.
//

import UIKit

class FractalLandscapeBlue1: FractalLandscape {
    
    var theme: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Blue Steel"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeBlue1")!
        return modifiedTheme
    }
    
}
