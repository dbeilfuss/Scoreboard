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
        backgroundImage: UIImage.init(named: "BackgroundDark")!,
        
        /// Fonts
        titleFont: UIFont.systemFont(ofSize: 17),
        subtitleFont: UIFont.systemFont(ofSize: 17),
        scoreFont: UIFont.systemFont(ofSize: 17),

        /// Font Colors
        titleColor: UIColor.label,
        subtitleColor: UIColor.label,
        scoreColor: UIColor.label,
        
        /// Text Shadows
        shadowColor: UIColor.clear,
        shadowWidth: 0,
        shadowHeight: 0,
        
        /// Button Colors
        buttonColor: UIColor.systemGray5,
        buttonSelectedColor: UIColor.systemGreen,
        
        /// Dark Mode
        darkMode: true

    )
}
