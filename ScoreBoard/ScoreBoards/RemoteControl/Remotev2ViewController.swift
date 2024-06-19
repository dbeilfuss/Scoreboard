//
//  Remotev2ViewController.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/25/23.
//

import UIKit
import FirebaseAuth

enum RemoteViewMode {
    case remoteControl
    case nameChange
}

class Remotev2ViewController: ScoreBoardViewController {
    
    //MARK: - Setup Variables
    var remoteViewMode: RemoteViewMode = .remoteControl
    var returnToPortraitOnExit: Bool = false
//    var teamCellDelegate: TeamCellDelegate?
    
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
    
    func displayUserFeedback(feedback: String) {
        userFeedbackLabel.text = feedback
    }
    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("signInState: \(signInState)")
        
        /// Remote
        if signInState == .signedIn {
        } else {
            let error: String = "You must be signed in to use remote features"
            print(error)
            userFeedbackLabel.text = error
        }
        
        /// Table
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RemoteTeamViewCell", bundle: nil), forCellReuseIdentifier: "teamCell")
    }
    
    //MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// Remote Mode UI Setup
        switch remoteViewMode {
        case .nameChange:
            incrementButtonsStack.isHidden = true
            resetButton.isHidden = true
            themeButton.isHidden = true
            headerLabel.text = "Customize Teams"
        case .remoteControl:
            print("Remote Mode")
        }
        
        /// iPhone Customizations
        if UIDevice.current.localizedModel == "iPhone" {
            
            /// Changes the size of the Point Increment Buttons to fit an iPhone Screen
            let viewWidth = uiView.frame.size.width
            incrementStackWidth.constant = viewWidth - 40
            
        }
        
        /// Theme
//        updateTheme(theme: RemoteControlTheme().theme, backgroundImage: nil, subtitleLabels: nil, scoreLabels: nil, buttons: nil, shouldTransmit: false)
//        updateUIForButtonTint(buttons: incrementButtonsArray)
        refreshScreen()

    }
    
    //MARK: - Refresh
    func refreshScreen() {

        if let userEmail = Auth.auth().currentUser?.email {
            displayUserFeedback(feedback: "✔️ \(userEmail)")
            refreshUIForTeams()
            refreshUIForTheme()
        }
    }
    
    override func refreshUIForTeams() {
        tableView.reloadData()
    }
    
    override func refreshUIForTheme() {
        let theme = fetchTheme()

        // Force DarkMode
        if theme.darkMode {
            self.overrideUserInterfaceStyle = .dark
        } else {
            self.overrideUserInterfaceStyle = .light
        }
        
        // Format Buttons
        let allButtons: [UIButton] = controlButtonsArray + incrementButtonsArray
        for button in allButtons {
            theme.format(button: button)
        }
        
    }
    
    func fetchTheme() -> Theme {
        return themeManager.fetchSpecializedTheme(ofType: .remote)
    }
    
    func refreshIncrementButtons() {
        let theme = fetchTheme()

        for button in incrementButtonsArray {
            theme.format(button: button)
        }
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
        
        refreshIncrementButtons()
        tableView.reloadData() //To update the scoreSteppers
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
    func resetScores() { // Can Deprecate?
        teamManager.resetScores()
        refreshScreen()
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
            destinationVC.teamManager = teamManager
            
        /// Change Themes View Controller
        } else if segue.identifier == "remoteThemeSegue" {
            let destinationNavigationController = segue.destination as! UINavigationController
            let destinationVC = destinationNavigationController.topViewController as! ThemeGroupChooserViewController
            destinationVC.delegate = mvcArrangement.themeManager
        }
    }
}

//MARK: - Table Data Source
extension Remotev2ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsCount: Int = teamManager.fetchTeamList().count
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /// Create Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as! RemoteTeamViewCell
        
        /// Setup Cell
        cell.set(index: indexPath.row, signInState: signInState, remoteViewMode: remoteViewMode, teamManager: teamManager)
        
        cell.set(teamSetup: teamManager.fetchTeamList(), pointIncrement: increment)
        
        /// Return Cell
        return cell
    }
}

//MARK: - Team Cell Delegate
extension Remotev2ViewController: TeamCellDelegate {
    func updateName(newName: String, teamIndex: Int) {
        teamManager.updateTeamName(teamNumber: teamIndex + 1, name: newName)
        refreshUIForTeams()
    }
    
    func updateScore(newScore: Int, teamIndex: Int) {
        teamManager.replaceScore(teamNumber: teamIndex + 1, newScore: newScore)
        refreshUIForTeams()
    }
    
    func updateIsActive(isActive: Bool, teamIndex: Int) {
        print("updating isActive status for team \(teamIndex + 1), \(isActive)")
        teamManager.updateTeamIsActive(teamNumber: teamIndex + 1, isActive: isActive)
        refreshUIForTeams()
    }
    
    
}

//MARK: - Reset Delegate
//extension Remotev2ViewController: ResetDelegate {
//    func resetTeamNames() {
//        teamManager.resetTeamNames()
//        refreshScreen(reTransmit: true)
//    }
//}

//
////MARK: - Theme Display Delegate
//extension Remotev2ViewController: ThemeSelectionDelegate {
//    func implementTheme(theme: Theme) {
//        
//        /// Transmit Theme to Cloud
//        if signInState == .signedIn {
//            remoteControlTransmitter.transmitTheme(themeName: theme.name)
//        }
//        
//    }
//}
