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
    
    ///Contraints
    
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
        
    func set(teamInfo: Team){
        // Save TeamInfo
        self.teamInfo = teamInfo
        
        // Update Labels
        nameLabel.text = teamInfo.name
        scoreLabel.text = String(teamInfo.score)
        scoreStepper.value = Double(teamInfo.score)

    }
    
    func set(scoreboardState: ScoreboardState, theme: Theme) {
        
        // Deconstruct / Gather Information
        let (pointIncrement, uiIsHidden) = (scoreboardState.pointIncrement, scoreboardState.uiIsHidden)
        
        // Theme
        theme.format(label: nameLabel, labelType: .teamNameLabel, parentWidth: teamStackView.frame.width)
        theme.format(label: scoreLabel, labelType: .scoreLabel, parentWidth: teamStackView.frame.width)

        // ScoreStepper
        scoreStepper.stepValue = Double(pointIncrement)
        scoreStepper.layer.opacity = uiIsHidden ? 0 : 100
        
        // Label Experimentation
//        adjustFontSizeToFitHeight(label: nameLabel)
//        adjustFontSizeToFitHeight(label: scoreLabel)
    }
    
    func set(delegate: TeamCellDelegate?) {
        self.delegate = delegate
    }
    
    var fontSizes: [String: CGFloat] {
        get {

            
            // Resize Fonts
            let nameLabelSize: CGFloat = adjustFontSizeToFitHeight(label: nameLabel)
            let scoreLabelSize: CGFloat = adjustFontSizeToFitHeight(label: scoreLabel)

            
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
    

    
    //MARK: - Visual Adjustments
    private func adjustFontSizeToFitHeight(label: UILabel) -> CGFloat {
        let testString: String = "GgYyPp123$"
        
        print("getting font sizes")
        // Original Text
        let originalNameText = nameLabel.text
        let originalScoreText = scoreLabel.text
        
        // Set label.text to Test String
        nameLabel.text = testString
        scoreLabel.text = testString
        
        // Find Max Font Size
        guard let text = label.text else { return label.font.pointSize }
        
        let maxHeight = label.frame.height
        let maxWidth = label.frame.width
        
        var fontSize = maxHeight // Start with the label's height as the initial font size
        print("beginning font sizefor \(label): \(fontSize)")
        
        let constraintSize = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        
        while fontSize > 0 {
            // Set the font size
            label.font = label.font.withSize(fontSize)
            
            // Calculate the bounding box of the text with the current font size
            let boundingBox = text.boundingRect(with: constraintSize, options: .usesLineFragmentOrigin, attributes: [.font: label.font as Any], context: nil)
            
            // Check if the text fits within the label's bounds
            if boundingBox.height <= maxHeight {
                break
            }
            
            // Decrease the font size and try again
            fontSize -= 1
        }
        
        // Reset label.text to Original Text
        nameLabel.text = originalNameText
        scoreLabel.text = originalScoreText
        
        print("ending font size: \(fontSize)")

        return label.font.pointSize
    }
    
    //MARK: - Actions
    
    @IBAction func scoreStepperPressed(_ sender: UIStepper) {
        let newScore = Int(sender.value)
        let teamNumber = teamInfo.number
        delegate?.updateScore(newScore: newScore, teamIndex: teamNumber)
    }

}
