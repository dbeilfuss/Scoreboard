//
//  TextInputCell.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 2/4/23.
//

import UIKit

protocol textInputDelegate {
    func storeUserData (textField: String, dataEntered: String)
    func editing (currentlyEditing: Bool)
}

class TextInputCell: UITableViewCell, UITextFieldDelegate {

    //MARK: - Imports & Delegates
    let k = Constants()
    var delegate: textInputDelegate?
    
    //MARK: - IBOutlets
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    //MARK: - awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /// Declare Delegates
        textField.delegate = self
        
        /// Fonts
        let deviceType = Utilities.DeviceInfo().deviceType
        if deviceType == .iPhone {
            label.font = k.tableFontiPhoneSmall
            textField.font = k.textFieldIPhone
        } else if deviceType == .iPad {
            label.font = k.tableFontiPadSmall
            textField.font = k.textFieldIPhone
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func textField(_ sender: UITextField) {
        if let dataIdentity = label.text, let dataEntered = sender.text {
            delegate?.storeUserData(textField: dataIdentity, dataEntered: dataEntered)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.editing(currentlyEditing: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.editing(currentlyEditing: false)
    }
    
}
