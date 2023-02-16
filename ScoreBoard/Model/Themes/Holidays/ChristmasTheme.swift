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
        backgroundImage: UIImage.init(named: "Christmas Background Zoomed")!,
        
        /// Fonts
        titleFont: UIFont(name: "Rockwell Bold", size: 45)!,
        subtitleFont: UIFont(name: "Rockwell Bold", size: 40)!,
        scoreFont: UIFont(name: "Marker Felt Wide", size: 175)!,

        /// Font Colors
        titleColor: UIColor.systemRed,
        subtitleColor: UIColor.systemRed,
        scoreColor: UIColor.systemRed,
        
        /// Text Shadows
        shadowColor: UIColor.white,
        shadowWidth: 3,
        shadowHeight: 1,
        
        /// Button Colors
        buttonColor: UIColor.systemGray,
        buttonSelectedColor: UIColor.systemRed,
        
        /// Dark Mode
        darkMode: false
        
        )
}
