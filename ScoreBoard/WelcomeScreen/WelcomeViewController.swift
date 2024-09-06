//
//  WelcomeViewController.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/29/23.
//

import UIKit
#if !os(watchOS)
import Firebase
import FirebaseAuth
#endif

class WelcomeViewController: UIViewController {
    
    //MARK: - Import Databases
    let constants = Constants()
    let tableDatabase = WelcomeScreenDatabase()
    
    //MARK: - UIElements
    
    /// Icon
    @IBOutlet var appIcon: UIImageView!
    @IBOutlet weak var appIconWidth: NSLayoutConstraint!
    @IBOutlet weak var appIconTop: NSLayoutConstraint!
    @IBOutlet weak var appIconLeading: NSLayoutConstraint!
    
    /// Title Label
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var titleLabelTop: NSLayoutConstraint!
    
    /// Subtitle Label
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var subtitleLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var subtitleLabelTop: NSLayoutConstraint!

    /// TableView
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var tableViewLeading: NSLayoutConstraint!
    @IBOutlet weak var tableViewTop: NSLayoutConstraint!
    
    /// Margin Constraints
    var marginConstraints: [NSLayoutConstraint] {[
        appIconTop,
        appIconLeading,
        subtitleLabelLeading,
        tableViewLeading
    ]}
    
    /// Bottom Buttons
    @IBOutlet weak var signInButton: UIButton!
    
    /// User Feedback
    @IBOutlet weak var userFeedbackLabel: UILabel!
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Table Setup
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "WelcomeOptionsCell", bundle: nil), forCellReuseIdentifier: "optionCell1")
        
        //MARK: - UI Changes
        
        /// Dark Mode
        self.overrideUserInterfaceStyle = .dark
        
        /// Title & Subtitle Label Text
        titleLabel.text = constants.appName
        subtitleLabel.text = constants.subtitleMessage
        
        /// Set Constraint Factor: The root number for all the constraint calculations
        var constraintFactor: CGFloat = 50
        
        /// UI Changes for iPhone
        let deviceType = Utilities.DeviceInfo().deviceType

        switch deviceType {
        case .iPhone:
            iphoneUIChanges()
        case .iPad:
            iPadUIChanges()
        case .unknown:
            print("⛔️ unknown device, no UI Changes")
        }
        
        func iphoneUIChanges() {
            Utilities().updateOrientation(to: .portrait)
            titleLabel.font = constants.titleFontIPhone /// Title Label Font Size
            subtitleLabel.font = constants.subTitleFontIPhone /// Subtitle Label Font Size
        }

            /// UI Changes for iPad
        func iPadUIChanges() {
            Utilities().updateOrientation(to: .all)
            constraintFactor *= 1.5 /// Adjust Constraint Factor for iPad
            titleLabel.font = constants.titleFontIPad /// Title Label Font Size
            subtitleLabel.font = constants.subTitleFontIPad /// Subtitle Label Font Size
        }
        
        /// App Icon
        for constraint in marginConstraints {
            constraint.constant = constraintFactor
        }
        appIconWidth.constant = constraintFactor * 2
                
        /// Table Constraints
        tableViewTop.constant = constraintFactor / 2
        
        ///  Name Label Position
        titleLabelLeading.constant = constraintFactor
        titleLabelTop.constant = constraintFactor * 3 + 20
    }
    
    //MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// Get Current User
        let _ = Auth.auth().addStateDidChangeListener { auth, user in
            if let user: User = Auth.auth().currentUser {
                if self.constants.printStateFlow {
                    print("user signed in")
                    print(user.email!)
                }
                self.signInButton.setTitle("Sign Out", for: .normal)
                self.userFeedbackLabel.text = user.email
            } else {
                self.signInButton.setTitle("Sign In", for: .normal)
                self.userFeedbackLabel.text = ""
            }
        }
    }


//MARK: - Bottom Buttons
@IBAction func signInOutButtonPressed(_ sender: Any) {
            performSegue(withIdentifier: "welcomeToSignIn", sender: self)
    }
    
    //MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "welcomeToSignIn" {
            let DestinationVC = segue.destination as! SignInViewController
            if Auth.auth().currentUser != nil {
                DestinationVC.signOutMode = true
            }
        } else if segue.identifier == "welcomeToSignOut" {
            _ = segue.destination as! SignOutViewController
        } else if (segue.identifier == "welcomeToScoreboard") || (segue.identifier == "welcomeToRemote") {
            _ = segue.destination as! ScoreBoardViewController
        }
    }
    
}

extension WelcomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellCount = tableDatabase.tableData.count
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /// Create Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell1", for: indexPath) as! WelcomeOptionsCell
        
        /// Set Cell Label
        let label = tableDatabase.tableData[indexPath.row]
        cell.label.text = label
        
        /// Cell Icon
        cell.iconImage.image = tableDatabase.buttonIcons[label]
        
        /// Cell UI Changes for iPhone
        if UIDevice.current.localizedModel == "iPhone" {
            cell.label.font = constants.tableFontIPhone
            
        /// Cell UIChanges for iPad
        } else {
            cell.label.font = constants.tableFontIPad
        }
        
        return cell
        
    }
}

extension WelcomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "welcomeToScoreboard", sender: self)
        } else if indexPath.row == 1 {
            performSegue(withIdentifier: "welcomeToRemote", sender: self)
        }
    }
    
}
