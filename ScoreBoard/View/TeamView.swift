//
//  TeamView.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 5/16/24.
//

import UIKit
class TeamView: UIView {
    
    //MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewInit()
    }
    
    func viewInit() {
        let xibView = Bundle.main.loadNibNamed("Tips View", owner: self, options: nil)![0] as! UIView
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(xibView)
    }
    
    //MARK: - Set
    
    func set(teamInfo: Team) {
        nameLabel.text = teamInfo.name
        scoreLabel.text = String(teamInfo.score)
    }
    
    func set(theme: Theme) {
        
        // NameLabel
        nameLabel.font = UIFont(name: theme.subtitleFont!.fontName, size: nameLabel.font.pointSize)
        nameLabel.textColor = theme.subtitleColor
        nameLabel.shadowColor = theme.shadowColor
        
        // ScoreLabel
        scoreLabel.font = UIFont(name: theme.scoreFont!.fontName, size: scoreLabel.font.pointSize)
        scoreLabel.textColor = theme.scoreColor
        scoreLabel.shadowColor = theme.shadowColor

    }

}
