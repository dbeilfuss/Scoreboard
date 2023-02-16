//
//  FractalLandscapePurple3.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/20/23.
//

import UIKit

class FractalLandscapePurple3: FractalLandscape {
    
    var theme: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Wisteria"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapePurple3")!
        return modifiedTheme
    }
    
}
