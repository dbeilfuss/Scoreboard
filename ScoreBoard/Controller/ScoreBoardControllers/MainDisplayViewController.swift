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
    @IBOutlet weak var mainScoreBoardStackHeight: NSLayoutConstraint!
    
    /// Score Labels
    @IBOutlet weak var team1ScoreLabel: UILabel!
    @IBOutlet weak var team2ScoreLabel: UILabel!
    @IBOutlet weak var team3ScoreLabel: UILabel!
    @IBOutlet weak var team4ScoreLabel: UILabel!
    @IBOutlet weak var team5ScoreLabel: UILabel!
    @IBOutlet weak var team6ScoreLabel: UILabel!
    @IBOutlet weak var team7ScoreLabel: UILabel!
    @IBOutlet weak var team8ScoreLabel: UILabel!
    var scoreLabelsArray: [UILabel] {
        return [team1ScoreLabel,
                team2ScoreLabel,
                team3ScoreLabel,
                team4ScoreLabel,
                team5ScoreLabel,
                team6ScoreLabel,
                team7ScoreLabel,
                team8ScoreLabel
        ]
    }
    
    /// Point Increment Buttons
    @IBOutlet weak var onePointButton: UIButton!
    @IBOutlet weak var fivePointButton: UIButton!
    @IBOutlet weak var tenPointButton: UIButton!
    @IBOutlet weak var hundredPointButton: UIButton!
    var pointIncrementButtonsArray: [UIButton] {
        return [onePointButton,
                fivePointButton,
                tenPointButton,
                hundredPointButton
        ]
    }
    
    /// Steppers
    @IBOutlet weak var team1Stepper: UIStepper!
    @IBOutlet weak var team2Stepper: UIStepper!
    @IBOutlet weak var team3Stepper: UIStepper!
    @IBOutlet weak var team4Stepper: UIStepper!
    @IBOutlet weak var team5Stepper: UIStepper!
    @IBOutlet weak var team6Stepper: UIStepper!
    @IBOutlet weak var team7Stepper: UIStepper!
    @IBOutlet weak var team8Stepper: UIStepper!
    var steppersArray: [UIStepper] {
        return [team1Stepper,
                team2Stepper,
                team3Stepper,
                team4Stepper,
                team5Stepper,
                team6Stepper,
                team7Stepper,
                team8Stepper
        ]
    }
    
    /// Name Labels
    @IBOutlet weak var team1NameLabel: UILabel!
    @IBOutlet weak var team2NameLabel: UILabel!
    @IBOutlet weak var team3NameLabel: UILabel!
    @IBOutlet weak var team4NameLabel: UILabel!
    @IBOutlet weak var team5NameLabel: UILabel!
    @IBOutlet weak var team6NameLabel: UILabel!
    @IBOutlet weak var team7NameLabel: UILabel!
    @IBOutlet weak var team8NameLabel: UILabel!
    var nameLabelsArray: [UILabel] {
        return [team1NameLabel,
                team2NameLabel,
                team3NameLabel,
                team4NameLabel,
                team5NameLabel,
                team6NameLabel,
                team7NameLabel,
                team8NameLabel
        ]
    }
    
    /// Control Buttons
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var teamSetupButton: UIButton!
    @IBOutlet weak var toggleUIButton: UIButton!
    @IBOutlet weak var troubleShootingButton: UIButton!
    @IBOutlet weak var themesButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    var controlButtonsArray: [UIButton] {
        return [resetButton,
                teamSetupButton,
                troubleShootingButton,
                themesButton,
                doneButton
        ]
    }
    
    /// All Buttons Array
    var allButtonsArray: [UIButton] {
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
    
    /// Team Views
    @IBOutlet weak var team1View: UIView!
    @IBOutlet weak var team2View: UIView!
    @IBOutlet weak var team3View: UIView!
    @IBOutlet weak var team4View: UIView!
    @IBOutlet weak var team5View: UIView!
    @IBOutlet weak var team6View: UIView!
    @IBOutlet weak var team7View: UIView!
    @IBOutlet weak var team8View: UIView!
    @IBOutlet weak var bottomRowView: UIStackView!
    var viewsArray: [UIView] {
        return [team1View,
                team2View,
                team3View,
                team4View,
                team5View,
                team6View,
                team7View,
                team8View
        ]
    }
    
    /// Views To Hide In Display Mode
    var viewsToHideInDisplayMode: [UIView] {[
        onePointButton,
        fivePointButton,
        tenPointButton,
        hundredPointButton,
        team1Stepper,
        team2Stepper,
        team3Stepper,
        team4Stepper,
        team5Stepper,
        team6Stepper,
        team7Stepper,
        team8Stepper,
        resetButton,
        teamSetupButton,
        themesButton
    ]}
    
    // User Feedback
    @IBOutlet weak var userFeedbackLabel: UILabel!
    
    // Background
    @IBOutlet weak var backgroundView: UIImageView!
    
    
    //MARK: - Variables
    
//    /// Install Settings Controller - can be deprecated?
//    var settingsViewController = TeamSetupViewController()
    
    /// Theme
    var newTheme: Theme = Railway().theme
    
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
    
    /// How Many of Teams were active before screen refresh
    /// For comparison on whether to perform a full screen refresh, or a partial screen refresh
    var activeTeams: Int = 0

    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Delegate
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
    }
    
    //MARK: - ViewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// Update Theme
        updateTheme(theme: theme, backgroundImage: backgroundView, subtitleLabels: nameLabelsArray, scoreLabels: scoreLabelsArray, buttons: allButtonsArray, transmit: false)
        
        /// Refresh Screen after Setup
        refreshScreen(reTransmit: false)
    }
    
    //MARK: - ViewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    //MARK: - Update UI
    
    /// Refresh Screen
    func refreshScreen(reTransmit: Bool) {
        print("refreshing screen")
        
        /// Determine whether to perform a full refresh, or a partial refresh, based on whether the Active Team Count has changed
        let oldTeamCount: Int = self.activeTeams
        var newTeamCount: Int {
            var activeTeams: Int = 0
            let isActiveList = teamManager.fetchIsActiveList()
            for team in isActiveList {
                if team {
                    activeTeams += 1
                }
            }
            return activeTeams
        }
        
        if newTeamCount != oldTeamCount { /// Full Refresh
            print("Full Refresh")
            /// Re-Tag Views Based on Team Count:
            reTagViews(viewsToRetag: viewsArray)
            reTagViews(viewsToRetag: steppersArray)
            reTagViews(viewsToRetag: scoreLabelsArray)
            reTagViews(viewsToRetag: nameLabelsArray)
            
            /// Update UI Elements
            if hideBottomRow {
                hideUI(viewsToHide: [bottomRowView], hidden: true)
            } else {
                hideUI(viewsToHide: [bottomRowView], hidden: false)
            }
            
            resizeFonts(labels: nameLabelsArray, themeFont: theme.subtitleFont!)
            resizeFonts(labels: scoreLabelsArray, themeFont: theme.scoreFont!)
        } else {
            print("Partial Refresh")
        }
        
        /// Update Steppers
        updateStepperValues(steppers: steppersArray)
        
        /// Update UI Elements
        updateUIForButtonSelection(buttons: pointIncrementButtonsArray)
        updateUI(scoreLabels: scoreLabelsArray)
        updateUIForButtonTint(buttons: controlButtonsArray)
        updateUI(teamNamesLabels: nameLabelsArray)
        updateUIForActiveTeams(views: viewsArray)
        hideUI(viewsToHide: viewsToHideInDisplayMode, hidden: remoteDisplay)
        
        /// User Feedback Label
        userFeedbackLabel.text = ""
        
        /// ReTransmit Data as Needed
        if reTransmit {
            transmitData()
        }
        
        /// Update ActiveTeam Count
        activeTeams = newTeamCount
    }
    
    /// Re-Tag Views Based on Team Count:
    func reTagViews(viewsToRetag: [UIView]) {
        
        /// Compile List of Only the Active Teams
        var activeTeamList: [Int] {
            var activeTeams: [Int] = []
            var x = 0
            for team in fetchIsActive() {
                if team {
                    activeTeams.append(x + 1)
                }
                x += 1
            }
            return activeTeams
        }
        
        /// Fetch Arrangement based on count of Active Teams
        self.numberOfTeams = activeTeamList.count
        let arrangement = self.arrangementList[numberOfTeams]
        
        /// Tag views according to fetched arrangement
        if activeTeamList.count != 0 {
            var nextArrangementInstruction = 0
            var i = 0
            for view in viewsToRetag {
                if arrangement![nextArrangementInstruction] != false {
                    view.tag = activeTeamList[i]
                    i += 1
                } else {
                    view.tag = 0
                }
                nextArrangementInstruction += 1
            }
        } else {
            for view in viewsToRetag {
                view.tag = 0
            }
        }
    }
    

    
    /// Toggle UI
    @IBAction func toggleUIPressed(_ sender: UIButton) {
        if remoteDisplay == true {
            remoteDisplay = false
        } else {
            remoteDisplay = true
        }
        hideUI(viewsToHide: viewsToHideInDisplayMode, hidden: remoteDisplay)
    }
    
    /// User Feedback
    func displayUserFeedback(feedback: String) {
        userFeedbackLabel.text = feedback
    }
    
    /// Trouble Shooting Button - assign custom functionality as needed
    @IBAction func troubleShootingButtonPressed(_ sender: UIButton) {
        refreshScreen(reTransmit: false)
    }
    
    
    //MARK: - Change Scores Buttons
    
    /// Steppers
    @IBAction func stepper(_ sender: UIStepper) { /// press a stepper, changes the score
        replaceScore(teamNumber: sender.tag, newScore: Int(sender.value))
        updateUI(scoreLabels: scoreLabelsArray)
        transmitData()
    }
    
    /// Point Increment Buttons
    @IBAction func pointIncrementButton(_ sender: UIButton) {
        let currentPointValue = Double(sender.titleLabel!.text!)!
        for i in steppersArray { /// Set all steppers to step the value selected on the point increment button
            i.stepValue = currentPointValue
        }
        for i in pointIncrementButtonsArray { /// set all point increment buttons to inactive
            i.isSelected = false
        }
        sender.isSelected = true /// set the sender point increment button to active
        updateUIForButtonSelection(buttons: pointIncrementButtonsArray)
    }
    
    
    //MARK: -  Segue Buttons
    
    /// Reset Button
    @IBAction func resetButton(_ sender: UIButton) {
        performSegue(withIdentifier: "mainScoreboardToReset", sender: self)
    }
    
    /// Reset Function: Triggered by ResetViewController
    override func resetScores() {
        super.resetScores()
        for i in steppersArray { /// reset stepper value to zero
            i.value = 0
        }
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
            AppDelegate.AppUtility.lockOrientation(k.screenOrientationStandardiPhone, andRotateTo: k.screenOrientationToRotateTo)
        } else if UIDevice.current.localizedModel == "iPad" {
            AppDelegate.AppUtility.lockOrientation(k.screenOrientationStandardiPad)
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
                AppDelegate.AppUtility.lockOrientation(k.screenOrientationStandardiPhone, andRotateTo: k.screenOrientationToRotateTo)
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
        print("implementing theme")
        updateTheme(theme: theme, backgroundImage: backgroundView, subtitleLabels: nameLabelsArray, scoreLabels: scoreLabelsArray, buttons: allButtonsArray, transmit: true)
    }
}

//MARK: - Reset Delegate
extension MainDisplayViewController: ResetDelegate {
    func resetTeamNames() {
        teamManager.resetTeamNames()
        refreshScreen(reTransmit: true)
    }
}
