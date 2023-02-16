//
//  FractalLandscapeOcean3.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/20/23.
//

import UIKit

class FractalLandscapeOcean3: FractalLandscape {
    
    var theme: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Saphire"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeOcean3")!
        return modifiedTheme
    }
    
}
