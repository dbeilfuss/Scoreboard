//
//  blue1.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/19/23.
//


import UIKit

class FractalLandscape {
    
    let fractalLandscapeTemplate = Theme(
        
        /// Definition
        name: "Fractal Landscape",
        
        /// Background
        backgroundImage: nil,
        backgroundOverlayOpacity: 0.0,

        /// Fonts
        titleFontName: nil,
        titleFontSize: nil,
        titleFont: nil,
        
        subtitleFontName: "DIN Alternate Bold",
        subtitleFontSize: 45,
        subtitleFont: UIFont(name: "DIN Alternate Bold", size: 50),
        
        scoreFontName: "DIN Alternate Bold",
        scoreFontSize: 175,
        scoreFont: UIFont(name: "DIN Alternate Bold", size: 175),

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
        buttonSelectedColor1: UIColor.white,
        buttonSelectedColor2: UIColor.white,
        buttonHighlightedColor1: nil,
        buttonHighlightedColor2: nil,
        
        /// Dark Mode
        darkMode: true

    )
    
}
