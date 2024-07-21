//
//  MainDisplayViewController.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 12/2/22.
//

import UIKit

class MainDisplayViewController: ScoreBoardViewController {
    
    //MARK: - Properties
    var shouldNeverDisplayUI = false
    
    //MARK: - IBOutlets
    
    /// Stacks
    @IBOutlet weak var teamScoresStackView: TeamScoresStackView!
    
    /// Point Increment Buttons
    @IBOutlet weak var onePointButton: ScoreboardUIButton!
    @IBOutlet weak var fivePointButton: ScoreboardUIButton!
    @IBOutlet weak var tenPointButton: ScoreboardUIButton!
    @IBOutlet weak var hundredPointButton: ScoreboardUIButton!
    var pointIncrementButtonsArray: [ScoreboardUIButton] {
        return [onePointButton,
                fivePointButton,
                tenPointButton,
                hundredPointButton
        ]
    }
    
    /// Control Buttons
    @IBOutlet weak var resetButton: ScoreboardUIButton!
    @IBOutlet weak var teamSetupButton: ScoreboardUIButton!
    @IBOutlet weak var toggleUIButton: ScoreboardUIButton!
    @IBOutlet weak var troubleShootingButton: ScoreboardUIButton!
    @IBOutlet weak var themesButton: ScoreboardUIButton!
    @IBOutlet weak var doneButton: ScoreboardUIButton!
    
    /// All Buttons Array
    var allButtonsArray: [ScoreboardUIButton] {
        return [resetButton,
                teamSetupButton,
                troubleShootingButton,
                onePointButton,
                fivePointButton,
                tenPointButton,
                hundredPointButton,
                toggleUIButton,
                themesButton,
                doneButton
        ]
    }
    
    // Buttons With Permanent Visibility
    var buttonsToKeepVisible: [ScoreboardUIButton] {[
        doneButton,
        toggleUIButton
    ]}
        
    // User Feedback
    @IBOutlet weak var userFeedbackLabel: UILabel!
    
    // Background
    @IBOutlet weak var backgroundView: UIImageView!
    
    //MARK: - ViewLoading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad: \(#fileID)")
        
        userFeedbackLabel.text = ""
        
        /// Orientation Lock
        Utilities().updateOrientation(to: .landscape)
        
        /// Setup Buttons
        for button in buttonsToKeepVisible {
            button.selfCanHide = false
        }
        
        /// Refresh Screen after Setup
        selectCorrectIncrementButton()
        userFeedbackLabel.text = ""
        refreshUIForTheme()

    }
    
    //MARK: - ViewAppearing
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear - \(#fileID)")
        lockOrientation(to: .landscapeLeft)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        teamScoresStackView.set(delegate: self)
        refreshUIForTeams()
    }
    
    //MARK: - TeamViews
    
//    func createTeamViews() {
//        teamScoresStackView.set(activeTeamList: teamManager.fetchActiveTeams(), theme: themeManager.fetchActiveTheme(), state: themeManager.fetchScoreboardState())
//    }
    
    //MARK: - Update UI
    
    override func refreshUIForTheme() {
        super.refreshUIForTheme()
        
        if constants.printThemeFlow {
            print("implementingActiveTheme, File: \(#fileID)")
        }
        
        /// Properties
        let activeTheme = themeManager.fetchActiveTheme()
        let state = themeManager.fetchScoreboardState()
        
        /// Implementation
        activeTheme.format(background: backgroundView)
        refreshButtons()
        teamScoresStackView.set(theme: activeTheme, state: state)

    }
    
    override func refreshUIForTeams() {
        super.refreshUIForTeams()
        
        teamScoresStackView.refreshTeamViews(teamList: teamManager.fetchTeamList(), theme: themeManager.fetchActiveTheme(), state: themeManager.fetchScoreboardState())
    }
    
    @IBAction func toggleUIPressed(_ sender: UIButton) {
        themeManager.toggleUIIsHidden()
        refreshButtons()
        refreshUIForTeams()
    }
    
    func refreshButtons() {
        let state = themeManager.fetchScoreboardState()
        let theme = themeManager.fetchActiveTheme()
        
        for button in allButtonsArray {
            button.setupButton(state: state, theme: theme)
        }
    }
    
    func selectCorrectIncrementButton() {
        let state = themeManager.fetchScoreboardState()
        for button in pointIncrementButtonsArray {
            if Double(button.titleLabel?.text ?? "") == state.pointIncrement {
                button.isSelected = true
            } else {
                button.isSelected = false
            }
        }
    }
    
    /// User Feedback
    func displayUserFeedback(feedback: String) {
        userFeedbackLabel.text = feedback
    }
    
    /// Trouble Shooting Button - assign custom functionality as needed
    @IBAction func troubleShootingButtonPressed(_ sender: UIButton) {
        refreshUIForTeams()
        refreshUIForTheme()
    }
    
    
    //MARK: - Point Increment Buttons
    
    @IBAction func pointIncrementButton(_ sender: UIButton) {
        
        let currentPointValue = Double(sender.titleLabel!.text!)!

        for i in pointIncrementButtonsArray { /// set all point increment buttons to inactive
            i.isSelected = false
        }
        sender.isSelected = true /// set the sender point increment button to active
        
        themeManager.savePointIncrement(currentPointValue)
        refreshUIForTeams()
        refreshButtons()
        
    }
    
    
    //MARK: -  Segue Buttons
    
    /// Reset Button
    @IBAction func resetButton(_ sender: UIButton) {
        performSegue(withIdentifier: "mainScoreboardToReset", sender: self)
    }
    
    /// Settings Button
    @IBAction func settingsButton(_ sender: UIButton) {
        let deviceType = Utilities.DeviceInfo().deviceType

        if deviceType == .iPhone {
            self.performSegue(withIdentifier: "mainDisplayToRemoteModal", sender: self)
        } else {
            self.performSegue(withIdentifier: "mainDisplayToRemote", sender: self)
        }
    }
    
    /// Themes Button
    @IBAction func themesButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "navigationThemeSegue", sender: self)
    }
    
    /// Done Button
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        /// Orientation Locks
        let deviceType = Utilities.DeviceInfo().deviceType

        if deviceType == .iPhone {
            Utilities().updateOrientation(to: constants.screenOrientationStandardiPhone)
        } else if deviceType == .iPad {
            Utilities().updateOrientation(to: constants.screenOrientationStandardiPad)
        }
        
        /// Dismiss
        self.dismiss(animated: true)
    }
    
    
    //MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /// Update Name Segue
        if segue.identifier == "mainDisplayToRemote" || segue.identifier == "mainDisplayToRemoteModal" {
            let deviceType = Utilities.DeviceInfo().deviceType
            if deviceType == .iPhone {
                Utilities().updateOrientation(to: constants.screenOrientationStandardiPhone)
            }
            let destinationVC = segue.destination as! Remotev2ViewController
            destinationVC.teamManager = self.teamManager
            destinationVC.remoteViewMode = .nameChange
            destinationVC.returnToPortraitOnExit = true
        
        /// Theme Chooser
        } else if segue.identifier == "navigationThemeSegue" {
            let destinationNavigationController = segue.destination as! UINavigationController
            let destinationVC = destinationNavigationController.topViewController as! ThemeGroupChooserViewController
            destinationVC.delegate = mvcArrangement.themeManager
            
        /// Reset Confirmation
        } else if segue.identifier == "mainScoreboardToReset" {
            let destinationVC = segue.destination as! ResetViewController
            destinationVC.teamManager = teamManager
        }
    }
    
}

//MARK: - MVCDelegate

extension ScoreBoardViewController: MVCDelegate {
    func initializeMVCs(_ mvcArrangement: MVCArrangement) {
        themeManager = mvcArrangement.themeManager
        teamManager = mvcArrangement.teamManager
    }
}

//MARK: - TeamCellDelegate
extension MainDisplayViewController: TeamCellDelegate {
    
    func updateScore(newScore: Int, teamIndex: Int) {
        teamManager.replaceScore(teamNumber: teamIndex, newScore: newScore)
        refreshUIForTeams()
    }
    
    func updateIsActive(isActive: Bool, teamIndex: Int) {
        teamManager.updateTeamIsActive(teamNumber: teamIndex + 1, isActive: isActive)
        refreshUIForTeams()
    }
    
    func updateName(newName: String, teamIndex: Int) {
        teamManager.updateTeamName(teamNumber: teamIndex + 1, name: newName)
        refreshUIForTeams()
    }
    
}
