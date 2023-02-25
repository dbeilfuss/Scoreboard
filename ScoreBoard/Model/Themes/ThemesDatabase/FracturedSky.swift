//
//  blue1.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/19/23.
//


import UIKit

class FracturedSky {
    
    //MARK: - Template Theme
    var templateTheme: Theme
    init () {
        templateTheme = Theme(
            
            /// Definition
            name: "Fractured Sky",
            
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
        theme1,
        theme2,
        theme3,
        theme4,
        theme5,
        theme6,
        theme7,
        theme8,
        theme9,
        theme10,
        theme11,
        theme12,
        theme13,
        theme14,
        theme15,
        theme16,
        theme17
    ]}
    
    //MARK: - Themes Actual
    var theme1: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Blue Steel"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeBlue1")!
        return modifiedTheme
    }
    
    var theme2: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Azure"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeBlue2")!
        return modifiedTheme
    }
    
    var theme3: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Cobalt"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeBlue3")!
        return modifiedTheme
    }
    
    var theme4: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Periwinkle"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeBlue4")!
        return modifiedTheme
    }
    
    var theme5: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Fire"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeFire1")!
        return modifiedTheme
    }
    
    var theme6: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Emerald"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeGreen1")!
        return modifiedTheme
    }
    
    var theme7: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Hunter"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeGreen2")!
        return modifiedTheme
    }
    
    var theme8: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Seafoam"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeGreen3")!
        return modifiedTheme
    }
    
    var theme9: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Mint"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeGreen4")!
        return modifiedTheme
    }
    
    var theme10: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Ocean Sky"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeOcean1")!
        return modifiedTheme
    }
    
    var theme11: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Dolphin"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeOcean2")!
        return modifiedTheme
    }
    
    var theme12: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Saphire"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeOcean3")!
        return modifiedTheme
    }
    
    var theme13: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Purple Rain"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapePurple1")!
        return modifiedTheme
    }
    
    var theme14: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Amethyst"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapePurple2")!
        return modifiedTheme
    }
    
    var theme15: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Wisteria"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapePurple3")!
        return modifiedTheme
    }
    
    var theme16: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Alabaster"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeWhite1")!
        return modifiedTheme
    }
    
    var theme17: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Ivory"
        modifiedTheme.backgroundImage = UIImage.init(named: "fractalLandscapeWhite2")!
        return modifiedTheme
    }
    
}
