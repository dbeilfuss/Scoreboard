////
////  RemoteSetupViewController.swift
////  ScoreBoard
////
////  Created by Daniel Beilfuss on 12/20/22.
////
//
//import UIKit
//import Firebase
//
//protocol UpdateForRemoteDelegate {
//    func setForRemoteDisplay(set:Bool, userEmail: String?)
//    func disableRemoteTransmitter()
//    func setupRemoteTransmitter(userEmail: String)
//
//}
//
//class RemoteSetupViewController: UIViewController {
//
//    //MARK: - IBOutlets
//
//    /// User Feedback Label
//    @IBOutlet weak var feedbackLabel: UILabel!
//
//    /// Sign In Button
//    @IBOutlet weak var signInButton: UIButton!
//
//    /// Remote Option Containers
//    @IBOutlet weak var stackView: UIStackView!
//    @IBOutlet weak var remoteOptionsView: UIView!
//
//    /// Remote Option Buttons
//    @IBOutlet weak var noRemoteButton: UIButton!
//    @IBOutlet weak var remoteDisplayButton: UIButton!
//    @IBOutlet weak var remoteControlButton: UIButton!
//    @IBOutlet weak var remoteControlV2Button: UIButton!
//    var remoteButtons: [UIButton] {[
//        noRemoteButton!,
//        remoteDisplayButton!,
//        remoteControlButton!,
//        remoteControlV2Button
//    ]}
//
//    var viewsToHideWhenNotSignedIn: [UIView] {[
//        remoteOptionsView,
//        updateButton
//    ]}
//
//    /// Instruction Label
//    @IBOutlet weak var instructionLabel: UILabel!
//
//    /// Bottom Buttons
//    @IBOutlet weak var updateButton: UIButton!
//
//
//    //MARK: - Variables
//
//    /// Delegates
//    var updateUIForRemoteDelegate: UpdateForRemoteDelegate?
//    var scoreBoardDelegate: RemoteControlTransmitterDelegate?
//
//    /// Remote Options
//    var standardDisplay = false
//    var remoteDisplay = false
//    var remoteControl = false
//    var remoteControlv2 = false
//    var remoteOptions: [Bool] {[
//        standardDisplay,
//        remoteDisplay,
//        remoteControl,
//        remoteControlv2
//    ]}
//
//    /// Sign In
//    var userEmail = ""
//    var signInSuccessful = false
//
//
//    //MARK: - ViewWillAppear
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        /// Check for User Sign In State
//        let _ = Auth.auth().addStateDidChangeListener { auth, user in
//            let user = Auth.auth().currentUser
//            if let thisUser = user {
//                self.userEmail = thisUser.email!
//                print(self.userEmail)
//                self.signInSuccessful(true)
//            } else {
//                self.signInReady()
//            }
//        }
//
//        /// Screen Orientation Modifications
//        /// Works by invoking a method added to AppDelegate
//        if UIDevice.current.localizedModel == "iPhone" { ///  Locks Screen Orientation to Portrait for iPhones.
//            AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
//
//        } else if UIDevice.current.localizedModel == "iPad" { ///  Unlocks Screen Orientation for iPads.
//            AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
//        }
//
//
//    }
//
//    /* Deprecated
//    ///  Locks screen orientation to landscape for all devices upon exit.
//    override func viewWillDisappear(_ animated: Bool) {
//            AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscape)
//    }
//    */
//
//
//    //MARK: - ViewDidLoad
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        updateButtonSelectionAndTint()
//
//
//        /*
//         // UI Modifications for iPhone
//         // Deprecated in favor of forcing portrait orientation on iPhone
//         if UIDevice.current.localizedModel == "iPhone" {
//         stackView.axis = NSLayoutConstraint.Axis.horizontal
//         }
//         */
//
//    }
//
//    //MARK: - Update UI Based on Sign in Status
//
//    func signInSuccessful(_ successful: Bool) {
//        print("sign in successful")
//        signInSuccessful = successful
//        updateUIForSuccessfulLogin()
//    }
//
//    func updateUIForSuccessfulLogin() {
//        print("updating UI for successful login")
//
//        for view in viewsToHideWhenNotSignedIn {
//            view.isHidden = false
//        }
//
//        feedbackLabel.text = "✔️ \(userEmail)"
//
//        /// signInButton
//        signInButton.setTitle("Sign Out", for: .normal)
//        signInButton.setImage(UIImage(systemName: "person.crop.circle.fill.badge.minus"), for: .normal)
//        signInButton.tag = 1
//    }
//
//    func signInReady() {
//        print("sign in ready")
//        signInSuccessful = false
//        updateUIForLoginReady()
//    }
//
//    func updateUIForLoginReady() {
//        print("updating UI for Login Ready")
//
//        for view in viewsToHideWhenNotSignedIn {
//            view.isHidden = true
//        }
//
//        feedbackLabel.text = " "
//
//        /// signInButton
//        signInButton.setTitle("Sign In To Use", for: .normal)
//        signInButton.setImage(UIImage(systemName: "person.crop.circle.badge.checkmark"), for: .normal)
//        signInButton.tag = 0
//    }
//
//    //MARK: - Sign In Button
//
//    @IBAction func signInButtonPressed(_ sender: UIButton) {
//        print("sign in button pressed")
//
//        // If not signed in, directs to sign in page
//        if sender.tag == 0 {
//            performSegue(withIdentifier: "SignInSegue", sender: self)
//
//            // If signed in, directs to sign out page
//        } else if sender.tag == 1 {
//            performSegue(withIdentifier: "SignOutSegue", sender: self)
//        }
//    }
//
//
//
//
//    //MARK: - Remote Setup Buttons
//
//    func updateButtonSelectionAndTint() {
//        print("updating remote setup button selection and tint")
//        var place = 0
//        for button in remoteButtons {
//            button.isSelected = remoteOptions[place]
//            place += 1
//
//            if button.isSelected == true {
//                button.tintColor = .tintColor
//            } else {
//                button.tintColor = .gray
//            }
//        }
//    }
//
//    @IBAction func noRemoteButtonPressed(_ sender: UIButton) {
//        print("'no remote' button pressed")
//        standardDisplay = true
//        remoteDisplay = false
//        remoteControl = false
//        remoteControlv2 = false
//        updateButtonSelectionAndTint()
//    }
//
//    @IBAction func remoteDisplayButtonPressed(_ sender: UIButton) {
//        print("remote display button pressed")
//        standardDisplay = false
//        remoteDisplay = true
//        remoteControl = false
//        remoteControlv2 = false
//        updateButtonSelectionAndTint()
//    }
//
//    @IBAction func remoteControlButtonPressed(_ sender: UIButton) {
//        print("remote control button pressed")
//        standardDisplay = false
//        remoteDisplay = false
//        remoteControl = true
//        remoteControlv2 = false
//        updateButtonSelectionAndTint()
//    }
//
//    @IBAction func RemoteControlV2ButtonPressed(_ sender: UIButton) {
//        print("remote control v2 button pressed")
//        standardDisplay = false
//        remoteDisplay = false
//        remoteControl = false
//        remoteControlv2 = true
//        updateButtonSelectionAndTint()
//    }
//
//
//    //MARK: - Bottom Buttons
//
//    @IBAction func updateButton(_ sender: UIButton) {
//        print("update button pressed")
//        if standardDisplay {
//            print("standard mode detected")
//            updateUIForRemoteDelegate?.setForRemoteDisplay(set: false, userEmail: nil)
//            updateUIForRemoteDelegate?.disableRemoteTransmitter()
//            dismiss(animated: true)
//        } else if remoteDisplay {
//            print("remote display mode detected")
//            updateUIForRemoteDelegate?.setForRemoteDisplay(set: true, userEmail: userEmail)
//            updateUIForRemoteDelegate?.setupRemoteTransmitter(userEmail: userEmail)
//            dismiss(animated: true)
//        } else if remoteControl {
//            print("remote control mode detected")
//            performSegue(withIdentifier: "remoteV2Segue", sender: self)
//        } else if remoteControlv2 {
//            print("remote control mode detected")
//            performSegue(withIdentifier: "remoteV2Segue", sender: self)
//        }
//    }
//
//
//    @IBAction func cancelButton(_ sender: UIButton) {
//        print("cancel button pressed")
//        dismiss(animated: true)
//    }
//
//    //MARK: - Prepare for Segue
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("preparing for segue")
//
//        // If not signed in, directs to sign in page
//        if segue.identifier == "SignInSegue" {
////            let destinationVC = segue.destination as! SignInViewController
//            //...
//
//            // If signed in, directs to sign out page
//        } else if segue.identifier == "SignOutSegue" {
//            let destinationVC = segue.destination as! SignOutViewController
//            destinationVC.userEmail = userEmail
//
//            // Remote Control Segue
//        } else if segue.identifier == "RemoteSegue" {
//            let destinationVC = segue.destination as! RemoteViewController
//            destinationVC.modalPresentationStyle = .fullScreen
//            destinationVC.userEmail = userEmail
//            destinationVC.teamManager = TeamManager()
//
//            // Remote Control V2 Segue
//        } else if segue.identifier == "remoteV2Segue" {
//            let destinationVC = segue.destination as! Remotev2ViewController
//            destinationVC.modalPresentationStyle = .fullScreen
//            destinationVC.userEmail = userEmail
//            destinationVC.teamManager = TeamManager()
//        }
//
//    }
//}
