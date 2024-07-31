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
    @IBOutlet weak var teamScoresStackView: TeamScoresStackView!
    
    // Background
    @IBOutlet weak var backgroundView: UIImageView!
    
    //MARK: - ViewLoading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Refresh Screen after Setup
        refreshUIForTheme()
        
    }
    
    //MARK: - ViewAppearing
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Create Teams
        refreshUIForTeams()
        
    }
    
    //MARK: - Update UI
    
    override func refreshUIForTheme() {
        super.refreshUIForTheme()
        
        if constants.printThemeFlow {
            print("implementingActiveTheme, File: \(#fileID)")
        }
        
        let activeTheme = themeManager.fetchActiveTheme()
        
        // Update Self
        activeTheme.format(background: backgroundView)

        // Update teamScoresStackView
        var state = themeManager.fetchScoreboardState()
        state.uiIsHidden = true
        teamScoresStackView.set(state: state)
        teamScoresStackView.set(theme: activeTheme)
        
    }
    
    override func refreshUIForTeams() {
        super.refreshUIForTeams()
        
        if constants.printTeamFlowDetailed {
            print("implementingTeams, File: \(#fileID)")
        }
        
        var state = themeManager.fetchScoreboardState()
        state.uiIsHidden = true
        teamScoresStackView.refreshTeamViews(teamList: teamManager.fetchTeamList(), theme: themeManager.fetchActiveTheme(), state: state)    }
    
}
