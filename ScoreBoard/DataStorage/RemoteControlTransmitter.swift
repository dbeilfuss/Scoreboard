//
//  RemoteControlTransmitter.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 12/23/22.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol CloudDataStorageManagerProtocol {
//    func initialize(teamManager: TeamManagerProtocol,themeManager: ThemeManagerProtocol)
    func saveTeams(_: [Team], dataSource: DataSource)
    func saveTheme(named: String)
    func listenForUpdates()
}

class RemoteControlTransmitter {
    
    //MARK: - Variables
    var thisTeam: Team?
    
    //MARK: - Constants
    let typeText = "type"
    let numberText = "number"
    let nameText = "name"
    let scoreText = "score"
    let isActiveText = "isActive"
    
    let constants = Constants()
    
    //MARK: - Error Message
    let errorSending: String = "Error Sending Data"
    let errorReceiving: String = "Error Receiving Data"
    
    //MARK: - Delegate
    var teamManager: TeamManagerProtocol
    var themeManager: ThemeManagerProtocol
    var viewController: ScoreBoardViewControllerProtocol
    
    //MARK: - Setup Firestore
    
    let db = Firestore.firestore()
    
    //MARK: - Init
    init(thisTeam: Team? = nil, teamManager: TeamManagerProtocol, themeManager: ThemeManagerProtocol, viewController: ScoreBoardViewControllerProtocol) {
        self.thisTeam = thisTeam
        self.teamManager = teamManager
        self.themeManager = themeManager
        self.viewController = viewController
        
        listenForUpdates()
    }
    
    //MARK: - Sending Theme to FireStore
    private func transmitTheme(themeName: String) {
        
            if let user: User = Auth.auth().currentUser {
                
                self.db.collection(user.email!).document("Theme").setData([
                    self.typeText: "theme",
                    self.nameText: themeName
                ])
                {
                    err in
                    if let err = err {
                        print("Error transmitting theme - \(#fileID)")
                        print(self.errorSending)
                        self.viewController.userFeedback(feedback: err.localizedDescription)
                    } else {
                        print("transmitting Theme - \(#fileID)")
                    }
                }
            }
    }

    //MARK: - Sending Scores to FireStore
        func transmitUpdatedScores(teamList: [Team]) {
            
            var i = 0
                
            if let user: User = Auth.auth().currentUser {
                    for team in teamList {
                        self.db.collection(user.email!).document("Team \(i+1)").setData([
                            self.typeText: "team",
                            self.numberText: team.number,
                            self.nameText: team.name,
                            self.scoreText: team.score,
                            self.isActiveText: team.isActive])
                        {
                            err in
                            if let err = err {
                                print("Error transmitting team \(i + 1): \(err) - \(#fileID)")
                                print(self.errorSending)
                                self.viewController.userFeedback(feedback: err.localizedDescription)
                            } else {
                                print("Team data transmitted - \(#fileID)")
                            }
                        }
                        i += 1
                    }
                }
        }
    
    //MARK: - Receiving Data from FireStore
    
    func listenForUpdates () {
        print("listening for updates - \(#fileID)")
        if let user: User = Auth.auth().currentUser {
            db.collection(user.email!)
                .addSnapshotListener { querySnapshot,
                    error in
                    
                    if let e = error {
                        print("error getting data from fireStore - \(#fileID)", e.localizedDescription)
                        self.viewController.userFeedback(feedback: e.localizedDescription)
                        
                    } else {
                        if let snapshotDocs = querySnapshot?.documents {
                            
                            // docsCount: used for determining when to signal refresh of screen
                            let docsCount = snapshotDocs.count - 1
                            
                            for doc in snapshotDocs {
                                if doc[self.typeText] != nil {
                                    if doc[self.typeText] as! String == "team" {
                                        let data = doc.data()
                                        
                                        // Deconstruct Team Data from Firebase
                                        if let thisTeamNumber = data[self.numberText] as? Int,
                                           let thisTeamName = data[self.nameText] as? String,
                                           let thisTeamScore = data[self.scoreText] as? Int,
                                           let thisTeamIsActive = data[self.isActiveText] as? Bool
                                        {
                                            
                                            // Construct Team Data for Local Database
                                            let thisTeam = Team(number: thisTeamNumber, name: thisTeamName, score: thisTeamScore, isActive: thisTeamIsActive)
                                            
                                            if self.constants.printTeamFlow {
                                                print("downloadedTeamData: \(thisTeam), \(#fileID)")
                                            }
                                            
                                            DispatchQueue.main.async {
                                                self.thisTeam = thisTeam
                                                if let safeThisTeam = self.thisTeam {
                                                    var refresh: Bool { docsCount == thisTeamNumber }
                                                    self.teamManager.saveTeam(safeThisTeam, datasource: .cloud)
                                                }
                                            }
                                        }
                                        
                                        // Extract Theme Data
                                    } else if doc[self.typeText] as! String == "theme" {
                                        let themeName = doc[self.nameText] as! String
                                        print("Theme Received: \(themeName), File: \(#fileID)")
                                        self.themeManager.implementTheme(named: themeName, dataSource: .cloud)
                                    }
                                } else {
                                    self.saveTeams(self.teamManager.fetchTeamList(), dataSource: .local)
                                }
                            }
                        }
                    }
                }
        }
    }
}

extension RemoteControlTransmitter: CloudDataStorageManagerProtocol {
//    func initialize(teamManager: TeamManagerProtocol, themeManager: ThemeManagerProtocol) {
//        self.teamManager = teamManager
//        self.themeManager = themeManager
//        listenForUpdates()
//    }
    
    func saveTeams(_ teamList: [Team], dataSource: DataSource) {
        print("dataSource: \(dataSource)")
        if dataSource == .local {
            transmitUpdatedScores(teamList: teamList)
        }
    }
    
    func saveTheme(named themeName: String) {
        transmitTheme(themeName: themeName)
    }
    
    
}
