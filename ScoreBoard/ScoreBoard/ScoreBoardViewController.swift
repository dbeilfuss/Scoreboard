//
//  ScoreBoardViewController.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 12/27/22.
//

import Foundation
import UIKit

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
    
    var remoteControlTransmitter = RemoteControlTransmitter()
    //    var remoteControlTransmitterDelegate: RemoteControlTransmitterDelegate?
    
    var userEmail: String?
    var remoteDisplay = false
    var numberOfTeams: Int = 0
    
    // New Scoreboard State
    var scoreboardState = Constants().defaultScoreboardState

    
    //MARK: - Declare Delegates
    
    var scoreBoardDelegate: ScoreBoardDelegate?
    var remoteDelegate: RemoteControlTransmitterDelegate?
    var themeDelegate: ThemeDisplayDelegate?
    
    func declareScoreboardDelegate(scoreBoardDelegate: ScoreBoardDelegate, remoteDelegate: RemoteControlTransmitterDelegate, themeDelegate: ThemeDisplayDelegate) {
        self.scoreBoardDelegate = scoreBoardDelegate
        self.remoteDelegate = remoteDelegate
        self.themeDelegate = themeDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Team Manager Interactions
    
    var teamManager = TeamManager()
    
    func addToScore(teamNumber: Int, add: Int) {
        teamManager.addToScore(teamNumber: teamNumber, scoreToAdd: add)
        transmitData()
    }
    
    func replaceScore(teamNumber: Int, newScore: Int) {
        teamManager.replaceScore(teamNumber: teamNumber, newScore: newScore)
    }
    
    func fetchScores() -> [Int] {
        return teamManager.fetchScores()
    }
    
    func fetchTeamNames() -> [String] {
        return teamManager.fetchNames()
    }
    
    func fetchIsActive() -> [Bool] {
        return teamManager.fetchIsActiveList()
    }
    
    func resetScores() {
        teamManager.resetScores(resetScoreValue: 0)
    }
    
    func resetTeams() {
        teamManager.resetTeams()
        transmitData()
    }
    
    func setIsActive(isActive: Bool, teamIndex: Int) {
        teamManager.updateTeamIsActive(teamNumber: teamIndex + 1, isActive: isActive)
        transmitData()
    }
    
    func setTeamName(newName: String, teamIndex: Int) {
        teamManager.updateTeamName(teamNumber: teamIndex + 1, name: newName)
    }
    
    //MARK: - Themes
    
    func updateTheme(theme: Theme, backgroundView: UIImageView, shouldTransmit: Bool) {
        
        backgroundView.image = theme.backgroundImage
        
        if theme.darkMode {
            self.overrideUserInterfaceStyle = .dark
        } else {
            self.overrideUserInterfaceStyle = .light
        }
        
        if shouldTransmit {
            if userEmail != nil {
                remoteControlTransmitter.transmitTheme(sender: userEmail!, themeName: theme.name)
            }
        }
        
    }
    
    func updateTheme(theme: Theme, backgroundImage: UIImageView?, subtitleLabels: [UILabel]?, scoreLabels: [UILabel]?, buttons: [UIButton]?, shouldTransmit: Bool) {
        scoreboardState.theme = theme
        
        if backgroundImage != nil {
            backgroundImage!.image = theme.backgroundImage
        }
        
        if subtitleLabels != nil {
            for label in subtitleLabels! {
                label.font = UIFont(name:theme.subtitleFont!.fontName, size: label.font.pointSize)
                label.textColor = theme.subtitleColor
                label.shadowColor = theme.shadowColor
                //                label.shadowOffset = CGSize(width: theme.shadowWidth!, height: theme.shadowHeight!)
            }
        }
        
        if scoreLabels != nil {
            for label in scoreLabels! {
                label.font = UIFont(name:theme.scoreFont!.fontName, size: label.font.pointSize)
                label.textColor = theme.scoreColor
                label.shadowColor = theme.shadowColor
                //                label.shadowOffset = CGSize(width: theme.shadowWidth!, height: theme.shadowHeight!)
            }
        }
        
        if buttons != nil {
            updateUIForButtonSelection(buttons: buttons!)
        }
        
        if theme.darkMode {
            self.overrideUserInterfaceStyle = .dark
        } else {
            self.overrideUserInterfaceStyle = .light
            
        }
        
        if shouldTransmit {
            if userEmail != nil {
                remoteControlTransmitter.transmitTheme(sender: userEmail!, themeName: theme.name)
            }
        }
    }
    
    //MARK: - Update UI Buttons
    func updateUIForButtonSelection(buttons: [UIButton]) {
        for i in buttons {
            if i.isSelected == true {
                i.tintColor = scoreboardState.theme.buttonSelectedColor1!
            } else {
                i.tintColor = scoreboardState.theme.buttonColor!
            }
        }
    }
    
    func updateUIForButtonTint(buttons: [UIButton]) {
        for i in buttons {
            i.tintColor = scoreboardState.theme.buttonColor
        }
    }
    
    //MARK: - Hide UI
    
    func hideUI (viewsToHide: [UIView], hidden: Bool) {
        for view in viewsToHide {
            view.isHidden = hidden
        }
    }
}

//MARK: - Transmitter Delegate
extension ScoreBoardViewController: RemoteControlTransmitterDelegate {
    func updateTheme(newTheme: String) {
        let themeGroups: [[Theme]] = ThemesDatabase().themeGroups
        var themeSelected: Theme?
        
        for group in themeGroups {
            for theme in group {
                if theme.name == newTheme {
                    themeSelected = theme
                }
            }
        }
        
        if themeSelected != nil {
            themeDelegate?.implementTheme(theme: themeSelected!)
        }
    }
    
    
    func recordTeamInfo(teamInfo: Team, refreshScreen: Bool) {
        teamManager.recordTeamInfo(teamInfo: teamInfo)
        if refreshScreen {
            scoreBoardDelegate?.refreshScreen(reTransmit: false)
        }
    }
    
    func userFeedback(feedback: String) {
        scoreBoardDelegate?.displayUserFeedback(feedback: feedback)
    }
    
    func transmitData() {
        let teamList = teamManager.teamList
        
        if let safeEmail = userEmail {
            print("email detected: \(safeEmail), proceeding to transmit as instructed")
            remoteControlTransmitter.transmitUpdatedScores(sender: safeEmail, teamList: teamList)
        } else {
            print("no email detected, canceling transmition")
        }
    }
    
    func setupRemoteTransmitter(userEmail: String) {
        print("setting up remote transmitter")
        self.userEmail = userEmail
        remoteControlTransmitter.delegate = remoteDelegate
        remoteControlTransmitter.listenForUpdatedScores(sender: userEmail)
        self.remoteDisplay = true
    }
    
}
