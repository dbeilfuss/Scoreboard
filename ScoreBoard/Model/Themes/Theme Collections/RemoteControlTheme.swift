//
//  RemoteControlTheme.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 12/27/22.
//

import UIKit

class RemoteControlTheme {
    
    let theme = Theme(
        
        /// Definition
        name: "Remote Control",
        
        /// Background
        backgroundImage: nil,
        backgroundOverlayOpacity: nil,
        
        /// Fonts
        titleFontName: nil,
        titleFontSize: nil,
        titleFont: nil,

        subtitleFontName: nil,
        subtitleFontSize: nil,
        subtitleFont: nil,

        scoreFontName: nil,
        scoreFontSize: nil,
        scoreFont: nil,

        /// Font Colors
        titleColor: nil,
        subtitleColor: nil,
        scoreColor: nil,
        
        /// Text Shadows
        shadowColor: UIColor.clear,
        shadowWidth: 0,
        shadowHeight: 0,
        
        /// Button Colors
        buttonColor: UIColor.systemGray5,
        buttonSelectedColor1: UIColor.systemGreen,
        buttonSelectedColor2: UIColor.systemRed,
        buttonHighlightedColor1: UIColor.systemGreen,
        buttonHighlightedColor2: UIColor.systemRed,
        darkMode: true

    )
}
