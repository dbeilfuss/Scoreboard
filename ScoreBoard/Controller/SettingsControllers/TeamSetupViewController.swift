//
//  ChangeNameViewController.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 12/3/22.
//

import UIKit

protocol SettingsDelegate {
    func updateTeamIsActive(teamNumber: Int, isActive: Bool)
    func updateTeamName(teamNumber: Int, name: String)
    func fetchTeamIsActive(teamNumber: Int) -> Bool
    func fetchTeamIsActive(indexNumber: Int) -> Bool
    func fetchTeamName(teamNumber: Int) -> String
    func prepForCancel() -> [Team]
    func cancel(oldTeamList: [Team])
}

protocol UpdateUIDelegate {
    func refreshScreen(reTransmit: Bool)
}

class TeamSetupViewController: UIViewController {
    
    @IBOutlet weak var team1TextBox: UITextField!
    @IBOutlet weak var team2TextBox: UITextField!
    @IBOutlet weak var team3TextBox: UITextField!
    @IBOutlet weak var team4TextBox: UITextField!
    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var switch2: UISwitch!
    @IBOutlet weak var switch3: UISwitch!
    @IBOutlet weak var switch4: UISwitch!
    
    var settingsDelegate: SettingsDelegate?
    var updateUIDelegate: UpdateUIDelegate?
    
    var cancelButtonData: [Team]?
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for thisTextField in textFieldArray() {
            thisTextField.delegate = self
        }
        
        if settingsDelegate?.prepForCancel() != nil {
            cancelButtonData = (settingsDelegate?.prepForCancel())!
        }
        
        var i = 0
        for thisTextBox in textFieldArray() {
            thisTextBox.text = { settingsDelegate?.fetchTeamName(teamNumber: i) }()
            i += 1
        }
        
        for thisSwitch in switchesArray() {
            thisSwitch.isOn = { settingsDelegate?.fetchTeamIsActive(teamNumber: thisSwitch.tag) ?? false }()
        }
        
        
        
        
    }
    

    
    //MARK: - Create Arrays
    
    func textFieldArray() -> [UITextField] {
        return [team1TextBox, team2TextBox, team3TextBox, team4TextBox]
    }
    
    func switchesArray() -> [UISwitch] {
        return [switch1, switch2, switch3, switch4]
    }
    
    //MARK: - Switches
    
    @IBAction func switchFlipped(_ sender: UISwitch) {
        settingsDelegate?.updateTeamIsActive(teamNumber: sender.tag, isActive: sender.isOn)
    }
    
    //MARK: - Bottom Buttons
    
    @IBAction func updateButton(_ sender: UIButton) {
        for myTextBox in textFieldArray() {
            settingsDelegate?.updateTeamName(teamNumber: myTextBox.tag, name: myTextBox.text ?? "")
        }
        updateUIDelegate?.refreshScreen(reTransmit: true)
        dismiss(animated: true)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        if cancelButtonData != nil {
            settingsDelegate?.cancel(oldTeamList: cancelButtonData!)
        }
        dismiss(animated: true)
    }
}
    
    //MARK: - Text Boxes

extension TeamSetupViewController: UITextFieldDelegate {

    /*
    func textFieldDidBeginEditing(_ textField: UITextField) {
        for thisSwitch in switchesArray() {
            if thisSwitch.tag == textField.tag {
                thisSwitch.isOn = true
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = "Team \(textField.tag)"
        }
    }
    */
    
}
