//
//  RemoteTeamViewCell.swift
//  scoreboardWatchPreview Watch App
//
//  Created by Daniel Beilfuss on 8/1/24.
//

import SwiftUI

struct TeamInfoView: View {
//MARK: - Parameters
    @Binding var teamInfo: Team
    @Binding var incrementValue: Int
    @State private var showCalculator = false
    @State private var calculationType: calculationType = .addition
    @Binding var selectedTab: Int
    
    var iPhoneConnection: IPhoneConnection
    @ObservedObject var customIncrementTutorial = Constants.shared.tutorialManager.customIncrement
    @ObservedObject var tabViewTutorial = Constants.shared.tutorialManager.tabViewTutorial
    
    //MARK: - View
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                
                // Team Name
                Text(teamInfo.name)
                    .font(.headline)
                    .padding(.bottom, 5)
                
                // Score
                Text("\(teamInfo.score)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
                
                /// Buttons
                HStack(spacing: 20) {
                    
                    // Subtract Points Button
                    Button(action: {
                        self.calculationType = .subtraction
                        calculateNewScore(calculationType: self.calculationType)
                    }) {
                        Image(systemName: "minus.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.red)
                    }
                    
                    // Add Points Button
                    Button(action: {
                        self.calculationType = .addition
                        calculateNewScore(calculationType: self.calculationType)                    }) {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.green)
                    }
                }
            }
            .onAppear {
                /// ** Tutorials Triggers
                
                // Custom Increment Value Tutorial
                if incrementValue == 0 {
                    let _ = customIncrementTutorial.checkAndDisplayTutorial()
                }
                
                // Tab View Tutorial
                if tabViewTutorial.checkAndDisplayTutorial() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            selectedTab = 1
                        }
                        tabViewTutorial.dismissTutorial()
                    }
                }
            }
            
            /// ** Tutorials Views

            // Custom Increment Value Tutorial
            if customIncrementTutorial.displayTutorial {
                ZStack() {
                    Color.black
                        .ignoresSafeArea()
                    VStack {
                        Spacer()
                        Text("""
                         Custom:
                        Tap ➖ or ➕ to enter a custom number of points.
                        """)
                        .multilineTextAlignment(.center)
                        Button(action: {
                            customIncrementTutorial.dismissTutorial()
                        }) {
                            Text("Okay")
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .sheet(isPresented: $showCalculator) {
            CalculatorView(showCalculator: $showCalculator) { value in
                self.incrementValue = value
                calculateNewScore(calculationType: self.calculationType)
                self.incrementValue = 0
            }
        }
        .padding()
        .cornerRadius(10)
    }
    
    //MARK: - Data Types
    enum calculationType {
        case addition
        case subtraction
    }

    //MARK: - Helper Functions
    private func calculateNewScore(calculationType: calculationType) {
        let isCustomScore: Bool = (incrementValue == 0) ? true : false
        
        switch isCustomScore {
        case true:
            // Custom Score
            self.showCalculator = true
            
        case false:
            // Standard Score
            if calculationType == .addition {
                teamInfo.score += incrementValue
            } else {
                teamInfo.score -= incrementValue
            }
            print(teamInfo.score)
            iPhoneConnection.sendTeamsToiPhone(teams: [teamInfo])

        }
        
    }
    
}

#Preview {
    @State var teamInfo = Constants().defaultTeams
    @State var incrementValue = 1
    @State var selectedTab = 0

    @ObservedObject var customIncrementTutorial = TutorialManager().customIncrement
    return TeamInfoView(teamInfo: $teamInfo[0], incrementValue: $incrementValue, selectedTab: $selectedTab, iPhoneConnection: IPhoneConnection(), customIncrementTutorial: customIncrementTutorial)
}
