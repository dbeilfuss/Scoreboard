//
//  scoreboardUIButton.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 6/2/24.
//

import UIKit

class scoreboardUIButton: UIButton {
    var selfCanHide: Bool = true
    var scoreBoardState: ScoreboardState = Constants().defaultScoreboardState
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupButton(state: ScoreboardState) {
        scoreBoardState = state
        
        // Theme
        state.theme.format(button: self)
        
        // HideUI
        if selfCanHide {
            self.isHidden = state.uiIsHidden
        }
    }
    
}
