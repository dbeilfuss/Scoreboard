//
//  KeychainManager.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 6/22/24.
//

import Foundation
import Security


class KeychainManager {
    
    enum KeychainConstants {
        static let appID = "com.BeaconTech.Scoreboard"
        static let usernameAccount = "username"
        static let passwordAccount = "password"
    }
    
    class func save(dataType: signInDataType, data: Data) -> OSStatus {
        
        // Compile Data
        var accountString: String
        
        switch dataType {
        case .username:
            accountString = KeychainConstants.usernameAccount
        case .password:
            accountString = KeychainConstants.passwordAccount
        }
        
        // Create Query
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: KeychainConstants.appID,
                kSecAttrAccount as String: accountString,
                kSecAttrSynchronizable as String: kCFBooleanTrue as Any
            ]
            
            let attributes: [String: Any] = [
                kSecValueData as String: data
            ]
            
            let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
            
            if status == errSecItemNotFound {
                var newItem = query
                newItem[kSecValueData as String] = data
                return SecItemAdd(newItem as CFDictionary, nil)
            }
            
            return status
        }
    
    class func load(dataType: signInDataType) -> Data? {
        
        // Compile Data
        var accountString: String
        
        switch dataType {
        case .username:
            accountString = KeychainConstants.usernameAccount
        case .password:
            accountString = KeychainConstants.passwordAccount
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: KeychainConstants.appID,
            kSecAttrAccount as String: accountString,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecAttrSynchronizable as String: kSecAttrSynchronizableAny
        ]
        var dataTypeRef: AnyObject? = nil
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == noErr {
            return dataTypeRef as? Data
        }
        return nil
    }

    class func delete(_ service: String, account: String) -> OSStatus {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecAttrSynchronizable as String: kCFBooleanTrue as Any
        ]
        return SecItemDelete(query as CFDictionary)
    }
}
