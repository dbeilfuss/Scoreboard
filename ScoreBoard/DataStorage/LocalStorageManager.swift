//
//  LocalConnection.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 7/7/24.
//

import Foundation
import FirebaseFirestore

class LocalStorageManager: DataStorageProtocol {
    
    //MARK: - Properties
    var userDefaultsObserver: NSObjectProtocol?

    //MARK: - Init
    init() {
    }
    
    deinit {
        removeUserDefaultsListener()
    }
    
    //MARK: - Save
    func saveData(_ dataStorageBundle: DataStorageBundle) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(dataStorageBundle)
            UserDefaults.standard.set(data, forKey: "DataStorageBundle")
        } catch {
            print("Error encoding DataStorageBundle: \(error)")
        }
    }
    
    //MARK: - Fetch
    func fetchData(completion: @escaping (DataStorageBundle?) -> Void) {
        let dataStorageBundle = fetchData()
        completion(dataStorageBundle)
    }
    
    func fetchData() -> DataStorageBundle? {
        if let data = UserDefaults.standard.data(forKey: "DataStorageBundle") {
                    let decoder = JSONDecoder()
                    do {
                        let dataBundle = try decoder.decode(DataStorageBundle.self, from: data)
                        return dataBundle
                    } catch {
                        print("Error decoding DataStorageBundle: \(error)")
                        return nil
                    }
                }
                return nil
    }
    
    //MARK: - Listen
    func listenForUpdates(completion: @escaping (DataStorageBundle) -> Void) {
        userDefaultsObserver = NotificationCenter.default.addObserver(
            forName: UserDefaults.didChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            if let dataBundle = self.fetchData() {
                completion(dataBundle)
            }
        }
    }
    
    func removeUserDefaultsListener() {
        if let observer = userDefaultsObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    
}
