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
        // Save TeamInfo
        self.teamInfo = teamInfo
        
        // Update Labels
        nameLabel.text = teamInfo.name
        scoreLabel.text = String(teamInfo.score)
        print("scoreLabel.text: \(scoreLabel.text!)")
        scoreStepper.value = Double(teamInfo.score)
    }
    
    func set(scoreboardState: ScoreboardState, teamSetup: [Team]) {
        
        // Deconstruct / Gather Information
        let (theme, pointIncrement, uiIsHidden) = (scoreboardState.theme, scoreboardState.pointIncrement, scoreboardState.uiIsHidden)
        let activeTeamsCount = teamSetup.filter() {$0.isActive}.count
        
        // Theme
        theme.format(label: nameLabel, labelType: .teamNameLabel, teamSetup: teamSetup)
        theme.format(label: scoreLabel, labelType: .scoreLabel, teamSetup: teamSetup)

        // ScoreStepper
        scoreStepper.stepValue = Double(pointIncrement)
        scoreStepper.layer.opacity = uiIsHidden ? 0 : 100
    }
    
    func set(delegate: TeamCellDelegate) {
        self.delegate = delegate
    }
    
    //MARK: - Actions
    
    @IBAction func scoreStepperPressed(_ sender: UIStepper) {
        let newScore = Int(sender.value)
        let teamNumber = teamInfo.number
        delegate?.updateScore(newScore: newScore, teamIndex: teamNumber)
    }

}
