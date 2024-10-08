//
//  Theme.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 12/27/22.
//

import UIKit

enum LabelType {
    case teamNameLabel
    case scoreLabel
}

struct FontSet {
    let fontName: String
    let fontSize: CGFloat
    let font: UIFont
}

struct Theme: Equatable {
    
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
    
    func format(label: UILabel, labelType: LabelType) {
        
        // Create FontSet
        var fontSet: FontSet
        switch labelType {
        case .scoreLabel:
            fontSet = FontSet(fontName: scoreFontName!, fontSize: 10, font: scoreFont!)
        case .teamNameLabel:
            fontSet = FontSet(fontName: subtitleFontName!, fontSize: 10, font: subtitleFont!)
        }
        
        // Font
        label.font = UIFont(name:fontSet.fontName, size: label.font.pointSize)
        
        // Size
//        resizeFonts(label: label, themeFont: fontSet.font, activeTeamCount: activeTeamCount, parentWidth: parentWidth)
        
        // Color
        label.textColor = subtitleColor
        label.shadowColor = shadowColor
    }
//    
//    func resizeFonts(label: UILabel, themeFont: UIFont, activeTeamCount: Int, parentWidth: CGFloat) {
//                
//        /// Determine the appropriate font point size
//        let themeFontSize: CGFloat = themeFont.pointSize
//        let device: String = UIDevice.current.localizedModel
//        
//        var sizeMultiplyers: [Int: CGFloat] {
//            if device == "iPad" {
//                return TeamTextSizeStruct().iPadSizes
//            } else {
//                return TeamTextSizeStruct().iPhoneSizes
//            }
//        }
//        let adjustedFontSize: CGFloat = (themeFontSize * sizeMultiplyers[activeTeamCount]!).rounded() // rounded to prevent uiLabel issues (collapsing)
//        
//        /// Resize all point sizes to adjusted size
//        label.font = UIFont(name: label.font.fontName, size: adjustedFontSize)
//        label.shadowOffset.height = label.shadowOffset.height * sizeMultiplyers[activeTeamCount]! + 0.5
//        label.shadowOffset.width = label.shadowOffset.width * sizeMultiplyers[activeTeamCount]! + 0.5
//    }
    
    func format(button: UIButton) {
        button.tintColor = buttonColor
        if button.isSelected {
            button.tintColor = buttonSelectedColor1
        }
    }
    
    func format(background: UIImageView) {
        background.image = backgroundImage
    }
}
