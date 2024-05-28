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
    @IBOutlet weak var scoreStepper: UIStepper!
    
    //MARK: - Variables
    var teamInfo: Team = Team(number: 1, name: "Default Team", score: 0, isActive: false)
    var delegate: TeamCellDelegate?
    
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
        let xibView = Bundle.main.loadNibNamed("TeamView", owner: self, options: nil)![0] as! UIView
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(xibView)
    }
    
    //MARK: - Set
        
    func set(teamInfo: Team) {
        nameLabel.text = teamInfo.name
        scoreLabel.text = String(teamInfo.score)
        scoreStepper.value = Double(teamInfo.score)
    }
    
    func set(controlState: ControlState) {
        print("updating for controlState")
        // Deconstruct
        let theme = controlState.theme
        let pointIncrement = controlState.pointIncrement
        let uiIsHidden = controlState.uiIsHidden
        print("uiIsHidden: \(uiIsHidden)")
        
        // Theme
        theme.format(teamNameLabel: nameLabel)
        theme.format(scoreLabel: scoreLabel)

        // ScoreStepper
        scoreStepper.stepValue = Double(pointIncrement)
        scoreStepper.layer.opacity = uiIsHidden ? 0 : 100
    }
    
    func set(delegate: TeamCellDelegate) {
        self.delegate = delegate
    }
    
    //MARK: - Actions
    
    @IBAction func scoreStepperPressed(_ sender: UIStepper) {
        let newScore = teamInfo.score + Int(sender.value)
        let teamNumber = teamInfo.number
        delegate?.updateScore(newScore: newScore, teamIndex: teamNumber)
    }

}
