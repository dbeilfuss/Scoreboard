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
        backgroundImage: UIImage.init(named: "TrainBridge")!,
        
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
