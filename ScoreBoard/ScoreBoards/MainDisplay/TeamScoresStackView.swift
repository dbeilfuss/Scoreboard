//
//  ScoreBoardStackView.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 7/13/24.
//

import UIKit

class TeamScoresStackView: UIStackView {
    
    //MARK: - Properties
    
    // Settings
    let idealTeamsPerRow = 3
    var forceResetBoard = false
    
    // Data Storage
    private var teamViews: [TeamView] = []
    private var delegate: TeamCellDelegate?

    
    //MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setVisualElements() {
        self.distribution = .equalCentering
    }
    
    //MARK: - Setter
    
    func set(delegate: TeamCellDelegate) {
        self.delegate = delegate
    }
    
    func set(state: ScoreboardState) {
        for view in teamViews {
            view.set(scoreboardState: state)
        }
    }
    
    func set(theme: Theme) {
        for view in teamViews {
            view.set(theme: theme)
        }
    }
    
    func set(activeTeamList: [Team], theme: Theme, state: ScoreboardState) {

    }
    
    //MARK: - Create
    
    private func eraseBoard() {
        teamViews = []
        for stackView in self.arrangedSubviews {
            stackView.removeFromSuperview()
        }
    }
    
    private func createTeamView(team: Team, theme: Theme, state: ScoreboardState) -> TeamView {
        
        // Setup TeamView
        let teamView = TeamView()
        teamView.set(scoreboardState: state)
        teamView.set(theme: theme)
        teamView.set(delegate: delegate)
        
        return teamView
    }
    
    private func createScoreboardStackViews(activeTeamsCount: Int) {
        // Calculate Rows Needed
        let rowsNeeded = activeTeamsCount > idealTeamsPerRow ? 2 : 1
        
        // Create StackViews
        var i = rowsNeeded
        while i > 0 {
            createScoreboardStackView()
            i -= 1
        }
    }
    
    func addTeamViewsToRows() {
        var scoreRow: UIStackView = self.arrangedSubviews.first! as! UIStackView
                
        var i = teamViews.count
        if self.arrangedSubviews.count > 1 {
            for view in teamViews {
                if i > (teamViews.count - i + 1) { // Use Bottom Row
                    scoreRow = self.arrangedSubviews.last! as! UIStackView
                } else { // Use Top Row
                    scoreRow = self.arrangedSubviews.first! as! UIStackView
                }
                scoreRow.insertArrangedSubview(view, at: 0)
                i -= 1
            }
        } else {
            for view in teamViews {
                scoreRow.insertArrangedSubview(view, at: 0)
                i += 1
            }
        }
        
        if Constants().printTeamFlowDetailed {
            for scoreboardStack in self.arrangedSubviews as! [UIStackView] {
                print("scoreboardStack.arrangedSubviews.count: \(scoreboardStack.arrangedSubviews.count) - \(#fileID)")
            }
        }
    }

    private func createScoreboardStackView() {
        let scoreboardStackView = UIStackView()
        self.addArrangedSubview(scoreboardStackView)
        
        // configure
        scoreboardStackView.alignment = .center
        scoreboardStackView.distribution = .fillEqually
        
        // constraints
        NSLayoutConstraint.activate([
            scoreboardStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            scoreboardStackView.widthAnchor.constraint(equalTo: self.widthAnchor),
        ])
    }
    
    private func shouldResetBoard(activeTeamList: [Team]) -> Bool {
        if forceResetBoard { return true }
        
        // Gather Information
        let teamManagerTeamNumbers = activeTeamList.map({$0.number})
        let teamViewTeamNumbers = teamViews.map({$0.teamInfo.number})
        
        // Return True or False
        if teamViewTeamNumbers == teamManagerTeamNumbers {
            return false
        } else {
            let constants = Constants()
            if constants.printTeamFlow || constants.printThemeFlow { print("should reset board") }
            return true
        }
        
    }

    
    //MARK: - Refresh
    func refreshTeamViews(teamList: [Team], theme: Theme, state: ScoreboardState) {
        // Print
        if Constants().printTeamFlow {
            print("refreshing teamViews - \(#fileID)")
        }
        
        // Properties
        var activeTeamList = teamList.filter({$0.isActive == true})
        activeTeamList = activeTeamList.reversed()
        
        // Reset If Needed
        if shouldResetBoard(activeTeamList: activeTeamList) {
            eraseBoard()
            createScoreboardStackViews(activeTeamsCount: activeTeamList.count)
            createTeamViews(activeTeamList: activeTeamList, theme: theme, state: state)
            addTeamViewsToRows()
            adjustTeamViewConstraints()
            setTeamViewsProperties()
        }
        
        // Set teamView Data
        setTeamViewData(activeTeamList: activeTeamList, state: state, theme: theme)
        
    }
    
    private func setTeamViewData(activeTeamList: [Team], state: ScoreboardState, theme: Theme) {
        var i = 0
        for team in activeTeamList {
            teamViews[i].set(teamInfo: team)
            teamViews[i].set(scoreboardState: state)
            teamViews[i].set(theme: theme)
            i += 1
        }
    }
    
    func createTeamViews(activeTeamList: [Team], theme: Theme, state: ScoreboardState) {
        // Create the Views
        for team in activeTeamList {
            let teamView = createTeamView(team: team, theme: theme, state: state)
            teamViews.append(teamView)
        }
                
    }
    
    //MARK: - Display & Adjust Constraints
    
    func adjustTeamViewConstraints() {
        
        // Properties
        var teamViews = self.teamViews
        
        if teamViews.count > 0 {
            // Separate out Initial View
            let initialTeamView = teamViews.removeLast()
            NSLayoutConstraint.activate([initialTeamView.heightAnchor.constraint(equalTo: initialTeamView.heightAnchor)])

            // Apply Constraints
            for teamView in teamViews {
                NSLayoutConstraint.activate([
                    teamView.heightAnchor.constraint(equalTo: initialTeamView.heightAnchor),
                ])
            }
            
            teamViews.append(initialTeamView)
        }
    }
    
    func setTeamViewsProperties() {
        // StackView Height
        if self.arrangedSubviews.count > 0 {
            let height = self.frame.height / 2
            let width = self.frame.width / CGFloat((self.arrangedSubviews as! [UIStackView]).first!.arrangedSubviews.count)
            for view in teamViews {
                view.setStackViewHeight(height: height, width: width)
            }
        }
        
        // Font Size
        var fontSizes: [String: CGFloat]?
        for teamView in teamViews {
            if fontSizes != nil {
                teamView.fontSizes = fontSizes!
            } else {
                fontSizes = teamView.fontSizes
                teamView.fontSizes = fontSizes!
            }
        }
    }
    
}
