//
//  FractalLandscapeBlue3.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/20/23.
//

import UIKit

class FractalLandscapeBlue3: FractalLandscape {
    
    var theme: Theme {
        Theme(
            
        /// Definition
        name: "Cobalt",
        
        /// Background
        backgroundImage: UIImage.init(named: "fractalLandscapeBlue3"),
        backgroundOverlayOpacity: 0.5,
        
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
        titleColor: fractalLandscapeTemplate.titleColor,
        subtitleColor: fractalLandscapeTemplate.subtitleColor,
        scoreColor: fractalLandscapeTemplate.scoreColor,
        
        /// Text Shadows
        shadowColor: fractalLandscapeTemplate.shadowColor,
        shadowWidth: fractalLandscapeTemplate.shadowWidth,
        shadowHeight: fractalLandscapeTemplate.shadowHeight,
        
        /// Button Colors
        buttonColor: fractalLandscapeTemplate.buttonColor,
        buttonSelectedColor1: fractalLandscapeTemplate.buttonSelectedColor1,
        buttonSelectedColor2: fractalLandscapeTemplate.buttonSelectedColor2,
        buttonHighlightedColor1: fractalLandscapeTemplate.buttonHighlightedColor1,
        buttonHighlightedColor2: fractalLandscapeTemplate.buttonHighlightedColor2,

        /// Dark Mode
        darkMode: fractalLandscapeTemplate.darkMode
        )
    }
}
