//
//  ThemeManager.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/21/23.
//

import UIKit

enum SpecializedTheme {
    case remote
}

class ThemeManager {
    private var constants = Constants()
    private var dataStorageManager: DataStorageManagerProtocol?
    private var viewController: ScoreBoardViewControllerProtocol?
    
    private var themeDataIsRetrieved = false
    private var activeTheme = Constants().defaultTheme
    
    enum dataSource {
        case local
        case cloud
    }
    
    var themeGroupsByName: [String: [Theme]] {[
        "Fractal Landscape": fractalLandscapeThemeSet,
        "Board Games": cardsAndBoardGames,
        "Holidays": holidays
    ]}
    
    var themeGroups: [[Theme]] {[
        fractalLandscapeThemeSet,
        cardsAndBoardGames,
        holidays
    ]}
    
    
    let fractalLandscapeThemeSet: [Theme] = [
        FractalLandscapeBlue1().theme,
        FractalLandscapeBlue2().theme,
        FractalLandscapeBlue3().theme,
        FractalLandscapeBlue4().theme,
        FractalLandscapeFire1().theme,
        FractalLandscapeGreen1().theme,
        FractalLandscapeGreen2().theme,
        FractalLandscapeGreen3().theme,
        FractalLandscapeGreen4().theme,
        FractalLandscapeOcean1().theme,
        FractalLandscapeOcean2().theme,
        FractalLandscapeOcean3().theme,
        FractalLandscapePurple1().theme,
        FractalLandscapePurple2().theme,
        FractalLandscapePurple3().theme,
        FractalLandscapeWhite1().theme,
        FractalLandscapeWhite2().theme
    ]
    
    let cardsAndBoardGames: [Theme] = [
        Railway().theme
    ]
    
    let holidays: [Theme] = [
        ChristmasTheme().theme
    ]
    
    private func fetchThemeFromDataStorage() {
        if constants.printThemeFlow { print("fetching theme from dataStorage, \(#fileID)") }
        
        if let themeName = dataStorageManager?.requestData().themeName {
            
            let theme = fetchTheme(named: themeName)
            
            themeDataIsRetrieved = true
            activeTheme = theme
        } else {
            print("⛔️ databaseManager == nil, \(#fileID)")
        }
    }
    
    func fetchTheme(named themeName: String) -> Theme {
        var themeList: [Theme] = []
        for group in themeGroups {
            themeList = themeList + group
        }
        
        if let themeIndex = themeList.firstIndex(where: { $0.name == themeName }) {
            return themeList[themeIndex]
        } else {
            return constants.defaultTheme
        }
    }


    
    //MARK: - ScoreboardState
    func loadScoreboardState() -> ScoreboardState? {
        return dataStorageManager?.loadScoreboardState()
    }
    
}

//MARK: - Extensions

extension ThemeManager: MVCDelegate {
    func initializeMVCs(_ mvcArrangement: MVCArrangement) {
        viewController = mvcArrangement.scoreboardViewController
        dataStorageManager = mvcArrangement.databaseManager
        
        if viewController == nil || dataStorageManager == nil {
            print("⛔️ failed to initializeMVCs: \(#fileID)")
        }
    }
}

extension ThemeManager: ThemeManagerProtocol {
    
    //MARK: - Themes
    
    func fetchActiveTheme() -> Theme {
        if !themeDataIsRetrieved {
            fetchThemeFromDataStorage()
        }
        if constants.printThemeFlow { print("ActiveTheme: \(activeTheme.name), File: \(#fileID)") }
        return activeTheme
    }
    
    func saveTheme(named themeName: String) {
        if constants.printThemeFlow { print("Saving Theme: \(themeName), File: \(#fileID)") }
        
        dataStorageManager?.saveTheme(named: themeName)
        
        let theme = fetchTheme(named: themeName)
        activeTheme = theme
        
        if constants.printThemeFlow { print("Setting ActiveTheme: \(theme.name), File: \(#fileID)") }
        
        viewController?.refreshUIForTheme()
    }
    
    func fetchSpecializedTheme(ofType themeType: SpecializedTheme) -> Theme {
        var customTheme: Theme
        
        switch themeType {
        case .remote:
            customTheme = RemoteControlTheme().theme
        }
        
        return customTheme
    }

    //MARK: - Scoreboard State
    
    func fetchScoreboardState() -> ScoreboardState {
        if let scoreboardState = dataStorageManager?.loadScoreboardState() {
            return scoreboardState
        } else {
            print("⛔️ databaseManager == nil, \(#fileID)")
            return constants.defaultScoreboardState
        }
    }
    
    func toggleUIIsHidden() {
        dataStorageManager?.toggleUIIsHidden()
    }
    
    func savePointIncrement(_ pointIncrement: Double) {
        dataStorageManager?.savePointIncrement(pointIncrement)
    }
    
}

extension ThemeManager: DataStorageDelegate {
    
    func dataStorageUpdated(_ updatedData: DataStorageBundle) {
        if constants.printThemeFlow { print("refreshing theme data, \(#fileID)") }
        
        themeDataIsRetrieved = false
        let receivedThemeName = updatedData.themeName
        activeTheme = fetchTheme(named: receivedThemeName)
        print(viewController == nil)
        viewController?.refreshUIForTheme()
    }
    
}
