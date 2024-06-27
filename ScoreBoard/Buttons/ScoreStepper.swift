//
//  ScoreStepper.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 6/26/24.
//

import UIKit

class ScoreStepper: UIStepper {
    
    let k = Constants()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        self.autorepeat = false // To prevent DDOS style attack, also resolves issue where holding stepper in remote app effects random team scores.
    }
    
}
