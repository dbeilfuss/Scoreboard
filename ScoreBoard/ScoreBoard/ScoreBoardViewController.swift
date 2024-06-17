//
//  ScoreBoardViewController.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 12/27/22.
//

import UIKit
import Firebase

protocol ScoreBoardDelegate {
    func refreshScreen(reTransmit: Bool)
    func displayUserFeedback(feedback: String)
}

class ScoreBoardViewController: UIViewController {
    
    /*
     For full functionality, when creating a subclass of ScoreBaordViewController, call the following methods in viewDidLoad():
     • updateTheme()  // the default theme will be used otherwise
     • setupRemoteTransmitter() // to send and receive data
     • remoteControlTransmitter.delegate = self  // to display the data received from the transmitter
     • displayModeHiddenViews() // to declare which views to actually hide when "Hide UI" is toggled
     • declareScoreboardDelegate() // to receive data from the superclass, ScoreboardViewController
     
     Also, be sure to implement the ScoreBoardDelegate Protocol
     
     Have Fun!
     
     */
    
    //MARK: - Inititial Setup
    let constants = Constants()
    var teamManager: TeamManagerProtocol = TeamManager()
    var themeManager: ThemeManagerProtocol = ThemeManager()
    
    var signInState: SignInState = .notSignedIn
    
    lazy var mvcArrangement = MVCArrangement(
        scoreboardViewController: self,
        teamManager: TeamManager(),
        themeManager: ThemeManager(),
        databaseManager: DataStorageManager()
    )
    
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mvcManager = MVCManager(mvcArrangement: mvcArrangement)
        mvcManager.initializeMVCArrangement()
        
        // SignIn
        if let _: User = Auth.auth().currentUser {
            self.signInState = .signedIn
        } else {
            self.signInState = .notSignedIn
        }
        
    }
    
    //MARK: - Team Manager Interactions
    
    
    func refreshUIForTeams() {
        // func refreshUIForTeams() must exist to conform to TeamManagerDelegate
        // it is located within the main body so it can be overwritten by scoreboard subclasses
    }
    
    func addToScore(teamNumber: Int, add: Int) {
        teamManager.addToScore(teamNumber: teamNumber, scoreToAdd: add)
    }
    
    func replaceScore(teamNumber: Int, newScore: Int) {
        teamManager.replaceScore(teamNumber: teamNumber, newScore: newScore)
    }
    
    func fetchScores() -> [Int] {
        return teamManager.fetchScores()
    }
    
    func resetScores() {
        teamManager.resetScores(resetScoreValue: 0)
    }
    
    func resetTeams() {
        teamManager.resetTeams()
    }
    
    func setIsActive(isActive: Bool, teamIndex: Int) {
        teamManager.updateTeamIsActive(teamNumber: teamIndex + 1, isActive: isActive)
    }
    
    func setTeamName(newName: String, teamIndex: Int) {
        teamManager.updateTeamName(teamNumber: teamIndex + 1, name: newName)
    }
    
    //MARK: - Themes
    
    func refreshUIForTheme() {
        // func refreshUIForTheme() must exist to conform to ThemesDatabaseDelegate
        // it is located within the main body so it can be overwritten by scoreboard subclasses
    }
//    
//    func updateTheme(theme: Theme, backgroundView: UIImageView, shouldTransmit: Bool) {
//        
//        if theme.darkMode {
//            self.overrideUserInterfaceStyle = .dark
//        } else {
//            self.overrideUserInterfaceStyle = .light
//        }
//        
//        if shouldTransmit {
//            if signInState == .signedIn {
////                remoteControlTransmitter.transmitTheme(themeName: theme.name)
//            }
//        }
//        
//    }
//    
//    func updateTheme(theme: Theme, backgroundImage: UIImageView?, subtitleLabels: [UILabel]?, scoreLabels: [UILabel]?, buttons: [UIButton]?, shouldTransmit: Bool) {
//
//        if backgroundImage != nil {
//            backgroundImage!.image = theme.backgroundImage
//        }
//        
//        if subtitleLabels != nil {
//            for label in subtitleLabels! {
//                label.font = UIFont(name:theme.subtitleFont!.fontName, size: label.font.pointSize)
//                label.textColor = theme.subtitleColor
//                label.shadowColor = theme.shadowColor
//                //                label.shadowOffset = CGSize(width: theme.shadowWidth!, height: theme.shadowHeight!)
//            }
//        }
//        
//        if scoreLabels != nil {
//            for label in scoreLabels! {
//                label.font = UIFont(name:theme.scoreFont!.fontName, size: label.font.pointSize)
//                label.textColor = theme.scoreColor
//                label.shadowColor = theme.shadowColor
//                //                label.shadowOffset = CGSize(width: theme.shadowWidth!, height: theme.shadowHeight!)
//            }
//        }
//        
//        if buttons != nil {
//            updateUIForButtonSelection(buttons: buttons!)
//        }
//        
//        if theme.darkMode {
//            self.overrideUserInterfaceStyle = .dark
//        } else {
//            self.overrideUserInterfaceStyle = .light
//            
//        }
//        
//        if shouldTransmit {
////            remoteControlTransmitter.transmitTheme(themeName: theme.name)
//        }
//    }
    
    //MARK: - Update UI Buttons
    func updateUIForButtonSelection(buttons: [UIButton]) {
        let theme = themeManager.fetchActiveTheme()
        for i in buttons {
            if i.isSelected == true {
                i.tintColor = theme.buttonSelectedColor1!
            } else {
                i.tintColor = theme.buttonColor!
            }
        }
    }
    
    func updateUIForButtonTint(buttons: [UIButton]) {
        let theme: Theme = themeManager.fetchActiveTheme()
        for i in buttons {
            i.tintColor = theme.buttonColor
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

extension ScoreBoardViewController: ScoreBoardViewControllerProtocol {
    func userFeedback(feedback: String) {
        print("userFeedback: \(feedback)")
    }
    
    // func refreshUIForTeams() is located above so it can be overwritten by scoreboard subclasses
    // func refreshUIForTheme() is located above so it can be overwritten by scoreboard subclasses
}
