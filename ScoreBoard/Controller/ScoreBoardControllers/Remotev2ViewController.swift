//
//  Remotev2ViewController.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/25/23.
//

import UIKit

class Remotev2ViewController: ScoreBoardViewController, ScoreBoardDelegate {
    
    //MARK: - Setup Variables
    var mode: String?
    var returnToPortraitOnExit: Bool = false
    
    //MARK: - IBOutlets
    /// UIView
    @IBOutlet var uiView: UIView!
    
    /// Header Labels
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var userFeedbackLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    /// Control Buttons
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var themeButton: UIButton!
    var controlButtonsArray: [UIButton] {[
        exitButton,
        resetButton,
        themeButton
    ]}
    
    /// Increment Buttons
    @IBOutlet weak var incrementButtonsStack: UIStackView!
    @IBOutlet weak var incrementStackWidth: NSLayoutConstraint!
    @IBOutlet weak var incrementButton1: UIButton!
    @IBOutlet weak var incrementButton2: UIButton!
    @IBOutlet weak var incrementButton3: UIButton!
    @IBOutlet weak var incrementButton4: UIButton!
    var incrementButtonsArray: [UIButton] {[
        incrementButton1,
        incrementButton2,
        incrementButton3,
        incrementButton4
    ]}
    
    //MARK: - Scoreboard Delegate Functions
    func refreshScreen(reTransmit: Bool) {
        displayUserFeedback(feedback: "✔️ \(userEmail ?? "no email")")
        tableView.reloadData()
        updateUIForButtonTint(buttons: incrementButtonsArray)
        updateUIForButtonTint(buttons: controlButtonsArray)
        updateUIForButtonSelection(buttons: incrementButtonsArray)
        if reTransmit {
            transmitData()
        }
    }
    
    func displayUserFeedback(feedback: String) {
        userFeedbackLabel.text = feedback
    }
    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Delegate
        declareScoreboardDelegate(scoreBoardDelegate: self, remoteDelegate: self, themeDelegate: self)
        
        /// Remote
        if userEmail != nil {
            setupRemoteTransmitter(userEmail: userEmail!)
        } else {
            let error: String = "You must be signed in to use remote features"
            print(error)
            userFeedbackLabel.text = error
        }
        remoteControlTransmitter.delegate = self
        
        /// Table
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RemoteTeamViewCell", bundle: nil), forCellReuseIdentifier: "teamCell")
    }
    
    //MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// Remote Mode UI Setup
        switch mode {
        case "Name Change Remote":
            incrementButtonsStack.isHidden = true
            resetButton.isHidden = true
            themeButton.isHidden = true
            headerLabel.text = "Customize Teams"
        default:
            print("Standard Remote Mode")
        }
        
        /// iPhone Customizations
        if UIDevice.current.localizedModel == "iPhone" {
            
            /// Changes the size of the Point Increment Buttons to fit an iPhone Screen
            let viewWidth = uiView.frame.size.width
            incrementStackWidth.constant = viewWidth - 40
            
        }
        
        /// Theme
        updateTheme(theme: RemoteControlTheme().theme, backgroundImage: nil, subtitleLabels: nil, scoreLabels: nil, buttons: nil, transmit: false)
        updateUIForButtonTint(buttons: incrementButtonsArray)

    }
    
    //MARK: - Buttons
    
    /// Point Increment Buttons
    var increment: Double = 1

    @IBAction func pointIncrementButtonPressed(_ sender: UIButton) {
        increment = Double(sender.tag)
        for button in incrementButtonsArray {
            button.isSelected = false
        }
        sender.isSelected = true
        refreshScreen(reTransmit: false)
    }
    
    /// Done Button
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        if returnToPortraitOnExit {
            AppDelegate.AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeLeft)
        }
        self.dismiss(animated: true)
    }
    
    /// Reset Button
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "remoteToResetSegue", sender: self)
    }
    
    /// Reset Function: Triggered by ResetViewController
    override func resetScores() {
        super.resetScores()
        refreshScreen(reTransmit: true)
    }
    
    /// Theme Button
    @IBAction func themeButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "remoteThemeSegue", sender: self)
    }

    
    //MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /// Reset Scores / Names View Controller
        if segue.identifier == "remoteToResetSegue" {
            let destinationVC = segue.destination as! ResetViewController
            destinationVC.delegate = self
            
        /// Change Themes View Controller
        } else if segue.identifier == "remoteThemeSegue" {
            let destinationNavigationController = segue.destination as! UINavigationController
            let destinationVC = destinationNavigationController.topViewController as! ThemeGroupChooserViewController
            destinationVC.delegate = self
        }
    }
}




//MARK: - Table Data Source
extension Remotev2ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsCount: Int = teamManager.teamList.count
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /// Create Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as! RemoteTeamViewCell
        
        /// Customize Cell UI for Mode
        switch self.mode {
        case "Name Change Remote":
            cell.setUIForNameChangeRemote()
        default:
            cell.setUIForStandardRemote()
        }
        
        /// Pass Data into Cell Variables
        cell.indexRow = indexPath.row
        cell.delegate = self
        
        /// Set Cell Name Label
        cell.teamNameTextField.text = fetchTeamNames()[indexPath.row]
        
        /// Set Cell Score
        cell.scoreLabel.text = String(fetchScores()[indexPath.row])
        
        /// Set Cell IsActive Switch
        cell.isActiveSwitch.isOn = fetchIsActive()[indexPath.row]
        
        /// Setup Cell Score Stepper
        cell.scoreStepper.value = Double(fetchScores()[indexPath.row])
        cell.scoreStepper.stepValue = Double(increment)
        
        /// Return Cell
        return cell
    }
}

//MARK: - Team Cell Delegate
extension Remotev2ViewController: TeamCellDelegate {
    func updateName(newName: String, teamIndex: Int) {
        setTeamName(newName: newName, teamIndex: teamIndex)
        refreshScreen(reTransmit: true)
    }
    
    func updateScore(newScore: Int, teamIndex: Int) {
        replaceScore(teamNumber: teamIndex + 1, newScore: newScore)
        refreshScreen(reTransmit: true)
    }
    
    func updateIsActive(isActive: Bool, teamIndex: Int) {
        print("updating isActive status for team \(teamIndex + 1), \(isActive)")
        setIsActive(isActive: isActive, teamIndex: teamIndex)
        refreshScreen(reTransmit: false)
    }
    
    
}

//MARK: - Reset Delegate
extension Remotev2ViewController: ResetDelegate {
    func resetTeamNames() {
        teamManager.resetTeamNames()
        refreshScreen(reTransmit: true)
    }
}

//MARK: - Theme Display Delegate
extension Remotev2ViewController: ThemeDisplayDelegate {
    func implementTheme(theme: Theme) {
        
        /// Transmit Theme to Cloud
        if userEmail != nil {
            remoteControlTransmitter.transmitTheme(sender: userEmail!, themeName: theme.name)
        }
        
    }
}
