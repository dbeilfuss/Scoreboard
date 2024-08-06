//
//  SignOutViewController.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 12/22/22.
//

import UIKit
#if !os(watchOS)
import Firebase
#endif

class SignOutViewController: UIViewController {
    
    @IBOutlet weak var feedbackLabel: UILabel!
    
    var userEmail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let email = userEmail {
            feedbackLabel.text = "✔️ \(email)"
        }
    }
    
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            dismiss(animated: true)
        } catch let signOutError as NSError {
            feedbackLabel.text = "Error signing out: %@ \(signOutError)"
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
}
