//
//  MainDisplayViewController.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 12/2/22.
//

import UIKit

class MainDisplayViewController: ScoreBoardViewController, UpdateUIDelegate, ScoreBoardDelegate {

    
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
    var controlButtonsArray: [scoreboardUIButton] {
        return [resetButton,
                teamSetupButton,
                troubleShootingButton,
                themesButton,
                doneButton
        ]
    }
    
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

    
    /// Views To Hide In Display Mode
    var viewsToHideInDisplayMode: [scoreboardUIButton] {[
        onePointButton,
        fivePointButton,
        tenPointButton,
        hundredPointButton,
        resetButton,
        teamSetupButton,
        themesButton
    ]}
    
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
    
    
    //MARK: - Variables
        
    /// Arrangement
    var arrangementList: [Int : [Bool]] {
        if UIDevice.current.localizedModel == "iPad" {
            return MainScoreboardDisplayDatabase().iPadArrangement
        } else {
            return MainScoreboardDisplayDatabase().iPhoneArrangement
        }
    }
    
    /// Determine whether to hide the bottom row of scores
    var hideBottomRow: Bool {
        var i = 5
        var hideTheView: Bool = true
        while i < 9 {
            if arrangementList[numberOfTeams]![i-1] {
                hideTheView = false
            }
            i += 1
        }
        return hideTheView
    }
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        /// ScoreboardDelegate
        declareScoreboardDelegate(scoreBoardDelegate: self, remoteDelegate: self, themeDelegate: self)
        
        /// User Email
        userFeedbackLabel.text = ""
        if let email = userEmail {
            setupRemoteTransmitter(userEmail: email)
        } else {
            print("not signed in")
        }

        /// Orientation Lock
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscape, andRotateTo: UIInterfaceOrientation.landscapeLeft)
        
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
        implementTheme(theme: scoreboardState.theme)
        refreshScreen(reTransmit: false)
        
    }
    
    //MARK: - TeamViews
    
    func createTeamViews() {
        var teamList = teamManager.fetchActiveTeams()
        teamList = teamList.reversed()
        let teamCount = teamList.count
        
        for team in teamList {
            /// Create New TeamView
            let teamView = createTeamView(team)
            teamViews.append(teamView)
            displayTeamView(teamView, teamCount: teamCount)
            NSLayoutConstraint.activate([            teamView.centerYAnchor.constraint(equalTo: teamView.superview!.centerYAnchor, constant: 0)])
        }
        
    }
    
    func createTeamView(_ teamInfo: Team) -> TeamView {
        let teamSetup = teamManager.teamList
        
        // Setup TeamView
        let teamView = TeamView()
        teamView.translatesAutoresizingMaskIntoConstraints = false
        teamView.set(teamInfo: teamInfo)
        teamView.set(scoreboardState: scoreboardState, teamSetup: teamSetup)
        teamView.set(delegate: self)
        
        return teamView
    }
    
    func displayTeamView(_ view: TeamView, teamCount: Int) {
        
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
    
    func teamViewsNeedReInitialized() -> Bool {
        
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
    
    func reInitializeTeamViews() {
        // Delete Current TeamViews
        teamViews = []
        for stackView in mainScoreBoardStack.arrangedSubviews {
            stackView.removeFromSuperview()
        }
        
        // Refill the ScoresRows
        createTeamViews()
    }
    
    func createScoreboardStackView() {
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
        
        // Reinitialize teamViews if needed
        if teamViewsNeedReInitialized() {
            reInitializeTeamViews()
        }
        
        // Pass Data into the team views
        let teamSetup = teamManager.teamList
        for view in teamViews {
            let teamNumber = view.teamInfo.number
            if let newTeamInfo: Team = teamManager.fetchTeamInfo(teamNumber: teamNumber) {
                view.set(teamInfo: newTeamInfo)
            }
            view.set(scoreboardState: scoreboardState, teamSetup: teamSetup)
        }
    }
        
    //MARK: - Update UI
    
    /// Refresh Screen
    func refreshScreen(reTransmit: Bool) {
        refreshButtons()
        refreshTeamViews()
        userFeedbackLabel.text = ""
        if reTransmit {
            transmitData()
        }
    }
    
    /// Toggle UI
    @IBAction func toggleUIPressed(_ sender: UIButton) {
        scoreboardState.uiIsHidden = !scoreboardState.uiIsHidden
        refreshButtons()
        refreshTeamViews()
    }
    
    func refreshButtons() {
        for button in allButtonsArray {
            button.setupButton(state: scoreboardState)
        }
    }
    
    /// User Feedback
    func displayUserFeedback(feedback: String) {
        userFeedbackLabel.text = feedback
    }
    
    /// Trouble Shooting Button - assign custom functionality as needed
    @IBAction func troubleShootingButtonPressed(_ sender: UIButton) {
        refreshScreen(reTransmit: false)
    }
    
    
    //MARK: - Point Increment Buttons
    
    @IBAction func pointIncrementButton(_ sender: UIButton) {
        
        let currentPointValue = Double(sender.titleLabel!.text!)!

        for i in pointIncrementButtonsArray { /// set all point increment buttons to inactive
            i.isSelected = false
        }
        sender.isSelected = true /// set the sender point increment button to active
        updateUIForButtonSelection(buttons: pointIncrementButtonsArray)
        
        scoreboardState.pointIncrement = currentPointValue
        refreshTeamViews()
        
    }
    
    
    //MARK: -  Segue Buttons
    
    /// Reset Button
    @IBAction func resetButton(_ sender: UIButton) {
        performSegue(withIdentifier: "mainScoreboardToReset", sender: self)
    }
    
    /// Reset Function: Triggered by ResetViewController
    override func resetScores() {
        super.resetScores()
        refreshScreen(reTransmit: true)
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
            AppDelegate.AppUtility.lockOrientation(constants.screenOrientationStandardiPhone, andRotateTo: constants.screenOrientationToRotateTo)
        } else if UIDevice.current.localizedModel == "iPad" {
            AppDelegate.AppUtility.lockOrientation(constants.screenOrientationStandardiPad)
        }
        
        /// Dismiss
        self.dismiss(animated: true)
    }
    
    
    //MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /// Update Name Segue
        if segue.identifier == "mainDisplayToRemote" || segue.identifier == "mainDisplayToRemoteModal" {
            if UIDevice.current.localizedModel == "iPhone" {
                print("iPhone")
                AppDelegate.AppUtility.lockOrientation(constants.screenOrientationStandardiPhone, andRotateTo: constants.screenOrientationToRotateTo)
            }
            let destinationVC = segue.destination as! Remotev2ViewController
            destinationVC.userEmail = self.userEmail
            destinationVC.teamManager = self.teamManager
            destinationVC.mode = "Name Change Remote"
            destinationVC.returnToPortraitOnExit = true
        
        /// Theme Chooser
        } else if segue.identifier == "navigationThemeSegue" {
            let destinationNavigationController = segue.destination as! UINavigationController
            let destinationVC = destinationNavigationController.topViewController as! ThemeGroupChooserViewController
            destinationVC.delegate = self
            
        /// Reset Confirmation
        } else if segue.identifier == "mainScoreboardToReset" {
            let destinationVC = segue.destination as! ResetViewController
            destinationVC.delegate = self
        }
    }
    
}

//MARK: - Theme Display Delegate
extension MainDisplayViewController: ThemeDisplayDelegate {
    func implementTheme(theme: Theme) {
        newUpdateTheme(theme: theme, backgroundView: backgroundView, shouldTransmit: true)
        backgroundView.image = theme.backgroundImage
        scoreboardState.theme = theme
        refreshTeamViews()
        refreshButtons()
    }
}

//MARK: - Reset Delegate
extension MainDisplayViewController: ResetDelegate {
    func resetTeamNames() {
        teamManager.resetTeamNames()
        refreshScreen(reTransmit: true)
    }
}

//MARK: - TeamCellDelegate
extension MainDisplayViewController: TeamCellDelegate {
    
    func updateScore(newScore: Int, teamIndex: Int) {
        replaceScore(teamNumber: teamIndex, newScore: newScore)
        refreshTeamViews()
        transmitData()
    }
    
    func updateIsActive(isActive: Bool, teamIndex: Int) {
        refreshTeamViews()
    }
    
    func updateName(newName: String, teamIndex: Int) {
        refreshTeamViews()
    }
    
}
