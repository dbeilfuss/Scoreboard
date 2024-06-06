//
//  WelcomeOptionsCell.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/31/23.
//

import UIKit

class WelcomeOptionsCell: UITableViewCell {
    
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
