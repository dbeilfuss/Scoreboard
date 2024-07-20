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
    
    func setVisualElements() {
        self.distribution = .fillEqually
    }
    
    //MARK: - Setter
    
    func set(delegate: TeamCellDelegate) {
        self.delegate = delegate
    }
    
    func set(theme: Theme, state: ScoreboardState) {
        for view in teamViews {
            view.set(scoreboardState: state, theme: theme)
        }
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
        
        adjustTeamViewConstraints()
    }
    
    //MARK: - Create
    private func createTeamView(team: Team, theme: Theme, state: ScoreboardState) -> TeamView {
        
        // Setup TeamView
        let teamView = TeamView()
        teamView.translatesAutoresizingMaskIntoConstraints = false
        teamView.set(scoreboardState: state, theme: theme)
        teamView.set(teamInfo: team)
        teamView.set(delegate: delegate)
        
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
            view.set(scoreboardState: state, theme: theme)
        }
    }
    
    //MARK: - Display & Adjust Constraints
    private func displayTeamView(_ teamView: TeamView, teamCount: Int) {
        
        // create top row if needed
        if self.arrangedSubviews.count == 0 {
            createScoreboardStackView()
        }
        
        // choose bottom or top row
        var scoreRow: UIStackView = self.arrangedSubviews.first! as! UIStackView
        
        let idealTeamsPerRow = 3
        
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
    
    func adjustTeamViewConstraints() {

//        var safeAreaWidth: CGFloat? {
//            var currentView: UIView? = self
//            while let view = currentView {
//                if let superview = view.superview, superview.safeAreaInsets != .zero {
//                    let safeAreaWidth = superview.frame.width - superview.safeAreaInsets.left - superview.safeAreaInsets.right
//                    return safeAreaWidth
//                }
//                currentView = view.superview
//            }
//            return nil
//        }
    
        /// Helper Functionality
        
        enum Dimension {
            case height
            case width
        }
        
        func constrainForWidth(width: CGFloat) {
            for teamView in teamViews {
                print("constraining for width")
                print("teamViews.count: \(teamViews.count)")
                teamView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
//                    teamView.centerYAnchor.constraint(equalTo: teamView.superview!.centerYAnchor, constant: 0),
                    teamView.widthAnchor.constraint(equalToConstant: width)
                ])
            }
        }
        
        func constrainForHeight(height: CGFloat) {
            print("constraining for height")
            print("teamViews.count: \(teamViews.count)")
            for teamView in teamViews {
                teamView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
//                    teamView.heightAnchor.constraint(equalTo: teamView.superview!.heightAnchor),
                    teamView.heightAnchor.constraint(equalToConstant: height)
                ])
            }
        }
        
        func printConstraints(for views: [UIView]) {
            for view in views {
                print(view.constraints.count)
                print(view.constraints.first)
            }
        }
        
        /// Properties
        let teamViewAspectConstraint: NSLayoutConstraint = teamViews[0].aspectContraint
        let teamViewWidthRatio = teamViewAspectConstraint.multiplier
        print("teamViewWidthRatio: \(teamViewWidthRatio)")
        let columnCount = (self.arrangedSubviews.first as? UIStackView)?.arrangedSubviews.count ?? 1
        print("columnCount: \(columnCount)")
        let targetTeamViewWidth = self.frame.width / CGFloat(columnCount)
        print("teamViewWidth: \(targetTeamViewWidth)")
        let scoreRow: UIStackView = self.arrangedSubviews.first! as! UIStackView
        let targetScoreRowHeight: CGFloat = self.frame.height / CGFloat(self.arrangedSubviews.count)
        print("targetScoreRowHeight: \(targetScoreRowHeight)")
        let scoreRowWidth: CGFloat = scoreRow.frame.width
        
        /// Determine Which Dimension to Constrain
        var dimensionToConstrain: Dimension {
            let resultingWidthRatio = targetTeamViewWidth / targetScoreRowHeight
            if resultingWidthRatio  > teamViewWidthRatio {
                print("resultingWidthRatio: \(resultingWidthRatio)")
                return .height
            } else {
                print("resultingWidthRatio: \(resultingWidthRatio)")
                return .width
            }
        }
        
        print("should constrain teamViews for \(dimensionToConstrain)")
        
        /// Constrain Appropriate Dimension
        switch dimensionToConstrain {
        case .height:
            constrainForHeight(height: targetScoreRowHeight)
            constrainForWidth(width: targetScoreRowHeight * teamViewWidthRatio)
            printConstraints(for: teamViews)
        case .width:
            constrainForWidth(width: targetTeamViewWidth)
            printConstraints(for: teamViews)
        }
        
        /// Adjust Spacing Between Team Views
//        for subview in self.subviews {
//            if let stackView = subview as? UIStackView {
//                switch dimensionToConstrain {
//                case .height:
//                    stackView.spacing = 0
//                case .width:
//                    
//                }
//                let totalChildrenWidth = targetTeamViewWidth * CGFloat(stackView.subviews.count)
//                let targetSpacing = (scoreRowWidth - totalChildrenWidth) / CGFloat(stackView.subviews.count)
//                print("stackView.subviews.count: \(stackView.subviews.count)")
//                print("targetSpacing: \(targetSpacing)")
//                stackView.spacing = targetSpacing
//            }
//            
//            
//        }
        
    }

   
    
}
