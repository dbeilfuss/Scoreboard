//
//  RemoteConnection.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 07/07/24.
//

import Foundation
import Firebase

//MARK: - Class
class RemoteStorageManager: DataStorageProtocol {
    

    //MARK: - Setup Firestore
    let db = Firestore.firestore()
    var listener: ListenerRegistration?
    
    //MARK: - Init
    init() {
    }
    
    deinit {
        removeListener()
    }
        
    //MARK: - Save
    func saveData(_ dataBundle: DataStorageBundle) {
        let constants = Constants()
        if constants.printTeamFlow || constants.printThemeFlow { print("saving data - \(#fileID)") }
        if let user: User = Auth.auth().currentUser {
            let bundleRef = db.collection(user.email!).document("dataBundle")
            
            do {
                try bundleRef.setData(from: dataBundle)
            } catch let error {
                print("⛔️ Error writing data bundle to Firestore: \(error)")
            }
        } else {
            print("not signed in - \(#fileID)")
        }
    }
    
    //MARK: - Fetch
    func fetchData(completion: @escaping (DataStorageBundle?) -> Void) {
        let dataStorageBundle = fetchData()
        completion(dataStorageBundle)
    }
    
    func fetchData() -> DataStorageBundle? {
        var dataStorageBundle: DataStorageBundle?
        
        if let user: User = Auth.auth().currentUser {
            let bundleRef = db.collection(user.email!).document("dataBundle")
            
            bundleRef.getDocument { document, error in
                if let document = document, document.exists {
                    do {
                        dataStorageBundle = try document.data(as: DataStorageBundle.self)
                    } catch let error {
                        print("⛔️ Error decoding data bundle: \(error)")
                        dataStorageBundle = nil
                    }
                } else {
                    print("⛔️ Document does not exist")
                }
            }
        }
        
        return dataStorageBundle
    }
    
    //MARK: - Listen
    func listenForUpdates(completion: @escaping (DataStorageBundle) -> Void) {
        if let user: User = Auth.auth().currentUser {
            let bundleRef = db.collection(user.email!).document("dataBundle")
            
            listener = bundleRef.addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("⛔️ Error fetching document: \(error!)")
                    return
                }
                
                do {
                    let dataBundle = try document.data(as: DataStorageBundle.self)
                    completion(dataBundle)
                } catch let error {
                    print("⛔️ Error decoding data bundle: \(error)")
                }
            }
        }
    }
    
    func removeListener() {
        listener?.remove()
    }
    
}
