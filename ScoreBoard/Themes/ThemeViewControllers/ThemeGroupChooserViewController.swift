//
//  TemplateChooserViewController.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/21/23.
//

import UIKit

class ThemeGroupChooserViewController: UITableViewController {
    
    //MARK: - Variables
    let themeGroups = ThemeManager().themeGroupsByName
    var groupKeys: [String] {
        Array(themeGroups.keys).sorted()
    }
    var groupChosen: String?
    
    var delegate: ThemeManagerProtocol?
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "ThemePreviewCell", bundle: nil), forCellReuseIdentifier: "ReusableThemeCell")
        
    }
    
    //MARK: - Bar Buttons
    
    @IBAction func doneBarButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    //MARK: - TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        super.tableView(tableView, numberOfRowsInSection: section)
        return themeGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableThemeCell", for: indexPath) as! ThemePreviewCell
        
        /// Lookup Theme Information
        let thisThemeName = groupKeys[indexPath.row]
        cell.nameLabel.text = thisThemeName
        var thisTheme: Theme?
        for group in themeGroups {
            if group.key == thisThemeName {
                thisTheme = themeGroups[thisThemeName]?.first
            }
        }
        
        /// Format Cell for Theme
        cell.backgroundImageView.image = thisTheme?.backgroundImage
        cell.nameLabel.font = thisTheme?.subtitleFont
        cell.nameLabel.font = UIFont(name: cell.nameLabel.font.fontName, size: 35)
        cell.nameLabel.textColor = thisTheme?.subtitleColor
        cell.nameLabel.shadowColor = thisTheme?.shadowColor
        cell.nameLabel.shadowOffset = CGSize(width: thisTheme?.shadowWidth ?? 0 / 2, height: thisTheme?.shadowHeight ?? 0 / 2)

        /// return cell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Constants().printThemeFlow { print("user chose theme category \(groupKeys[indexPath.row])") }
        groupChosen = groupKeys[indexPath.row]
        self.performSegue(withIdentifier: "ThemeChooser", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ThemeChooser" {
            let destinationVC = segue.destination as! ThemeSelectionViewController
            destinationVC.delegate = self.delegate
            if groupChosen != nil {
                destinationVC.themeGroup = themeGroups[groupChosen!]
            }
        }
    }
}
