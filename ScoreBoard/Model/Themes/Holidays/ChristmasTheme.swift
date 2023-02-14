//
//  ChristmasTheme.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 12/28/22.
//

import UIKit

class ChristmasTheme {
    
    let theme = Theme(
        
        /// Definition
        name: "Christmas",
        
        /// Background
        backgroundImage: UIImage.init(named: "Christmas Background Zoomed"),
        backgroundOverlayOpacity: 0.0,
        
        /// Fonts
        titleFontName: nil,
        titleFontSize: nil,
        titleFont: nil,
        
        subtitleFontName: "Rockwell Bold",
        subtitleFontSize: 40,
        subtitleFont: UIFont(name: "Rockwell Bold", size: 40),

        
        scoreFontName: "Marker Felt Wide",
        scoreFontSize: 175,
        scoreFont: UIFont(name: "Marker Felt Wide", size: 175),

        /// Font Colors
        titleColor: nil,
        subtitleColor: UIColor.systemRed,
        scoreColor: UIColor.systemRed,
        
        /// Text Shadows
        shadowColor: UIColor.white,
        shadowWidth: 3,
        shadowHeight: 1,
        
        /// Button Colors
        buttonColor: UIColor.systemGray,
        buttonSelectedColor1: UIColor.systemRed,
        buttonSelectedColor2: nil,
        buttonHighlightedColor1: nil,
        buttonHighlightedColor2: nil,
        darkMode: false
    
        )
}
