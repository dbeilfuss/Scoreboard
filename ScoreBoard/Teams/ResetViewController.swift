//
//  ResetViewController.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/27/23.
//

import UIKit

protocol ResetDelegate {
    func resetScores()
    func resetTeamNames()
}

class ResetViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    /// Contraints
    @IBOutlet weak var stackViewTop: NSLayoutConstraint!
    
    //MARK: - Delegation
    var teamManager: TeamManagerProtocol?
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Shorten View Height (works on iPad)
        self.preferredContentSize = CGSize(width: 300, height: 200)
        
        /// Constraint Adjustments for iPhone
        if UIDevice.current.localizedModel == "iPhone" {
            if UIDevice.current.orientation == .portrait {
                stackViewTop.constant = 150
            } else {
                stackViewTop.constant = 75
            }
        }
    }
    
    @IBAction func resetScoresPressed(_ sender: Any) {
        teamManager?.resetScores()
        self.dismiss(animated: true)
    }
    
    
    @IBAction func resetNamesPressed(_ sender: UIButton) {
        teamManager?.resetTeamNames()
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
