//
//  FractalLandscapeBlue4.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/20/23.
//

import UIKit

class FractalLandscapeBlue4: FractalLandscape {
    
    var theme: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Periwinkle"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeBlue4")!
        return modifiedTheme
    }
    
}
