//
//  ScoreBoardStackView.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 7/13/24.
//

import UIKit

class TeamScoresStackView: UIStackView {
    
    //MARK: - Properties
    private var teamViews: [TeamView] = []
    private var activeTeamList: [Team] = []
    private var delegate: TeamCellDelegate?
    
    //MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setWidth()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setWidth()
    }
    
    //MARK: - Setter
    
    private func setWidth() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func set(delegate: TeamCellDelegate) {
        self.delegate = delegate
    }
    
    func set(activeTeamList: [Team], theme: Theme, state: ScoreboardState) {
        var teams = activeTeamList
        teams = teams.reversed()
        let teamCount = teams.count
        
        for team in teams {
            /// Create New TeamView
            let teamView = createTeamView(team: team, theme: theme, state: state)
            teamViews.append(teamView)
            displayTeamView(teamView, teamCount: teamCount)
        }
        
        adjustSizing()
    }
    
    func adjustSizing() {
        // Properties
        var widthMultiplyer: CGFloat = 0.9 // Proportionate width of the teamScoreStackView to the window
//        var windowWidth: CGFloat? {
//                var currentView: UIView? = self
//                while let view = currentView {
//                    if let window = view as? UIWindow {
//                        return window.frame.width
//                    }
//                    currentView = view.superview
//                }
//                return nil
//            }
        
        var safeAreaWidth: CGFloat? {
            var currentView: UIView? = self
            while let view = currentView {
                if let superview = view.superview, superview.safeAreaInsets != .zero {
                    let safeAreaWidth = superview.frame.width - superview.safeAreaInsets.left - superview.safeAreaInsets.right
                    return safeAreaWidth
                }
                currentView = view.superview
            }
            return nil
        }
        
        /// Resize Self
        if let safeWindowWidth = safeAreaWidth {
            NSLayoutConstraint.activate([self.widthAnchor.constraint(equalToConstant: safeWindowWidth * widthMultiplyer)])
        }
            
        /// Resize Team Views
        let columnCount = (self.arrangedSubviews.first as? UIStackView)?.arrangedSubviews.count ?? 1
        let teamViewWidth = self.frame.width / CGFloat(columnCount)
        
        for teamView in teamViews {
            NSLayoutConstraint.activate([
                teamView.centerYAnchor.constraint(equalTo: teamView.superview!.centerYAnchor, constant: 0),
                teamView.widthAnchor.constraint(equalToConstant: teamViewWidth)
            ])
        }
        
        /// Spacing Between Team Views
        for subview in self.subviews {
            if let stackView = subview as? UIStackView {
                let totalChildrenWidth = teamViewWidth * CGFloat(stackView.subviews.count)
                let targetSpacing = (self.frame.width - totalChildrenWidth) / CGFloat(stackView.subviews.count)
                stackView.spacing = targetSpacing
            }
        }
    }
    
    private func displayTeamView(_ teamView: TeamView, teamCount: Int) {
        
        // create top row if needed
        if self.arrangedSubviews.count == 0 {
            createScoreboardStackView()
        }
        
        // choose bottom or top row
        var scoreRow: UIStackView = self.arrangedSubviews.first! as! UIStackView
        
        var idealTeamsPerRow = 3
        
        if teamCount > idealTeamsPerRow {
            if teamViews.count < ((teamCount / 2) + 1) {
                
                // create bottom row if needed
                if self.arrangedSubviews.count < 2 {
                    createScoreboardStackView()
                }
                
                // use bottom row
                scoreRow = self.arrangedSubviews.last! as! UIStackView
            }
        }
        
        scoreRow.insertArrangedSubview(teamView, at: 0)
    }

    
    //MARK: - Create
    private func createTeamView(team: Team, theme: Theme, state: ScoreboardState) -> TeamView {
        
        // Setup TeamView
        let teamView = TeamView()
        teamView.translatesAutoresizingMaskIntoConstraints = false
        teamView.set(teamInfo: team)
        teamView.set(scoreboardState: state, activeTeamCount: activeTeamList.count, theme: theme)
        if delegate != nil {
            teamView.set(delegate: delegate!)
        }
        
        return teamView
    }
    
    private func createScoreboardStackView() {
        let scoreboardStackView = UIStackView()
        self.addArrangedSubview(scoreboardStackView)
        
        // configure
        scoreboardStackView.alignment = .center
        scoreboardStackView.distribution = .equalCentering
        
        // constraints
        NSLayoutConstraint.activate([
//            scoreboardStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
//            scoreboardStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            scoreboardStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            
        ])
    }
    
    private func shouldReInitializeTeamViews(activeTeamList: [Team]) -> Bool {
        
        // Gather Information
        let teamManagerTeamNumbers = activeTeamList.map({$0.number})
        var teamViewTeamNumbers = teamViews.map({$0.teamInfo.number})
        teamViewTeamNumbers = teamViewTeamNumbers.reversed()
        
        // Return True or False
        if teamViewTeamNumbers == teamManagerTeamNumbers {
            return false
        } else {
            return true
        }
        
    }
    
    private func reInitializeTeamViews(activeTeamList: [Team], theme: Theme, state: ScoreboardState) {
        // Delete Current TeamViews
        teamViews = []
        for stackView in self.arrangedSubviews {
            stackView.removeFromSuperview()
        }
        
        // Refill the ScoresRows
        set(activeTeamList: activeTeamList, theme: theme, state: state)
    }
    
    //MARK: - Refresh
    func refreshTeamViews(teamList: [Team], theme: Theme, state: ScoreboardState) {
        if Constants().printTeamFlow {
            print("refreshing teamViews - \(#fileID)")
        }
        
        let activeTeamList = teamList.filter({$0.isActive == true})
        self.activeTeamList = activeTeamList
        
        // Reinitialize teamViews if needed
        if shouldReInitializeTeamViews(activeTeamList: activeTeamList) {
            reInitializeTeamViews(activeTeamList: activeTeamList, theme: theme, state: state)
        }
        
        // Pass Data into the team views
        for view in teamViews {
            let teamNumber = view.teamInfo.number
            let newTeamInfo: Team = teamList[teamNumber - 1]
            view.set(teamInfo: newTeamInfo)
            view.set(scoreboardState: state, activeTeamCount: activeTeamList.count, theme: theme)
        }
    }
    
}
