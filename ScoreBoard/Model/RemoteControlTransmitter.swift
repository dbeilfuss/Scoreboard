//
//  RemoteControlTransmitter.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 12/23/22.
//

import Foundation
import FirebaseFirestore

protocol RemoteControlTransmitterDelegate {
    func userFeedback(feedback: String)
    func transmitData()
    func resetTeams()
    func recordTeamInfo(teamInfo: Team, refreshScreen: Bool)
    func updateTheme(newTheme: String)
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
    
    //MARK: - Error Message
    let errorSending: String = "Error Sending Data"
    let errorReceiving: String = "Error Receiving Data"
    
    //MARK: - Delegate
    var delegate: RemoteControlTransmitterDelegate?
    
    //MARK: - Setup Firestore
    
    let db = Firestore.firestore()
    
    //MARK: - Sending Theme to FireStore
    func transmitTheme(sender: String, themeName: String) {
        print("transmitting Theme")
        
        db.collection(sender).document("Theme").setData([
            typeText: "theme",
            nameText: themeName
        ])
        {
            err in
            if let err = err {
                print("Error transmitting theme")
                print(self.errorSending)
                self.delegate?.userFeedback(feedback: err.localizedDescription)
            } else {
                print("Theme transmitted")
            }
        }
    }

    //MARK: - Sending Scores to FireStore
    func transmitUpdatedScores(sender: String, teamList: [Team]) {
        print("transmitting team data")
        
        var i = 0
        for team in teamList {
            db.collection(sender).document("Team \(i+1)").setData([
                typeText: "team",
                numberText: team.number,
                nameText: team.name,
                scoreText: team.score,
                isActiveText: team.isActive])
            {
                err in
                if let err = err {
                    print("Error adding team \(i + 1): \(err)")
                    print(self.errorSending)
                    self.delegate?.userFeedback(feedback: err.localizedDescription)
                } else {
                    print("Team data updated")
                }
            }
            i += 1
        }
    }
    
    //MARK: - Receiving Data from FireStore
    
    func listenForUpdatedScores (sender: String) {
        print("listening for updated scores")
        
        db.collection(sender)
            .addSnapshotListener { querySnapshot,
                error in
                
                if let e = error {
                    print("issue in getting data from fireStore", e.localizedDescription)
                    self.delegate?.userFeedback(feedback: e.localizedDescription)
                    
                } else {
                    if let snapshotDocs = querySnapshot?.documents {
                        
                        // docsCount: used for determining when to signal refresh of screen
                        var docsCount = snapshotDocs.count - 1
                        
                        for doc in snapshotDocs {
                            if doc[self.typeText] != nil {
                                if doc[self.typeText] as! String == "team" {
                                    let data = doc.data()
                                    if let thisTeamNumber = data[self.numberText] as? Int,
                                       let thisTeamName = data[self.nameText] as? String,
                                       let thisTeamScore = data[self.scoreText] as? Int,
                                       let thisTeamIsActive = data[self.isActiveText] as? Bool
                                    {
                                        let thisTeam = Team(number: thisTeamNumber, name: thisTeamName, score: thisTeamScore, isActive: thisTeamIsActive)
                                        
                                        DispatchQueue.main.async {
                                            self.thisTeam = thisTeam
                                            if let safeThisTeam = self.thisTeam {
                                                var refresh: Bool { docsCount == thisTeamNumber }
                                                self.delegate?.recordTeamInfo(teamInfo: safeThisTeam, refreshScreen: refresh)
                                            }
                                        }
                                    }
                                } else if doc[self.typeText] as! String == "theme" {
                                    self.delegate?.updateTheme(newTheme: doc[self.nameText] as! String)
                                }
                            } else {
                                self.delegate?.transmitData()
                            }
                        }
                    }
                }
            }
    }
}
