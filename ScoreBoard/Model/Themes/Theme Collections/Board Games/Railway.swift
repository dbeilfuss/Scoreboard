//
//  Railway.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/21/23.
//

import UIKit

class Railway {
    
    let theme = Theme(
        
        /// Definition
        name: "Railway",
        
        /// Background
        backgroundImage: UIImage.init(named: "TrainBridge"),
        backgroundOverlayOpacity: 0.0,
        
        /// Fonts
        titleFontName: nil,
        titleFontSize: nil,
        titleFont: nil,

        subtitleFontName: "DIN Alternate Bold",
        subtitleFontSize: 75,
        subtitleFont: UIFont(name: "DIN Alternate Bold", size: 50),

        scoreFontName: "DIN Alternate Bold",
        scoreFontSize: 175,
        scoreFont: UIFont(name: "DIN Alternate Bold", size: 175),

        /// Font Colors
        titleColor: nil,
        subtitleColor: UIColor.init(red: 0.621, green: 0.178, blue: 0.131, alpha: 1),
        scoreColor: UIColor.init(red: 0.621, green: 0.178, blue: 0.131, alpha: 1),
        
        /// Text Shadows
        shadowColor: UIColor.white,
        shadowWidth: 2,
        shadowHeight: 1,
        
        /// Button Colors
        buttonColor: UIColor.systemGray,
        buttonSelectedColor1: UIColor.init(red: 0.621, green: 0.178, blue: 0.131, alpha: 1),
        buttonSelectedColor2: nil,
        buttonHighlightedColor1: nil,
        buttonHighlightedColor2: nil,
        darkMode: false
    
        )
}
