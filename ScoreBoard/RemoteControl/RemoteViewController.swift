////
////  RemoteViewController.swift
////  ScoreBoard
////
////  Created by Daniel Beilfuss on 12/20/22.
////
//
//import UIKit
//
//class RemoteViewController: ScoreBoardViewController, UpdateUIDelegate, ScoreBoardDelegate {
//
//    
//            
//    
//    //MARK: - IBOutlets
//    /// Header Labels
//    @IBOutlet weak var feedbackLabel: UILabel!
//    
//    /// UI Tweak Bumper Views
//    @IBOutlet weak var leftBumperView: UIView!
//    @IBOutlet weak var rightBumperView: UIView!
//    
//    /// Team Buttons
//    @IBOutlet weak var team1Button: UIButton!
//    @IBOutlet weak var team2Button: UIButton!
//    @IBOutlet weak var team3Button: UIButton!
//    @IBOutlet weak var team4Button: UIButton!
//    
//    /// + / - Buttons
//    @IBOutlet weak var plusButton: UIButton!
//    @IBOutlet weak var minusButton: UIButton!
//    
//    /// Points Buttons
//    @IBOutlet weak var pointsButton1: UIButton!
//    @IBOutlet weak var pointsButton2: UIButton!
//    @IBOutlet weak var pointsButton3: UIButton!
//    @IBOutlet weak var pointsButton4: UIButton!
//    @IBOutlet weak var pointsButton5: UIButton!
//    @IBOutlet weak var pointsButton6: UIButton!
//    @IBOutlet weak var pointsButton7: UIButton!
//    @IBOutlet weak var pointsButton8: UIButton!
//    
//    // Views - Behind the buttons
//    @IBOutlet weak var teamView: UIView!
//    @IBOutlet weak var positiveNegativeView: UIView!
//    @IBOutlet weak var incrementView: UIView!
//    
//    // Team Name Labels
//    @IBOutlet weak var team1NameLabel: UILabel!
//    @IBOutlet weak var team2NameLabel: UILabel!
//    @IBOutlet weak var team3NameLabel: UILabel!
//    @IBOutlet weak var team4NameLabel: UILabel!
//    
//    
//    //MARK: - UICollections
//    var views: [UIView] {[
//        teamView,
//        positiveNegativeView,
//        incrementView
//    ]}
//    
//    var teamButtons: [UIButton] {[
//        team1Button,
//        team2Button,
//        team3Button,
//        team4Button
//    ]}
//    
//    var teamNameLabels: [UILabel] {[
//        team1NameLabel,
//        team2NameLabel,
//        team3NameLabel,
//        team4NameLabel
//    ]}
//    
//    var plusMinusButtons: [UIButton] {[
//        plusButton,
//        minusButton
//    ]}
//    
//    var pointsButtons: [UIButton] {[
//        pointsButton1,
//        pointsButton2,
//        pointsButton3,
//        pointsButton4,
//        pointsButton5,
//        pointsButton6,
//        pointsButton7,
//        pointsButton8
//    ]}
//    
//    var allButtons: [UIButton] {
//        let arrays: [[UIButton]] = [
//            teamButtons,
//            plusMinusButtons,
//            pointsButtons
//        ]
//        
//        var buttonsArray: [UIButton] = []
//        
//        for array in arrays {
//            for button in array {
//                buttonsArray.append(button)
//            }
//        }
//        
//        return buttonsArray
//    }
//    
//    //MARK: - Color Preferences
//    override func updateUIForButtonSelection(buttons: [UIButton]) {
//        for i in buttons {
//            if i.isSelected == true {
//                i.tintColor = selectedColor
//            } else {
//                i.tintColor = theme.buttonColor
//            }
//        }
//    }
//        
//    var selectedColor: UIColor {
//        if positiveMode {
//            return theme.buttonSelectedColor1 ?? defaultTheme.buttonSelectedColor1!
//        } else {
//            return theme.buttonSelectedColor2 ?? defaultTheme.buttonSelectedColor1!
//        }
//    }
//    
//    //MARK: - Variables
//    var teamNumber = 1
//    var positiveMode = true
//    var settingsViewController = TeamSetupViewController()
//
//    
//    //MARK: - Screen Orientation & UI Modifications
//    ///  Works by invoking a method added to AppDelegate
//    override func viewWillAppear(_ animated: Bool) {
//        
//        /// Round the edges of the Behind-Button Views
//        for view in views {
//            view.layer.cornerRadius = 10
//        }
//        
//        if UIDevice.current.localizedModel == "iPhone" {
//            
//            ///  Locks Screen Orientation to Portrait for iPhones.
//            AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
//            
//            ///  Removes buffer views for iPhones
//            leftBumperView.isHidden = true
//            rightBumperView.isHidden = true
//            
//        } else if UIDevice.current.localizedModel == "iPad" { ///  Unlocks Screen Orientation for iPads.
//            AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
//        }
//        
//        /// Switch to Dark Mode
//        view.overrideUserInterfaceStyle = .dark
//        
//    }
//    
//    ///  Locks screen orientation to landscape for all devices upon exit.
//    override func viewWillDisappear(_ animated: Bool) {
//        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscape)
//    }
//    
//    //MARK: - View Did Load
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        declareScoreboardDelegate(scoreBoardDelegate: self, remoteDelegate: self, themeDelegate: self)
//        updateTheme(theme: RemoteControlTheme().theme, backgroundImage: nil, subtitleLabels: nil, scoreLabels: nil, buttons: allButtons, transmit: false)
//        
//        if let email = userEmail {
//            feedbackLabel.text = "✔️ \(email)"
//            setupRemoteTransmitter(userEmail: email)
//        } else {
//            print("not signed in")
//        }
//        
//        refreshScreen(reTransmit: false)
//                
//    }
//
//    //MARK: - Update UI
//    func refreshScreen(reTransmit: Bool) {
////        print("refreshing screen")
//        updateUIForButtonSelection(buttons: allButtons)
//        updateUI(scoreButtonText: teamButtons)
//        updateUI(teamNamesLabels: teamNameLabels)
//        
//        if reTransmit {
//            transmitData()
//        }
//        
//    }
//    
//    func displayUserFeedback(feedback: String) {
//        feedbackLabel.text = feedback
//    }
//    
//    //MARK: - Remote Control Buttons Pressed
//    
//    @IBAction func teamButtonPressed(_ sender: UIButton) {
//        
//        for button in teamButtons {
//            button.isSelected = false
//        }
//        
//        sender.isSelected = true
//        teamNumber = sender.tag
//        updateUIForButtonSelection(buttons: teamButtons)
//    }
//    
//    @IBAction func plusMinusButtonsPressed(_ sender: UIButton) {
//        
//        for button in plusMinusButtons {
//            button.isSelected = false
//        }
//        
//        sender.isSelected = true
//        
//        if sender.tag == 1 {
//            positiveMode = false
//        } else {
//            positiveMode = true
//        }
//        
//        updateUIForButtonSelection(buttons: allButtons)
//    }
//    
//    @IBAction func pointsButtonsPressed(_ sender: UIButton) { /// when the button is pressed down
//        sender.tintColor = selectedColor
//    }
//    
//    @IBAction func pointsButtonsNotPressed(_ sender: UIButton) { /// when dragging off the button
//        sender.tintColor = theme.buttonColor
//    }
//    
//    @IBAction func pointsButtonsPressedUp(_ sender: UIButton) { /// touchUpInside: Actually Selected
//        sender.tintColor = theme.buttonColor
//        
//        var scorePressed: Int {
//            if positiveMode {
//                return sender.tag
//            } else {
//                return sender.tag * (-1)
//            }
//        }
//        
//        addToScore(teamNumber: teamNumber, add: scorePressed)
//        
//    }
//        
//    @IBAction func clearButtonpressed(_ sender: UIButton) {
//        resetScores()
//        refreshScreen(reTransmit: true)
//        }
//    
//    //MARK: - Segues
//
//    @IBAction func exitButtonPressed(_ sender: Any) {
//        dismiss(animated: true)
//    }
//    
//    @IBAction func teamSetupButtonPressed(_ sender: UIButton) {
//        self.performSegue(withIdentifier: "remoteToTeamSetup", sender: self)
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "remoteToTeamSetup" {
//            let destinationVC = segue.destination as! TeamSetupViewController
//            destinationVC.updateUIDelegate = self
//            destinationVC.settingsDelegate = teamManager
//        }
//    }
//    
//}
//
//
//extension RemoteViewController: ThemeDisplayDelegate {
//    func implementTheme(theme: Theme) {
//
//    }
//}
