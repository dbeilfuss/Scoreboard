//
//  ExternalDisplayViewController.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 7/6/24.
//

import UIKit

class ExternalDisplayViewController: ScoreBoardViewController {
    
    //MARK: - Properties
    var shouldNeverDisplayUI = false
    
    //MARK: - IBOutlets
    
    /// Stacks
    @IBOutlet weak var mainScoreBoardStack: TeamScoresStackView!
    
    // Background
    @IBOutlet weak var backgroundView: UIImageView!
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad: \(#fileID)")
        
        // Create Teams
        createTeamViews()
        
        /// Refresh Screen after Setup
        implementActiveTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear - \(#fileID)")
        lockOrientation(to: .landscapeLeft)
    }
    
    
    //MARK: - TeamViews
    
    func createTeamViews() {
        mainScoreBoardStack.set(activeTeamList: teamManager.fetchActiveTeams(), theme: themeManager.fetchActiveTheme(), state: themeManager.fetchScoreboardState())
    }
    
    func refreshTeamViews() {
        var modifiedScoreboardState = themeManager.fetchScoreboardState()
        modifiedScoreboardState.uiIsHidden = true
        mainScoreBoardStack.refreshTeamViews(teamList: teamManager.fetchTeamList(), theme: themeManager.fetchActiveTheme(), state: modifiedScoreboardState)
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
    }
    
    func updateBackground() {
        let activeTheme = themeManager.fetchActiveTheme()
        if constants.printThemeFlow {
            print("updating Background for theme: \(activeTheme.name), File: \(#fileID)")
        }
        activeTheme.format(background: backgroundView)
    }
    
}
