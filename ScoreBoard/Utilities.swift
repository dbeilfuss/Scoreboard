//
//  OrientationManager.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 6/22/24.
//

import Foundation
import UIKit

struct Utilities {
    func updateOrientation(to orientation: UIInterfaceOrientationMask) {
        AppDelegate.AppUtility.lockOrientation(to: orientation)
    }
    
    enum DeviceType: String {
        case iPhone
        case iPad
        case unknown
    }
    
    class DeviceInfo {
        var deviceType: DeviceType {
            get {
                if let savedType = UserDefaults.standard.string(forKey: "deviceType") {
                    print("deviceType: \(savedType) - \(#fileID)")
                    return DeviceType(rawValue: savedType) ?? .unknown
                } else {
                    determineDeviceType()
                    return self.deviceType
                }
            }
            set {
                UserDefaults.standard.setValue(newValue.rawValue, forKey: "deviceType")
            }
        }
        
        private func determineDeviceType() {
            let model = UIDevice.current.localizedModel
            if model == "iPhone" {
                deviceType = .iPhone
            } else if model == "iPad" {
                deviceType = .iPad
            } else {
                deviceType = .unknown
            }
            print("deviceType: \(self.deviceType) - \(#fileID)")

        }
        
    }
}
