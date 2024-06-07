//
//  RemoteTeamViewCell.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 12/23/22.
//

import UIKit

class RemoteTeamViewCell: UITableViewCell, UITextFieldDelegate {
    
    //MARK: - Setup Variables
    var indexRow: Int?
    var delegate: TeamCellDelegate?
    var signInState: SignInState = .notSignedIn

    //MARK: - IBOutlets
    /// Team Name Outlets
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var isActiveSwitch: UISwitch!
    @IBOutlet weak var nameStackView: UIStackView!
    @IBOutlet weak var isActiveSwitchLeading: NSLayoutConstraint!
    @IBOutlet weak var nameStackTrailing: NSLayoutConstraint!
    @IBOutlet weak var nameStackWidth: NSLayoutConstraint!
    @IBOutlet weak var teamNameTrailing: NSLayoutConstraint!
    
    /// Score Outlets
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreStepper: UIStepper!
    @IBOutlet weak var scoreStackView: UIStackView!
    
    //MARK: - AwakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /// Delegate
        teamNameTextField.delegate = self

    }
    
    //MARK: - Setup
    
    func set(index: Int, signInState: SignInState, remoteViewMode: RemoteViewMode, delegate: TeamCellDelegate) {
        
        self.indexRow = index
        self.signInState = signInState
        self.delegate = delegate
        if remoteViewMode == .remoteControl {
            setUIForStandardRemote()
        } else {
            setUIForNameChangeRemote()
        }
        
    }
    
    func set(teamSetup: [Team], pointIncrement: Double) {
        if let index = indexRow {
            let teamData: Team = teamSetup[index]

            teamNameTextField.text = teamData.name
            scoreLabel.text = String(teamData.score)
            isActiveSwitch.isOn = teamData.isActive
            
            scoreStepper.value = Double(teamData.score)
            scoreStepper.stepValue = pointIncrement

        }
    }
    
    //MARK: - Remote Mode Setup
    
    /// Standard Remote
    func setUIForStandardRemote() {
        isActiveSwitchLeading.isActive = true
        teamNameTrailing.isActive = true
    }
    
    /// Name Change Remote
    func setUIForNameChangeRemote() {
        print("Name Change Remote")
        
        /// Hide UnNeeded Views
        scoreStackView.isHidden = true
        
        /// Re-Orient Team Name Stack View
        nameStackView.axis = .horizontal
//        nameStackTrailing.isActive = true
        
        nameStackWidth.isActive = true
    }
    
    //MARK: - Required Table Functions
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func isActiveToggled(_ sender: UISwitch) {
        delegate?.updateIsActive(isActive: sender.isOn, teamIndex: indexRow!)
    }
    
    @IBAction func scoreStepperPressed(_ sender: UIStepper) {
        delegate?.updateScore(newScore: Int(sender.value), teamIndex: indexRow!)
    }
    
    //MARK: - Name Change
    @IBAction func nameChanged(_ sender: UITextField) {
        delegate?.updateName(newName: sender.text ?? "", teamIndex: indexRow!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        teamNameTextField.resignFirstResponder()
        return true
    }
    
}

protocol TeamCellDelegate {
    func updateScore (newScore: Int, teamIndex: Int)
    func updateIsActive (isActive: Bool, teamIndex: Int)
    func updateName (newName: String, teamIndex: Int)
}
