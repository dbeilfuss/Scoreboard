//
//  FractalLandscapePurple1.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/20/23.
//

import UIKit

class FractalLandscapePurple1: FractalLandscape {
    
    var theme: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Purple Rain"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapePurple1")!
        return modifiedTheme
    }
    
}
