//
//  FractalLandscapeOcean2.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/20/23.
//

import UIKit

class FractalLandscapeOcean2: FractalLandscape {
    
    var theme: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Dolphin"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeOcean2")!
        return modifiedTheme
    }
    
}
