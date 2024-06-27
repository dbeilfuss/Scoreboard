//
//  RemoteControlTransmitter.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 12/23/22.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol RemoteDataManagerProtocol {
    // Save Data
    func saveTeams(_: [Team], dataSource: DataSource)
    func saveTheme(named: String, dataSource: DataSource)
    
    // Fetch Data
    func fetchTeams(closure: @escaping ([Team]?) -> Void)
    func fetchTheme(closure: @escaping (String?) -> Void)

    // Listen For Updates
    func listenForUpdates()
}

class RemoteDataManager {
    
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
    var teamManager: TeamManagerProtocol?
    var themeManager: ThemeManagerProtocol?
    var viewController: ScoreBoardViewControllerProtocol?
    
    //MARK: - Setup Firestore
    
    let db = Firestore.firestore()
    
    //MARK: - Init
    init(thisTeam: Team? = nil, teamManager: TeamManagerProtocol?, themeManager: ThemeManagerProtocol?, viewController: ScoreBoardViewControllerProtocol?) {
        self.thisTeam = thisTeam
        self.teamManager = teamManager
        self.themeManager = themeManager
        self.viewController = viewController
        
        listenForUpdates()
    }
    
}

extension RemoteDataManager: RemoteDataManagerProtocol {
    
    //MARK: - Save Data
    
    func saveTeams(_ teamList: [Team], dataSource: DataSource) {
        if dataSource == .local {
            transmitTeamList(teamList: teamList)
        }
        
        func transmitTeamList(teamList: [Team]) {
            
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
                                self.viewController?.userFeedback(feedback: err.localizedDescription)
                            } else {
                                print("Team data transmitted - \(#fileID)")
                            }
                        }
                        i += 1
                    }
                }
        }
    }
    
    func saveTheme(named themeName: String, dataSource: DataSource) {
        if dataSource == .local {
            transmitTheme(themeName: themeName)
        }
    }
    
    //MARK: - Fetch
    
    func fetchTeams(closure: @escaping ([Team]?) -> Void) {
        let teamsCollection = db.collection("teams")
        teamsCollection.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("\(self.errorReceiving): \(error.localizedDescription)")
                closure(nil)
            } else {
                var teams: [Team] = []
                for document in querySnapshot!.documents {
                    if let team = try? document.data(as: Team.self) {
                        teams.append(team)
                    }
                }
                closure(teams)
            }
        }
    }
    
    func fetchTheme(closure: @escaping (String?) -> Void) {
        let themesCollection = db.collection("themes")
        themesCollection.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("\(self.errorReceiving): \(error.localizedDescription)")
                closure(nil)
            } else {
                if let document = querySnapshot?.documents.first, let themeName = document.data()["themeName"] as? String {
                    closure(themeName)
                } else {
                    closure(nil)
                }
            }
        }
    }
    
    private func transmitTheme(themeName: String) {
        
        if constants.printThemeFlow {
            print("transmitting Theme: \(themeName), \(#fileID)")
        }
        
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
                        self.viewController?.userFeedback(feedback: err.localizedDescription)
                    }
                }
            }
    }
    
    //MARK: - Listen for Updates
    
    func listenForUpdates () {
        print("listening for updates - \(#fileID)")
        if let user: User = Auth.auth().currentUser {
            db.collection(user.email!)
                .addSnapshotListener { querySnapshot,
                    error in
                    
                    if let e = error {
                        print("error getting data from fireStore - \(#fileID)", e.localizedDescription)
                        self.viewController?.userFeedback(feedback: e.localizedDescription)
                        
                    } else {
                        if let snapshotDocs = querySnapshot?.documents {
                            
                            print("firebase documents received, \(#fileID)")
                            
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
                                                    self.teamManager?.saveTeam(safeThisTeam, datasource: .cloud)
                                                }
                                            }
                                        }
                                    } else
                                    
                                    // Extract Theme Data
                                    if doc[self.typeText] as! String == "theme" {
                                        let themeName = doc[self.nameText] as! String

                                        if self.constants.printTeamFlow {
                                            print("downloadedThemeData: \(themeName), File: \(#fileID)")
                                        }
                                        
                                        self.themeManager?.saveTheme(named: themeName, dataSource: .cloud)
                                    }
                                    
                                } else {
                                    
                                    // Save First Time Team Data if no Data is Found
                                    if self.teamManager != nil {
                                        self.saveTeams(self.teamManager!.fetchTeamList(), dataSource: .local)
                                    }
                                }
                            }
                        }
                    }
                }
        }
    }
}
