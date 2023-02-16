//
//  FractalLandscapeFire1.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/20/23.
//

import UIKit

class FractalLandscapeFire1: FractalLandscape {
    
    var theme: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Fire"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeFire1")!
        return modifiedTheme
    }
    
}
