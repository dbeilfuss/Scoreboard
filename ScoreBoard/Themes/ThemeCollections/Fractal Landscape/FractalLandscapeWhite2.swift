//
//  FractalLandscapeWhite2.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/20/23.
//

import UIKit

class FractalLandscapeWhite2: FractalLandscape {
    
    var theme: Theme {
        Theme(
            
        /// Definition
        name: "Ivory",
        
        /// Background
        backgroundImage: UIImage.init(named: "fractalLandscapeWhite2"),
        backgroundOverlayOpacity: 0.0,
        
        /// Fonts
        titleFontName: fractalLandscapeTemplate.titleFontName,
        titleFontSize: fractalLandscapeTemplate.titleFontSize,
        titleFont: fractalLandscapeTemplate.titleFont,

        subtitleFontName: fractalLandscapeTemplate.subtitleFontName,
        subtitleFontSize: fractalLandscapeTemplate.subtitleFontSize,
        subtitleFont: fractalLandscapeTemplate.subtitleFont,
        
        scoreFontName: fractalLandscapeTemplate.scoreFontName,
        scoreFontSize: fractalLandscapeTemplate.scoreFontSize,
        scoreFont: fractalLandscapeTemplate.scoreFont,
        
        /// Font Colors
        titleColor: UIColor.black,
        subtitleColor: UIColor.black,
        scoreColor: UIColor.black,
        
        /// Text Shadows
        shadowColor: UIColor.clear,
        shadowWidth: 0,
        shadowHeight: 0,
        
        /// Button Colors
        buttonColor: fractalLandscapeTemplate.buttonColor,
        buttonSelectedColor1: fractalLandscapeTemplate.buttonSelectedColor1,
        buttonSelectedColor2: fractalLandscapeTemplate.buttonSelectedColor2,
        buttonHighlightedColor1: fractalLandscapeTemplate.buttonHighlightedColor1,
        buttonHighlightedColor2: fractalLandscapeTemplate.buttonHighlightedColor2,

        /// Dark Mode
        darkMode: false
        )
    }
}
