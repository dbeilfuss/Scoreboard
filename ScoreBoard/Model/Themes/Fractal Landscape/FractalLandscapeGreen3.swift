//
//  FractalLandscapeGreen3.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/20/23.
//

import UIKit

class FractalLandscapeGreen3: FractalLandscape {
    
    var theme: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Seafoam"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeGreen3")!
        return modifiedTheme
    }
    
}
