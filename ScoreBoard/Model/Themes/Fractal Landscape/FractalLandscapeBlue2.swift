//
//  Blue2.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/20/23.
//

import UIKit

class FractalLandscapeBlue2: FractalLandscape {
    
    var theme: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Azure"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeBlue2")!
        return modifiedTheme
    }
    
}
