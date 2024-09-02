//
//  TutorialManager.swift
//  ScoreBoard_AppleWatch Watch App
//
//  Created by Daniel Beilfuss on 9/2/24.
//

import Foundation
import SwiftUI

class TutorialManager: ObservableObject {
    @Published var increments = TutorialType()
    @Published var customIncrement = TutorialType()
    
    class TutorialType: ObservableObject {
        @Published var hasBeenDisplayed = false
        @Published var displayTutorial = false
    }
}
