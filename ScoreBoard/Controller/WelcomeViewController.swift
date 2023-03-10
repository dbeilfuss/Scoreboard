//
//  WelcomeViewController.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/29/23.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    //MARK: - Import Databases
    let k = Constants()
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
    
    
    //MARK: - Variables
    var userEmail: String?
    
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
        titleLabel.text = k.appName
        subtitleLabel.text = k.subtitleMessage
        
        /// Set Constraint Factor: The root number for all the constraint calculations
        var constraintFactor: CGFloat = 50
        
        /// UI Changes for iPhone
        if UIDevice.current.localizedModel == "iPhone" {

            AppDelegate.AppUtility.lockOrientation(k.screenOrientationStandardiPhone)///  Unlocks Screen Orientation for iPads.
            
            titleLabel.font = k.titleFontIPhone /// Title Label Font Size
            subtitleLabel.font = k.subTitleFontIPhone /// Subtitle Label Font Size
            
            /// UI Changes for iPad
        } else if UIDevice.current.localizedModel == "iPad" {
            
            AppDelegate.AppUtility.lockOrientation(k.screenOrientationStandardiPad) ///  Unlocks Screen Orientation for iPads.
            
            constraintFactor *= 1.5 /// Adjust Constraint Factor for iPad
            
            titleLabel.font = k.titleFontIPad /// Title Label Font Size
            subtitleLabel.font = k.subTitleFontIPad /// Subtitle Label Font Size
        }
        
        /// App Icon
        for constraint in marginConstraints {
            constraint.constant = constraintFactor
        }
        appIconWidth.constant = constraintFactor * 2
        
        /// Make App Icon a Circle
        appIcon.layer.cornerRadius = constraintFactor
        
        /// Table Constraints
        tableViewTop.constant = constraintFactor / 2
        
        ///  Name Label Position
        titleLabelLeading.constant = constraintFactor
        titleLabelTop.constant = constraintFactor * 3 + 20
    }
    
    //MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// Check if User is signed in
        if Auth.auth().currentUser != nil {
            print("user signed in")
        }
        
        /// Get Current User
        let _ = Auth.auth().addStateDidChangeListener { auth, user in
            let user = Auth.auth().currentUser
            if let thisUser = user {
                self.userEmail = thisUser.email!
                print(thisUser.email!)
                self.signInButton.setTitle("Sign Out", for: .normal)
                self.userFeedbackLabel.text = self.userEmail!
            } else {
                self.userEmail = nil
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
            if userEmail != nil {
                DestinationVC.signOutMode = true
            }
        } else if segue.identifier == "welcomeToSignOut" {
            let DestinationVC = segue.destination as! SignOutViewController
        } else if (segue.identifier == "welcomeToScoreboard") || (segue.identifier == "welcomeToRemote") {
            let DestinationVC = segue.destination as! ScoreBoardViewController
            DestinationVC.userEmail = self.userEmail
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
            cell.label.font = k.tableFontIPhone
            
        /// Cell UIChanges for iPad
        } else {
            cell.label.font = k.tableFontIPad
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
