//
//  ThemeManager.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 1/21/23.
//

import UIKit

class ThemeManager {
    private let constants = Constants()
    private var databaseManager: DataStorageManagerProtocol?
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
        if let themeName = databaseManager?.loadScoreboardState().themeName {
            let theme = fetchTheme(named: themeName)
            
            themeDataIsRetrieved = true
            activeTheme = theme
        } else {
            print("databaseManager == nil, \(#fileID)")
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
    
    func fetchActiveTheme() -> Theme {
        if !themeDataIsRetrieved {
            fetchThemeFromDataStorage()
        }
        if constants.printThemeFlow {
            print("ActiveTheme: \(activeTheme.name), File: \(#fileID)")
        }
        return activeTheme
    }

    func saveTheme(named themeName: String, dataSource: DataSource) {
        if constants.printThemeFlow {
            print("Saving Theme: \(themeName), File: \(#fileID)")
        }
        databaseManager?.implementTheme(named: themeName, dataSource: .local)
        
        let theme = fetchTheme(named: themeName)
        activeTheme = theme
//        print("Setting ActiveTheme: \(theme.name), File: \(#fileID)")
    }
    
    //MARK: - ScoreboardState
    func loadScoreboardState() -> ScoreboardState? {
        return databaseManager?.loadScoreboardState()
    }
    
}

//MARK: - Extensions

extension ThemeManager: MVCDelegate {
    func initializeMVCs(_ mvcArrangement: MVCArrangement) {
        viewController = mvcArrangement.scoreboardViewController
        databaseManager = mvcArrangement.databaseManager
        
        if viewController == nil || databaseManager == nil {
            print("failed to initializeMVCs: \(#fileID)")
        } else {
            if constants.printThemeFlow {
                print("initializeMVCs successful: \(#fileID)")
            }
        }
    }
}

extension ThemeManager: ThemeManagerProtocol {
    func implementTheme(named themeName: String, dataSource: DataSource) {
        // For use when a new theme has been chosen
        saveTheme(named: themeName, dataSource: dataSource)
        viewController?.refreshUIForTheme()
    }
    
    
    func savePointIncrement(_ pointIncrement: Double) {
        databaseManager?.savePointIncrement(pointIncrement)
    }
    
    func toggleUIIsHidden() {
        databaseManager?.toggleUIIsHidden()
    }
    
    func fetchScoreboardState() -> ScoreboardState {
        if let scoreboardState = databaseManager?.loadScoreboardState() {
            return scoreboardState
        } else {
            print("databaseManager == nil, \(#fileID)")
            return constants.defaultScoreboardState
        }
    }
    
    func refreshData() {
//        print("refreshing theme data, \(#fileID)")
        themeDataIsRetrieved = false
        activeTheme = fetchActiveTheme()
        viewController?.refreshUIForTheme()
    }
    
}
