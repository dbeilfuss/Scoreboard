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
}
