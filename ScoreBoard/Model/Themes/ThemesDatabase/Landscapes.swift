//
//  Landscapes.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/21/23.
//

import UIKit

class Landscapes {
    
    
    //MARK: - Template Theme
    var templateTheme: Theme
    init () {
        templateTheme = Theme(
            
            /// Definition
            name: "Landscapes",
            
            /// Background
            backgroundImage: UIImage.init(named: "TrainBridge")!,
            backgroundCenterPoint: BackgroundCenterPoint(x: 8.5, y: 4.5, maxZoom: 0.0),
            
            /// Fonts
            titleFont: UIFont(name: "DIN Alternate Bold", size: 85)!,
            subtitleFont: UIFont(name: "DIN Alternate Bold", size: 50)!,
            scoreFont: UIFont(name: "DIN Alternate Bold", size: 175)!,
            
            /// Font Colors
            titleColor: UIColor.init(red: 0.621, green: 0.178, blue: 0.131, alpha: 1),
            subtitleColor: UIColor.init(red: 0.621, green: 0.178, blue: 0.131, alpha: 1),
            scoreColor: UIColor.init(red: 0.621, green: 0.178, blue: 0.131, alpha: 1),
            
            /// Text Shadows
            shadowColor: UIColor.white,
            shadowWidth: 2,
            shadowHeight: 1,
            
            /// Button Colors
            buttonColor: UIColor.systemGray,
            buttonSelectedColor: UIColor.init(red: 0.621, green: 0.178, blue: 0.131, alpha: 1),
            
            darkMode: false
            
        )
    }
    
    //MARK: - Themes List
    
    var themeList: [Theme] {[
        theme1,
        theme2
    ]}
    
    //MARK: - Themes Actual
    var theme1: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Railway"
        modifiedTheme.backgroundImage = UIImage.init(named: "TrainBridge")!
        return modifiedTheme
    }
    
    var theme2: Theme {
        var modifiedTheme: Theme = templateTheme
        modifiedTheme.name = "Birch Forest"
        modifiedTheme.backgroundImage = UIImage.init(named: "Landscape with birches")!
        modifiedTheme.backgroundCenterPoint = BackgroundCenterPoint(x: 11, y: 4, maxZoom: 1.75)
        return modifiedTheme
    }
    
}
