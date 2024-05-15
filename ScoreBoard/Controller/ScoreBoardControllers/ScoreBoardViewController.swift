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
    let k = Constants()
    
    var remoteControlTransmitter = RemoteControlTransmitter()
    //    var remoteControlTransmitterDelegate: RemoteControlTransmitterDelegate?
    
    var userEmail: String?
    var remoteDisplay = false
    var numberOfTeams: Int = 0
    
    //MARK: - Declare Delegates
    
    var scoreBoardDelegate: ScoreBoardDelegate?
    var remoteDelegate: RemoteControlTransmitterDelegate?
    var themeDelegate: ThemeDisplayDelegate?
    
    func declareScoreboardDelegate(scoreBoardDelegate: ScoreBoardDelegate, remoteDelegate: RemoteControlTransmitterDelegate, themeDelegate: ThemeDisplayDelegate) {
        //        print("declaring scoreboard delegate")
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
        //        print("adding to score")
        teamManager.addToScore(teamNumber: teamNumber, scoreToAdd: add)
        transmitData()
    }
    
    func replaceScore(teamNumber: Int, newScore: Int) {
        //        print("replacing score")
        teamManager.replaceScore(teamNumber: teamNumber, newScore: newScore)
    }
    
    func updateAllScores(scores: [Int]) {
        //        print("updating all scores")
        var i = 1
        for score in scores {
            print("recording \(score)")
            teamManager.replaceScore(teamNumber: i, newScore: score)
            i += 1
        }
    }
    
    func fetchScores() -> [Int] {
        //        print("fetching score")
        return teamManager.fetchScores()
    }
    
    func fetchTeamNames() -> [String] {
        //        print("fetching team names")
        return teamManager.fetchNames()
    }
    
    func fetchIsActive() -> [Bool] {
        //        print("fetching is active status")
        return teamManager.fetchIsActiveList()
    }
    
    func resetScores() {
        //        print("resetting scores")
        teamManager.resetScores(resetScoreValue: 0)
    }
    
    func resetTeams() {
        //        print("resetting teams")
        teamManager.resetTeams()
        transmitData()
    }
    
    func setIsActive(isActive: Bool, teamIndex: Int) {
        print("TeamManager: updating isActive Status")
        teamManager.updateTeamIsActive(teamNumber: teamIndex + 1, isActive: isActive)
        transmitData()
    }
    
    func setTeamName(newName: String, teamIndex: Int) {
        teamManager.updateTeamName(teamNumber: teamIndex + 1, name: newName)
    }
    
    //MARK: - Themes
    var theme: Theme = DefaultTheme().theme
    
    func updateTheme(theme: Theme, backgroundImage: UIImageView?, subtitleLabels: [UILabel]?, scoreLabels: [UILabel]?, buttons: [UIButton]?, transmit: Bool) {
        self.theme = theme
        
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
        
        if transmit {
            if userEmail != nil {
                remoteControlTransmitter.transmitTheme(sender: userEmail!, themeName: theme.name)
            }
        }
    }
    
    //MARK: - Update UI Buttons
    func updateUIForButtonSelection(buttons: [UIButton]) {
        for i in buttons {
            if i.isSelected == true {
                i.tintColor = theme.buttonSelectedColor1!
            } else {
                i.tintColor = theme.buttonColor!
            }
        }
    }
    
    func updateUIForButtonTint(buttons: [UIButton]) {
        for i in buttons {
            i.tintColor = theme.buttonColor
        }
    }
    
    //MARK: - Update UI for Team Updates
    
    func updateStepperValues(steppers: [UIStepper]) {
        let scores = teamManager.fetchScores()
        var i = 1
        for score in scores {
            for stepper in steppers {
                if stepper.tag == i {
                    stepper.value = Double(score)
                }
            }
            i += 1
        }
    }
    
    func updateUI(scoreLabels: [UILabel]) {
        let scores = teamManager.fetchScores()
        var i = 1
        for score in scores {
            for label in scoreLabels {
                if label.tag == i {
                    label.text = String(score)
                }
            }
            i += 1
        }
    }
    
    func updateUI(teamNamesLabels: [UILabel]) {
        let names = teamManager.fetchNames()
        var i = 1
        
        for name in names {
            for label in teamNamesLabels {
                if label.tag == i {
                    label.text = String(name)
                }
            }
            i += 1
        }
    }
    
    func updateUIForActiveTeams(views: [UIView]) {
        for thisView in views {
            if thisView.tag != 0 {
                thisView.isHidden = false
            } else {
                thisView.isHidden = true
            }
        }
    }
    
    func resizeFonts(labels: [UILabel], themeFont: UIFont) {
        
        /// Determine the appropriate font point size
        let themeFontSize: CGFloat = themeFont.pointSize
        let device: String = UIDevice.current.localizedModel
        var sizeMultiplyers: [Int: CGFloat] {
            if device == "iPad" {
                return TeamTextSizeStruct().iPadSizes
            } else {
                return TeamTextSizeStruct().iPhoneSizes
            }
        }
        let adjustedFontSize: CGFloat = themeFontSize * sizeMultiplyers[numberOfTeams]!
        
        /// Resize all point sizes to adjusted size
        for label in labels {
            label.font = UIFont(name: label.font.fontName, size: adjustedFontSize)
            label.shadowOffset.height = label.shadowOffset.height * sizeMultiplyers[numberOfTeams]! + 0.5
            label.shadowOffset.width = label.shadowOffset.width * sizeMultiplyers[numberOfTeams]! + 0.5
        }
    }
    
    //MARK: - Hide UI
    
    func hideUI (viewsToHide: [UIView], hidden: Bool) {
        for view in viewsToHide {
            view.isHidden = hidden
        }
    }
}

//MARK: - Extensions

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
        //        print("recording team info")
        teamManager.recordTeamInfo(teamInfo: teamInfo)
        if refreshScreen {
            scoreBoardDelegate?.refreshScreen(reTransmit: false)
        }
    }
    
    func userFeedback(feedback: String) {
        //        print("recording user feedback")
        scoreBoardDelegate?.displayUserFeedback(feedback: feedback)
    }
    
    func transmitData() {
        //        print("transmitting data")
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
