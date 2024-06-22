//
//  ScoreBoardViewController.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 12/27/22.
//

import UIKit
import Firebase

//protocol ScoreBoardDelegate {
//    func refreshScreen(reTransmit: Bool)
//    func displayUserFeedback(feedback: String)
//}

class ScoreBoardViewController: UIViewController {
    
    //MARK: - Inititial Setup
    let constants = Constants()
    var teamManager: TeamManagerProtocol = TeamManager()
    var themeManager: ThemeManagerProtocol = ThemeManager()
    
    var signInState: SignInState = .notSignedIn
    
    lazy var mvcArrangement = MVCArrangement(
        databaseManager: DataStorageManager(),
        scoreboardViewController: self,
        teamManager: TeamManager(),
        themeManager: ThemeManager()
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
    
    func lockOrientation(to orientation: UIInterfaceOrientation) {
        print("Attempting to lock orientation to: \(orientation.rawValue) - \(#fileID)")
    }
    
    //MARK: - Teams
    
    func refreshUIForTeams() {
        // func refreshUIForTeams() conforms to the ScoreBoardViewControllerProtocol
        // it is located within the main body so it can be overwritten by subclasses
    }
    
    //MARK: - Themes
    
    func refreshUIForTheme() {
        // func refreshUIForTheme() conforms to the ScoreBoardViewControllerProtocol
        // it is located within the main body so it can be overwritten by subclasses
    }
    
}

extension ScoreBoardViewController: ScoreBoardViewControllerProtocol {
    func userFeedback(feedback: String) {
        print("userFeedback: \(feedback)")
    }
}
