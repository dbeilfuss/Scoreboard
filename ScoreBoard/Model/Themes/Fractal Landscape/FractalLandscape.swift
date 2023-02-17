//
//  blue1.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/19/23.
//


import UIKit

class FractalLandscape {
    
    //MARK: - Template Theme
    var templateTheme: Theme
    init () {
        templateTheme = Theme(
            
            /// Definition
            name: "Fractal Landscape",
            
            /// Background
            backgroundImage: UIImage.init(named: "fractalLandscapeBlue1")!,
            
            /// Fonts
            titleFont: UIFont(name: "DIN Alternate Bold", size: 70)!,
            subtitleFont: UIFont(name: "DIN Alternate Bold", size: 50)!,
            scoreFont: UIFont(name: "DIN Alternate Bold", size: 175)!,
            
            /// Font Colors
            titleColor: UIColor.white,
            subtitleColor: UIColor.white,
            scoreColor: UIColor.white,
            
            /// Text Shadows
            shadowColor: UIColor.black,
            shadowWidth: 3,
            shadowHeight: 1,
            
            /// Button Colors
            buttonColor: UIColor.clear,
            buttonSelectedColor: UIColor.white,
            
            /// Dark Mode
            darkMode: true
            
        )
    }
    
    //MARK: - Themes List
    
    var themeList: [Theme] {[
        fLTheme1,
        fLTheme2,
        fLTheme3,
        fLTheme4,
        fLTheme5,
        fLTheme6,
        fLTheme7,
        fLTheme8,
        fLTheme9,
        fLTheme10,
        fLTheme11,
        fLTheme12,
        fLTheme13,
        fLTheme14,
        fLTheme15,
        fLTheme16,
        fLTheme17
    ]}
    
    //MARK: - Themes Actual
    var fLTheme1: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Blue Steel"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeBlue1")!
        return modifiedTheme
    }
    
    var fLTheme2: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Azure"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeBlue2")!
        return modifiedTheme
    }
    
    var fLTheme3: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Cobalt"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeBlue3")!
        return modifiedTheme
    }
    
    var fLTheme4: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Periwinkle"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeBlue4")!
        return modifiedTheme
    }
    
    var fLTheme5: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Fire"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeFire1")!
        return modifiedTheme
    }
    
    var fLTheme6: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Emerald"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeGreen1")!
        return modifiedTheme
    }
    
    var fLTheme7: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Hunter"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeGreen2")!
        return modifiedTheme
    }
    
    var fLTheme8: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Seafoam"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeGreen3")!
        return modifiedTheme
    }
    
    var fLTheme9: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Mint"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeGreen4")!
        return modifiedTheme
    }
    
    var fLTheme10: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Ocean Sky"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeOcean1")!
        return modifiedTheme
    }
    
    var fLTheme11: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Dolphin"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeOcean2")!
        return modifiedTheme
    }
    
    var fLTheme12: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Saphire"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeOcean3")!
        return modifiedTheme
    }
    
    var fLTheme13: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Purple Rain"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapePurple1")!
        return modifiedTheme
    }
    
    var fLTheme14: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Amethyst"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapePurple2")!
        return modifiedTheme
    }
    
    var fLTheme15: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Wisteria"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapePurple3")!
        return modifiedTheme
    }
    
    var fLTheme16: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Alabaster"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeWhite1")!
        return modifiedTheme
    }
    
    var fLTheme17: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Ivory"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeWhite2")!
        return modifiedTheme
    }
    
}
