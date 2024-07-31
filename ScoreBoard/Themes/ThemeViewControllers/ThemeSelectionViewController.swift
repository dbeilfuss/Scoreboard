//
//  ThemeSelectionViewController.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/22/23.
//

import UIKit

class ThemeSelectionViewController: UITableViewController {
    
    //MARK: - Variables
    var themeGroup: [Theme]?
    var themeList: [String] = []
    
    var delegate: ThemeManagerProtocol?

    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
                
        /// Create themeList
        if themeGroup != nil {
            for theme in themeGroup! {
                themeList.append(theme.name)
            }
            themeList = themeList.sorted()
        }
        
        print(themeList)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "ThemePreviewCell", bundle: nil), forCellReuseIdentifier: "ReusableThemeCell")
        
    }
    
    //MARK: - Bar Buttons
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    //MARK: - TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        super.tableView(tableView, numberOfRowsInSection: section)
        return themeList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableThemeCell", for: indexPath) as! ThemePreviewCell
        
        /// Lookup Theme Information
        let thisThemeName = themeList[indexPath.row]
        cell.nameLabel.text = thisThemeName
        var thisTheme: Theme?
        if themeGroup != nil {
            for theme in themeGroup! {
                if theme.name == thisThemeName {
                    thisTheme = theme
                }
            }
        }
        
        /// Format Cell for Theme
        cell.backgroundImageView.image = thisTheme?.backgroundImage
        cell.nameLabel.font = thisTheme?.subtitleFont
        cell.nameLabel.font = UIFont(name: cell.nameLabel.font.fontName, size: 35)
        cell.nameLabel.textColor = thisTheme?.subtitleColor
        cell.nameLabel.shadowColor = thisTheme?.shadowColor
        cell.nameLabel.shadowOffset = CGSize(width: (thisTheme?.shadowWidth ?? 0) / 2, height: (thisTheme?.shadowHeight ?? 0) / 2)
        
        /// return cell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var themeSelected: Theme?
        
        if themeGroup != nil {
            for theme in themeGroup! {
                if theme.name == themeList[indexPath.row] {
                    themeSelected = theme
                }
            }
        }
        
        if themeSelected != nil {
            print("ThemeSelected: \(themeSelected!.name), File: \(#fileID)")
            delegate?.saveTheme(named: themeSelected!.name)
            let deviceType = Utilities.DeviceInfo().deviceType
            if deviceType == .iPhone {
                self.dismiss(animated: true)
            }
        }
    }
    
}

//MARK: - Protocols

//protocol ThemeSelectionDelegate {
//    func implementTheme(named themeName: String)
//    func implementTheme(_ theme: Theme)
//}
