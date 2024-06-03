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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButton(constants.defaultTheme)
    }
    
    func setupButton(_ theme: Theme) {
        
    }
    
    func setupButton(_ state: ScoreboardState) {
        
        // Opacity
        if selfCanHide {
            self.isHidden = state.uiIsHidden
        }
    }
    
}
