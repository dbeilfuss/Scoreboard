//
//  LoginViewController.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 12/20/22.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    /// Imports
    let k = Constants()
    
    /// App Icon
    @IBOutlet weak var appIcon: UIImageView!
    
    /// Table View
    @IBOutlet weak var signInTable: UITableView!
    
    /// Title Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    /// Buttons
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var continueButton: LargeTransparentButton!
    @IBOutlet weak var continueButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIButton!
    
    /// User Feedback Label
    @IBOutlet weak var feedbackLabel: UILabel!
    
    //MARK: - Table Data
    let tableLabels: [String] = [
    "Username",
    "Password"
    ]
    
    let tableCellPlaceholders: [String] = [
    "example@icloud.com",
    "Enter your password"
    ]
    
    var userEnteredData: [String: String?] = [
        "Username": nil,
        "Password": nil
    ]
    
    //MARK: - Variables
    var signOutMode = false
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tableSetup()
        uiCustomizations()
        if signOutMode {
            reconfigureForSignout()
        }
        
    }
    
    /// Table Setup
    func tableSetup() {
        signInTable.delegate = self
        signInTable.dataSource = self
        signInTable.register(UINib(nibName: "TextInputCell", bundle: nil), forCellReuseIdentifier: "textInputCell")
    }
    
    /// UICustomizations
    func uiCustomizations() {
        /// Set Dark Mode
        self.overrideUserInterfaceStyle = .dark
        
        /// Set Constraint Factor: The root number for all the constraint calculations
        let constraintFactor: CGFloat = 50
        
        /// UI Changes for iPhone
        if UIDevice.current.localizedModel == "iPhone" {
            
            /// App Icon
            appIcon.isHidden = false
            appIcon.layer.cornerRadius = constraintFactor
            
            /// Fonts
            titleLabel.text = k.appName
            titleLabel.font = k.titleFontIPhone
            subtitleLabel.font = k.subTitleFontIPhone
            forgotPasswordButton.titleLabel?.font = k.bodyIPhone
            
        }
        
        /// UI Changes for iPad
        else if UIDevice.current.localizedModel == "iPad" {
            
            /// App Icon
            appIcon.isHidden = true
            
            /// Fonts
            titleLabel.text = k.appName
            titleLabel.font = k.titleFontIPad
            subtitleLabel.font = k.subTitleFontIPad
            forgotPasswordButton.titleLabel?.font = k.bodyIPadSmall
            
            /// Buttons
            backButton.isHidden = true

        }
        
        /// Buttons
        let buttonHeight = constraintFactor * 1.2
        continueButtonHeight.constant = buttonHeight
        continueButton.layer.cornerRadius = buttonHeight / 2
    }
    
    func reconfigureForSignout() {
        feedbackLabel.text = "You will not be able to use Remote Features if you Sign Out."
        signInTable.isHidden = true
        forgotPasswordButton.isHidden = true
        continueButton.titleLabel?.text = "Sign Out"
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if signOutMode == false {
            if let email = userEnteredData["Username"]!, let password = userEnteredData["Password"]! {
                feedbackLabel.text = "Signing You In"
                Auth.auth().createUser(withEmail: email, password: password) {
                    authResult, error in
                    if let _ = error {
//                        self.feedbackLabel.text = e.localizedDescription
                        self.signIn(email: email, password: password)
                    } else {
                        self.dismiss(animated: true)
                    }
                }
            }
        } else {
            signOut()
            self.dismiss(animated: true)
        }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {
            authResult, error in
            if let e = error {
                self.feedbackLabel.text = e.localizedDescription
            } else {
                self.dismiss(animated: true)
            }
        }
    }
        
    @IBAction func resetPasswordButtonPressed(_ sender: UIButton) {
        if let email = userEnteredData["Username"]! {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let e = error {
                    self.feedbackLabel.text = e.localizedDescription
                } else {
                    self.feedbackLabel.text = "A password reset email has been sent - please check your email."
                }
            }
        } else {
            feedbackLabel.text = "Please enter your email address."
        }
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            dismiss(animated: true)
        } catch let signOutError as NSError {
            feedbackLabel.text = "Error signing out: %@ \(signOutError)"
        }
    }
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
}

//MARK: - TableView Delegate

extension SignInViewController: UITableViewDelegate {
    
}

//MARK: - TableView Datasource

extension SignInViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableLabels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /// Create Cell
        let cell = signInTable.dequeueReusableCell(withIdentifier: "textInputCell", for: indexPath) as! TextInputCell
        
        /// Pass info to cell
        cell.label.text = tableLabels[indexPath.row]
        cell.textField.placeholder = tableCellPlaceholders[indexPath.row]
        cell.delegate = self
        cell.textField.autocorrectionType = .no
        
        if cell.label.text == "Password" {
            cell.textField.textContentType = .password
            cell.textField.isSecureTextEntry = true
        } else if cell.label.text == "Username" {
            cell.textField.textContentType = .username
            cell.textField.keyboardType = .emailAddress
        }
        
        return cell
    }
}

//MARK: - Text Input Delegate
extension SignInViewController: textInputDelegate {
    func storeUserData(textField: String, dataEntered: String) {
        userEnteredData[textField] = dataEntered
    }
    
    func editing (currentlyEditing: Bool) {
        if currentlyEditing {
            continueButton.isHidden = true
        } else {
            continueButton.isHidden = false
        }
    }
}
