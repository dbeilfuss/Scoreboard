//
//  FractalLandscapeGreen4.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/20/23.
//

import UIKit

class FractalLandscapeGreen4: FractalLandscape {
    
    var theme: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Mint"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeGreen4")!
        return modifiedTheme
    }
    
}
