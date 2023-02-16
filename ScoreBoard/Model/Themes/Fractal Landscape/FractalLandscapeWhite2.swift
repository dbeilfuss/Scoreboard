//
//  FractalLandscapeWhite2.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/20/23.
//

import UIKit

class FractalLandscapeWhite2: FractalLandscape {
    
    var theme: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Ivory"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeWhite2")!
        return modifiedTheme
    }
    
}
