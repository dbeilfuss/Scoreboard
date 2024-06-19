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
    var teamManager: TeamManagerProtocol?
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
    
    func set(index: Int, signInState: SignInState, remoteViewMode: RemoteViewMode, teamManager: TeamManagerProtocol) {
        
        self.indexRow = index
        self.signInState = signInState
        self.teamManager = teamManager
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
        
        /// Hide UnNeeded Views
        scoreStackView.isHidden = true
        
        /// Re-Orient Team Name Stack View
        nameStackView.axis = .horizontal
        nameStackWidth.isActive = true
    }
    
    //MARK: - Required Table Functions
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func isActiveToggled(_ sender: UISwitch) {
        if indexRow != nil {
            teamManager?.updateTeamIsActive(teamNumber: indexRow! + 1, isActive: sender.isOn)
        }
    }
    
    @IBAction func scoreStepperPressed(_ sender: UIStepper) {
        if indexRow != nil {
            teamManager?.replaceScore(teamNumber: indexRow! + 1, newScore: Int(sender.value))
        }
    }
    
    //MARK: - Name Change
    @IBAction func nameChanged(_ sender: UITextField) {
        if indexRow != nil {
            teamManager?.updateTeamName(teamNumber: indexRow! + 1, name: sender.text ?? "")
        }
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
