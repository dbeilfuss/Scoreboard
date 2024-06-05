//
//  LargeTransparentButton.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 2/5/23.
//

import UIKit

class LargeTransparentButton: UIButton {
    
    let k = Constants()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    func setupButton() {
        
        /// Colors
        self.backgroundColor = .clear
        if let fontColor = self.titleLabel?.textColor {
            self.layer.borderColor = fontColor.cgColor
        }

        /// Font
        self.titleLabel?.font = UIFont(name: "Rubik Medium", size: 15)
        
        /// Border
        self.layer.borderWidth = 1
        self.layer.cornerRadius = self.frame.height / 2
        
    }
    
}
