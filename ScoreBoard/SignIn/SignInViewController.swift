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
        let deviceType = Utilities.DeviceInfo().deviceType
        if deviceType == .iPhone {
            
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
        else if deviceType == .iPad {
            
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
        feedbackLabel.text = "You will not be able to synchronize your scoreboard with other devices if you sign out.  \n\n You will still be able to use aiplay mirroring."
        signInTable.isHidden = true
        forgotPasswordButton.setTitle("Delete Account", for: .normal)
//        forgotPasswordButton.titleLabel?.text = "Delete Account"
        continueButton.setTitle("Sign Out", for: .normal)
//        continueButton.titleLabel?.text = "Sign Out"
    }
    
    //MARK: - SignIn/Out Button
    
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
            signOut(dismissView: true)
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
    
    func signOut(dismissView: Bool) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            if dismissView { dismiss(animated: true) }
        } catch let signOutError as NSError {
            feedbackLabel.text = "Error signing out: %@ \(signOutError)"
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
        
    //MARK: - Reset Password/Detete Account Button
    
    @IBAction func resetPasswordButtonPressed(_ sender: UIButton) {
        if signOutMode == false { // Forgot Password Button
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
        } else { // Delete Account Button
            
            // Show a confirmation alert
            let confirmationAlert = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete your account? This action cannot be undone.", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                performAccountDeletion()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            confirmationAlert.addAction(deleteAction)
            confirmationAlert.addAction(cancelAction)
            
            self.present(confirmationAlert, animated: true, completion: nil)
            
            func performAccountDeletion() {
                // Get the current user
                guard let user = Auth.auth().currentUser else {
                    // Handle case where user is not logged in (unlikely if this button is shown)
                    showAlert(title: "Error", message: "No user is currently signed in.")
                    return
                }
                
                // Delete the user's account
                user.delete { error in
                    if let error = error as NSError? {
                        // Handle errors here, possibly needing re-authentication
                        if error.code == AuthErrorCode.requiresRecentLogin.rawValue {
                            self.reauthenticateAndDelete(user: user)
                        } else {
                            self.showAlert(title: "Error", message: error.localizedDescription)
                        }
                    } else {
                        deleteUserCredentialsFromKeychain()
                        let feedbackText = "Your account has been successfully deleted."
                        // Successfully deleted the account
                        self.showAlert(title: "Account Deleted", message: feedbackText)
                        // Complete Sign Out
                        self.signOut(dismissView: false)
                        // Update View
                        self.feedbackLabel.text = feedbackText
                        self.forgotPasswordButton.isHidden = true
                        self.continueButton.isHidden = true
                    }
                }
            }
            
            func deleteUserCredentialsFromKeychain() {
                let _ = KeychainManager.delete(dataType: .username)
                let _ = KeychainManager.delete(dataType: .password)
            }
        }
    }
    
    //MARK: - Delete Account
    func reauthenticateAndDelete(user: User) {
        // Re-authenticate the user before deleting the account
        let alert = UIAlertController(title: "Re-authentication Required", message: "Please re-enter your password to delete your account.", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            let password = alert.textFields?.first?.text ?? ""
            
            let credential = EmailAuthProvider.credential(withEmail: user.email ?? "", password: password)
            
            user.reauthenticate(with: credential) { result, error in
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                } else {
                    // After re-authentication, attempt to delete again
                    self.resetPasswordButtonPressed(self.forgotPasswordButton)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)

    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Exit Button
    
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
