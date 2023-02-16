//
//  FractalLandscapeBlue3.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/20/23.
//

import UIKit

class FractalLandscapeBlue3: FractalLandscape {
    
    var theme: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Cobalt"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeBlue3")!
        return modifiedTheme
    }
    
}
