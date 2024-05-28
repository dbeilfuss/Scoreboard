//
//  Theme.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 12/27/22.
//

import UIKit

struct Theme {
    
    /// Definition
    let name: String
    
    /// Background
    let backgroundImage: UIImage?
    let backgroundOverlayOpacity: Double?
    
    /// Fonts
    let titleFontName: String?
    let titleFontSize: CGFloat?
    let titleFont: UIFont?
    
    let subtitleFontName: String?
    let subtitleFontSize: CGFloat?
    let subtitleFont: UIFont?
    
    let scoreFontName: String?
    let scoreFontSize: CGFloat?
    let scoreFont: UIFont?
    
    /// Font Colors
    let titleColor: UIColor?
    let subtitleColor: UIColor?
    let scoreColor: UIColor?
    
    /// Text Shadows
    let shadowColor: UIColor?
    let shadowWidth: Int?
    let shadowHeight: Int?
    
    /// Button Colors
    let buttonColor: UIColor?
    let buttonSelectedColor1: UIColor?
    let buttonSelectedColor2: UIColor?
    let buttonHighlightedColor1: UIColor?
    let buttonHighlightedColor2: UIColor?
    let darkMode: Bool
    
    func format(teamNameLabel: UILabel) {
        teamNameLabel.font = UIFont(name:subtitleFont!.fontName, size: teamNameLabel.font.pointSize)
        teamNameLabel.textColor = subtitleColor
        teamNameLabel.shadowColor = shadowColor
    }
    
    func format(scoreLabel: UILabel) {
        scoreLabel.font = UIFont(name:subtitleFont!.fontName, size: scoreLabel.font.pointSize)
        scoreLabel.textColor = subtitleColor
        scoreLabel.shadowColor = shadowColor
    }
}

