//
//  scoreboardUIButton.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 6/2/24.
//

import UIKit

class ScoreboardUIButton: UIButton {
    let constants = Constants()
        
    var selfCanHide: Bool = true
    var scoreBoardState: ScoreboardState = Constants().defaultScoreboardState
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .none
        setupShadow()
        
        func setupShadow() {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.7
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowRadius = 15
        }
    }
    
    func setupButton(state: ScoreboardState, theme: Theme) {
        scoreBoardState = state
        if constants.printThemeFlow {
            print("state: \(scoreBoardState), background: \(String(describing: self.backgroundColor)) tint: \(String(describing: self.tintColor)), file: \(#fileID)")
        }
        
        // Theme
        self.tintAdjustmentMode = .normal //to prevent the button reverting to the default tint color
        theme.format(button: self)
        
        // HideUI
        if selfCanHide {
            self.isHidden = state.uiIsHidden
        }
    }
    
}
