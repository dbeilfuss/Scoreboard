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
    let constants = Constants()
    
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
  
    var userEnteredData: (username: String?, password: String?)
    
    var keychainCredentials: (username: String?, password: String?)
    
    //MARK: - Variables
    var signOutMode = false
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Table
        tableSetup()
        
        // UI Customization
        uiCustomizations()
        if signOutMode {
            reconfigureForSignout()
        }
        
        // Keychain
        keychainCredentials = loadCredentials()
        userEnteredData.username = keychainCredentials.username
        userEnteredData.password = keychainCredentials.password

    }
    
//MARK: - Table Setup
    func tableSetup() {
        signInTable.delegate = self
        signInTable.dataSource = self
        signInTable.register(UINib(nibName: "TextInputCell", bundle: nil), forCellReuseIdentifier: "textInputCell")
    }
    
    //MARK: - UICutomizations
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
            titleLabel.text = constants.appName
            titleLabel.font = constants.titleFontIPhone
            subtitleLabel.font = constants.subTitleFontIPhone
            forgotPasswordButton.titleLabel?.font = constants.bodyIPhone
            
        }
        
        /// UI Changes for iPad
        else if UIDevice.current.localizedModel == "iPad" {
            
            /// App Icon
            appIcon.isHidden = true
            
            /// Fonts
            titleLabel.text = constants.appName
            titleLabel.font = constants.titleFontIPad
            subtitleLabel.font = constants.subTitleFontIPad
            forgotPasswordButton.titleLabel?.font = constants.bodyIPadSmall
            
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
    
    //MARK: - SignInButton
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if signOutMode == false {
            if let email = userEnteredData.username, let password = userEnteredData.password {
                feedbackLabel.text = "Signing You In"
                
                // Attempt to Create User
                Auth.auth().createUser(withEmail: email, password: password) {
                    authResult, error in
                    
                    if let _ = error {
                        
                        // If User Already Exists, Sign In
                        self.signIn(email: email, password: password)
                    } else {
                        
                        // Else, user created, continue
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
                self.saveCredentials(username: email, password: password)
                self.dismiss(animated: true)
            }
        }
    }
    
    //MARK: - Keychain
    func saveCredentials(username: String, password: String) {
        let usernameData = Data(username.utf8)
        let passwordData = Data(password.utf8)
        
        let usernameStatus = KeychainManager.save(dataType: .username, data: usernameData)
        let passwordStatus = KeychainManager.save(dataType: .password, data: passwordData)
        
        print("usernameStatus: \(usernameStatus) - \(#fileID)")
        print("passwordStatus: \(passwordStatus) - \(#fileID)")

    }
    
    func loadCredentials() -> (username: String?, password: String?) {
        if let usernameData = KeychainManager.load(dataType: .username),
           let passwordData = KeychainManager.load(dataType: .password) {
            
            let username = String(data: usernameData, encoding: .utf8)
            let password = String(data: passwordData, encoding: .utf8)
            
            return (username, password)
        }
        return (nil, nil)
    }
        
    //MARK: - ResetPasswordButton
    
    @IBAction func resetPasswordButtonPressed(_ sender: UIButton) {
        if let email = userEnteredData.username {
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
            cell.textField.text = keychainCredentials.password
        } else if cell.label.text == "Username" {
            cell.textField.textContentType = .username
            cell.textField.keyboardType = .emailAddress
            cell.textField.text = keychainCredentials.username
        }
        
        return cell
    }
}

//MARK: - Text Input Delegate
extension SignInViewController: textInputDelegate {
    func storeUserData(textField: String, dataEntered: String) {
        if textField == "Password" {
            userEnteredData.password = dataEntered
        } else if textField == "Username" {
            userEnteredData.username = dataEntered
        }
    }
    
    func editing (currentlyEditing: Bool) {
        if currentlyEditing {
            continueButton.isHidden = true
        } else {
            continueButton.isHidden = false
        }
    }
}
