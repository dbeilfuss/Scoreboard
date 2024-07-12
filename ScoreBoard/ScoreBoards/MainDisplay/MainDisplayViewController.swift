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
    @IBOutlet weak var mainScoreBoardStack: UIStackView!
    
    /// Point Increment Buttons
    @IBOutlet weak var onePointButton: scoreboardUIButton!
    @IBOutlet weak var fivePointButton: scoreboardUIButton!
    @IBOutlet weak var tenPointButton: scoreboardUIButton!
    @IBOutlet weak var hundredPointButton: scoreboardUIButton!
    var pointIncrementButtonsArray: [scoreboardUIButton] {
        return [onePointButton,
                fivePointButton,
                tenPointButton,
                hundredPointButton
        ]
    }
    
    /// Control Buttons
    @IBOutlet weak var resetButton: scoreboardUIButton!
    @IBOutlet weak var teamSetupButton: scoreboardUIButton!
    @IBOutlet weak var toggleUIButton: scoreboardUIButton!
    @IBOutlet weak var troubleShootingButton: scoreboardUIButton!
    @IBOutlet weak var themesButton: scoreboardUIButton!
    @IBOutlet weak var doneButton: scoreboardUIButton!
    
    /// All Buttons Array
    var allButtonsArray: [scoreboardUIButton] {
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
    var buttonsToKeepVisible: [scoreboardUIButton] {[
        doneButton,
        toggleUIButton
    ]}
    
    var teamViews: [TeamView] = []
    
    // User Feedback
    @IBOutlet weak var userFeedbackLabel: UILabel!
    
    // Background
    @IBOutlet weak var backgroundView: UIImageView!
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad: \(#fileID)")
        
        userFeedbackLabel.text = ""
        
        /// Orientation Lock
        Utilities().updateOrientation(to: .landscape)
        
        /// iPhone Specific Changes
        if UIDevice.current.localizedModel == "iPhone" {
            mainScoreBoardStack.spacing = 0
        }
        
        createTeamViews()
        
        /// Inform Buttons Which Must Remain Visible even when UI is switched off
        for button in buttonsToKeepVisible {
            button.selfCanHide = false
        }
        
        /// Refresh Screen after Setup
        implementActiveTheme()
        selectCorrectIncrementButton()
        userFeedbackLabel.text = ""

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear - \(#fileID)")
        lockOrientation(to: .landscapeLeft)
    }
    
    
    //MARK: - TeamViews
    
    private func createTeamViews() {
        var teamList = teamManager.fetchActiveTeams()
        teamList = teamList.reversed()
        let teamCount = teamList.count
                
        for team in teamList {
            /// Create New TeamView
            let teamView = createTeamView(team)
            teamViews.append(teamView)
            displayTeamView(teamView, teamCount: teamCount)
            NSLayoutConstraint.activate([teamView.centerYAnchor.constraint(equalTo: teamView.superview!.centerYAnchor, constant: 0)])
        }
        
    }
    
    private func createTeamView(_ teamInfo: Team) -> TeamView {
        let teamSetup = teamManager.fetchTeamList()
        
        // Setup TeamView
        let teamView = TeamView()
        teamView.translatesAutoresizingMaskIntoConstraints = false
        teamView.set(teamInfo: teamInfo)
        teamView.set(scoreboardState: themeManager.fetchScoreboardState(), teamSetup: teamSetup, theme: themeManager.fetchActiveTheme())
        teamView.set(delegate: self)
        
        return teamView
    }
    
    private func displayTeamView(_ view: TeamView, teamCount: Int) {
        
        // create top row if needed
        if mainScoreBoardStack.arrangedSubviews.count == 0 {
            createScoreboardStackView()
        }
        
        // choose bottom or top row
        var scoreRow: UIStackView = mainScoreBoardStack.arrangedSubviews.first! as! UIStackView
        
        var idealTeamsPerRow = 3
        if UIDevice.current.localizedModel == "iPhone" {
            idealTeamsPerRow = 4
        }
        
        if teamCount > idealTeamsPerRow {
            if teamViews.count < ((teamCount / 2) + 1) {
                
                // create bottom row if needed
                if mainScoreBoardStack.arrangedSubviews.count < 2 {
                    createScoreboardStackView()
                }
                
                // use bottom row
                scoreRow = mainScoreBoardStack.arrangedSubviews.last! as! UIStackView
            }
        }
        
        scoreRow.insertArrangedSubview(view, at: 0)
    }
    
    private func shouldReInitializeTeamViews() -> Bool {
        
        // Gather Information
        var teamViewTeamNumbers = teamViews.map() {$0.teamInfo.number}
        teamViewTeamNumbers = teamViewTeamNumbers.reversed()
        let teamManagerTeamNumbers = teamManager.fetchActiveTeamNumbers()
        
        // Return True or False
        if teamViewTeamNumbers == teamManagerTeamNumbers {
            return false
        } else {
            return true
        }
        
    }
    
    private func reInitializeTeamViews() {
        // Delete Current TeamViews
        teamViews = []
        for stackView in mainScoreBoardStack.arrangedSubviews {
            stackView.removeFromSuperview()
        }
        
        // Refill the ScoresRows
        createTeamViews()
    }
    
    private func createScoreboardStackView() {
        let scoreboardStackView = UIStackView()
        mainScoreBoardStack.addArrangedSubview(scoreboardStackView)
        
        // configure
        scoreboardStackView.alignment = .center
        scoreboardStackView.distribution = .fillEqually
        
        // constraints
        NSLayoutConstraint.activate([
            scoreboardStackView.leadingAnchor.constraint(equalTo: mainScoreBoardStack.leadingAnchor, constant: 0),
            scoreboardStackView.trailingAnchor.constraint(equalTo: mainScoreBoardStack.trailingAnchor, constant: 0)
        ])
    }
    
    func refreshTeamViews() {
        if constants.printTeamFlow {
            print("refreshing teamViews - \(#fileID)")
        }
        
        // Reinitialize teamViews if needed
        if shouldReInitializeTeamViews() {
            reInitializeTeamViews()
        }
        
        // Pass Data into the team views
        let teamSetup = teamManager.fetchTeamList()
        for view in teamViews {
            let teamNumber = view.teamInfo.number
            if let newTeamInfo: Team = teamManager.fetchTeamInfo(teamNumber: teamNumber) {
                view.set(teamInfo: newTeamInfo)
            }
            view.set(scoreboardState: themeManager.fetchScoreboardState(), teamSetup: teamSetup, theme: themeManager.fetchActiveTheme())
        }
    }
    
    //MARK: - Update UI
    
    override func refreshUIForTheme() {
        super.refreshUIForTheme()
        implementActiveTheme()
    }
    
    override func refreshUIForTeams() {
        super.refreshUIForTeams()
        refreshTeamViews()
    }
    
    func implementActiveTheme() {
        if constants.printThemeFlow {
            print("implementingActiveTheme, File: \(#fileID)")
        }
        updateBackground()
        refreshTeamViews()
        refreshButtons()
    }
    
    func updateBackground() {
        let activeTheme = themeManager.fetchActiveTheme()
        if constants.printThemeFlow {
            print("updating Background for theme: \(activeTheme.name), File: \(#fileID)")
        }
        activeTheme.format(background: backgroundView)
    }
    
    /// Toggle UI
    @IBAction func toggleUIPressed(_ sender: UIButton) {
        themeManager.toggleUIIsHidden()
        refreshButtons()
        refreshTeamViews()
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
        refreshTeamViews()
        refreshButtons()
        
    }
    
    
    //MARK: -  Segue Buttons
    
    /// Reset Button
    @IBAction func resetButton(_ sender: UIButton) {
        performSegue(withIdentifier: "mainScoreboardToReset", sender: self)
    }
    
    /// Settings Button
    @IBAction func settingsButton(_ sender: UIButton) {
        if UIDevice.current.localizedModel == "iPhone" {
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
        if UIDevice.current.localizedModel == "iPhone" {
            Utilities().updateOrientation(to: constants.screenOrientationStandardiPhone)
        } else if UIDevice.current.localizedModel == "iPad" {
            Utilities().updateOrientation(to: constants.screenOrientationStandardiPad)
        }
        
        /// Dismiss
        self.dismiss(animated: true)
    }
    
    
    //MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /// Update Name Segue
        if segue.identifier == "mainDisplayToRemote" || segue.identifier == "mainDisplayToRemoteModal" {
            if UIDevice.current.localizedModel == "iPhone" {
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
        refreshTeamViews()
    }
    
    func updateIsActive(isActive: Bool, teamIndex: Int) {
        teamManager.updateTeamIsActive(teamNumber: teamIndex + 1, isActive: isActive)
        refreshTeamViews()
    }
    
    func updateName(newName: String, teamIndex: Int) {
        teamManager.updateTeamName(teamNumber: teamIndex + 1, name: newName)
        refreshTeamViews()
    }
    
}
