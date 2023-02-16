//
//  blue1.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/19/23.
//


import UIKit

class FractalLandscape {
    
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
    
}
