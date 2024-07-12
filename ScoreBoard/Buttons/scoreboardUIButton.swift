//
//  scoreboardUIButton.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 6/2/24.
//

import UIKit

class scoreboardUIButton: UIButton {
    let constants = Constants()
        
    var selfCanHide: Bool = true
    var scoreBoardState: ScoreboardState = Constants().defaultScoreboardState
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .none
    }
    
    func setupButton(state: ScoreboardState) {
        scoreBoardState = state
        if constants.printThemeFlow {
            print("state: \(scoreBoardState), background: \(self.backgroundColor) tint: \(String(describing: self.tintColor)), file: \(#fileID)")
        }
        
        // Theme
        self.tintAdjustmentMode = .normal //to prevent the button reverting to the default tint color
        let theme = ThemeManager().fetchActiveTheme()
        theme.format(button: self)
        
        // HideUI
        if selfCanHide {
            self.isHidden = state.uiIsHidden
        }
    }
    
}
