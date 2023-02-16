//
//  Theme.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 12/27/22.
//

import UIKit

struct Theme {
    
    /// Definition
    var name: String
    
    /// Background
    var backgroundImage: UIImage
    
    /// Fonts
    var titleFont: UIFont
    var subtitleFont: UIFont
    var scoreFont: UIFont
    
    /// Font Colors
    var titleColor: UIColor
    var subtitleColor: UIColor
    var scoreColor: UIColor
    
    /// Text Shadows
    var shadowColor: UIColor
    var shadowWidth: Int
    var shadowHeight: Int
    
    /// Button Colors
    var buttonColor: UIColor
    var buttonSelectedColor: UIColor

    /// Dark Mode
    var darkMode: Bool
    
}

