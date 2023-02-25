//
//  SignInButton.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 12/21/22.
//

import UIKit

class SignInButton: UIButton {
    
    var tintColorNormal: UIColor?
    var tintColorHighlighted: UIColor?
    
    var titleColorNormal: UIColor?
    var titleColorHighlighted: UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButton()

    }
    
    func setupButton() {
        
        setTitle("Sign In To Use", for: UIControl.State.normal);
        setImage(UIImage(systemName: "person.crop.circle.badge.checkmark"), for: .normal);
        setTintColor(color: .systemGray5, for: .normal)
        setTitleColor(.systemGray, for: .normal)

        setTitle("Sign Out", for: UIControl.State.highlighted);
        setImage(UIImage(systemName: "person.crop.circle.fill.badge.minus"), for: .highlighted)
        setTintColor(color: .systemGray, for: .highlighted)
        setTitleColor(.systemGray, for: .highlighted)

        
    }
    
    
    func setTintColor(color: UIColor, for state: UIControl.State) {
        if state == .normal {
            tintColorNormal = color
        } else if state == .highlighted {
            tintColorHighlighted = color
        }
    }
    
    /*
    func setTitleColor(color: UIColor, for state: UIControl.State) {
        if state == .normal {
            titleColorNormal = color
        } else if state == .highlighted {
            titleColorSelected = color
        }
    }
     */
    
    func buttonPressed() {
        if self.isHighlighted == true {
            self.isHighlighted = false
        } else {
            self.isHighlighted = true
        }
        
        updateTintColor()
//        updateTitleColor()
        
    }
    
    func updateTintColor() {
        if self.isHighlighted {
            self.tintColor = tintColorHighlighted
        } else {
            self.tintColor = tintColorNormal
        }
    }
    
    /*
    func updateTitleColor() {
        if self.isHighlighted {
            self.tintColor = tintColorHighlighted
        } else {
            self.tintColor = tintColorNormal
        }
    }
     */
    
}
