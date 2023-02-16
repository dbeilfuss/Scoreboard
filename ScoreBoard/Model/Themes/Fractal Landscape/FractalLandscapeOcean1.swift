//
//  FractalLandscapeOcean1.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/20/23.
//

import UIKit

class FractalLandscapeOcean1: FractalLandscape {
    
    var theme: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Ocean Sky"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeOcean1")!
        return modifiedTheme
    }
    
}
