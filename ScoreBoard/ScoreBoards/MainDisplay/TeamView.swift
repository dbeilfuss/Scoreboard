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
    @IBOutlet weak var teamStackView: UIStackView!
    @IBOutlet weak var nameLabelHeightConstraint: NSLayoutConstraint!
    
    
    //MARK: - Variables
    var k = Constants()
    var teamInfo: Team = Constants().defaultTeams.first!
    var state: ScoreboardState = Constants().defaultScoreboardState
    var theme: Theme = Constants().defaultTheme
    var delegate: TeamCellDelegate?
    var teamStackViewHeightConstraint: NSLayoutConstraint?
    var superViewWidth: CGFloat = 0.0
    
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
    
    func set(teamInfo: Team){
        
        // Save TeamInfo
        self.teamInfo = teamInfo
        
        // Update Labels
        self.nameLabel.text = teamInfo.name
        self.scoreLabel.text = String(teamInfo.score)
        self.scoreStepper.value = Double(teamInfo.score)
        
    }
    
    func set(scoreboardState: ScoreboardState) {
        
        // Deconstruct / Gather Information
        let (pointIncrement, uiIsHidden) = (scoreboardState.pointIncrement, scoreboardState.uiIsHidden)
        
        // ScoreStepper
        self.scoreStepper.stepValue = Double(pointIncrement)
        self.scoreStepper.layer.isHidden = uiIsHidden ? true : false
    }
    
    func set(theme: Theme) {
        if theme.name != self.theme.name {
            theme.format(label: nameLabel, labelType: .teamNameLabel)
            theme.format(label: scoreLabel, labelType: .scoreLabel)
        }
    }
    
    func set(delegate: TeamCellDelegate?) {
        self.delegate = delegate
    }
    
    var fontSizes: [String: CGFloat] {
        get {
            // Resize Fonts
            let nameLabelSize: CGFloat = adjustNameLabelFontToFitHeight()
            let scoreLabelSize: CGFloat = adjustScoreLabelFontToFitHeight()
            
            // Return Data
            return ["nameLabelSize": nameLabelSize, "scoreLabelSize": scoreLabelSize]
        }
        set {
            if let nameLabelSize = newValue["nameLabelSize"] {
                nameLabel.font = nameLabel.font.withSize(nameLabelSize)
            }
            
            if let scoreLabelSize = newValue["scoreLabelSize"] {
                scoreLabel.font = scoreLabel.font.withSize(scoreLabelSize)
            }
        }
    }
    
    func setStackViewHeight(height: CGFloat, width: CGFloat) {
//        print("height: \(height)")
        let stackViewHeightConstraint = teamStackView.heightAnchor.constraint(equalToConstant: height)
        NSLayoutConstraint.activate([stackViewHeightConstraint])
        self.teamStackViewHeightConstraint = stackViewHeightConstraint
        
//        print("width: \(width) - \(#function)")
        self.superViewWidth = width
    }

    
    //MARK: - Visual Adjustments
    private func adjustNameLabelFontToFitHeight() -> CGFloat {
        print(#function)
        
        if teamStackViewHeightConstraint != nil {
            let ratio = nameLabelHeightConstraint.multiplier
//            print("ratio: \( ratio)")
            let targetHeight = (teamStackViewHeightConstraint!.constant) * ratio * 0.75
//            print("targetHeight: \(targetHeight)")
            nameLabel.font = nameLabel.font.withSize(targetHeight)
            
            return targetHeight
        }
        
        print("⛔️ teamStackViewHeightConstraint == nil")
        return 1
    }
    
    private func adjustScoreLabelFontToFitHeight() -> CGFloat {
        print(#function)
        
        if teamStackViewHeightConstraint != nil {
            var height = teamStackViewHeightConstraint!.constant * 0.4
            let width = superViewWidth
            let minRatio = 0.3
            let actualRatio = height / width
            if actualRatio > minRatio { height = height / 1.25 }
            
            nameLabel.font = nameLabel.font.withSize(height)
            
            return height
        }
        
        print("⛔️ teamStackViewHeightConstraint == nil")
        return 1
    }
    
    //MARK: - Actions
    
    @IBAction func scoreStepperPressed(_ sender: UIStepper) {
        print(#function)

        let newScore = Int(sender.value)
        let teamNumber = teamInfo.number
        
        delegate?.updateScore(newScore: newScore, teamIndex: teamNumber)
    }

}
