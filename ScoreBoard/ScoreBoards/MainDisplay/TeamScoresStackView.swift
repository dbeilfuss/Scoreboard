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
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Setter
    
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
            NSLayoutConstraint.activate([teamView.centerYAnchor.constraint(equalTo: teamView.superview!.centerYAnchor, constant: 0)])
        }
        
    }
    
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
    
    private func displayTeamView(_ view: TeamView, teamCount: Int) {
        
        // create top row if needed
        if self.arrangedSubviews.count == 0 {
            createScoreboardStackView()
        }
        
        // choose bottom or top row
        var scoreRow: UIStackView = self.arrangedSubviews.first! as! UIStackView
        
        var idealTeamsPerRow = 3
        let deviceType = Utilities.DeviceInfo().deviceType
        if deviceType == .iPhone {
            idealTeamsPerRow = 4
        }
        
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
        
        scoreRow.insertArrangedSubview(view, at: 0)
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
    
    private func createScoreboardStackView() {
        let scoreboardStackView = UIStackView()
        self.addArrangedSubview(scoreboardStackView)
        
        // configure
        scoreboardStackView.alignment = .center
        scoreboardStackView.distribution = .fillEqually
        
        // constraints
        NSLayoutConstraint.activate([
            scoreboardStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            scoreboardStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
        ])
    }
    
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
    
    
//    private func createScoreView(teamName: String, score: Int) -> UIView {
//        let containerView = UIView()
//        
//        let teamLabel = UILabel()
//        teamLabel.text = teamName
//        teamLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
//        
//        let scoreLabel = UILabel()
//        scoreLabel.text = "\(score)"
//        scoreLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
//        
//        let stackView = UIStackView(arrangedSubviews: [teamLabel, scoreLabel])
//        stackView.axis = .horizontal
//        stackView.distribution = .fillEqually
//        stackView.alignment = .center
//        
//        containerView.addSubview(stackView)
//        
//        // Layout the inner stack view within the container view
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
//            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
//            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
//            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
//        ])
//        
//        return containerView
//    }
}
