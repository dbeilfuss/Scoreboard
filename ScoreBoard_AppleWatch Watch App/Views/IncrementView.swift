//
//  ConfigurationView.swift
//  scoreboardWatchPreview Watch App
//
//  Created by Daniel Beilfuss on 8/3/24.
//

import SwiftUI

struct IncrementView: View {
    //MARK: - Parameters
    @Binding var incrementValue: Int
    @Binding var selectedTab: Int
    
    let values = [1, 5, 10, 100]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    //MARK: - Body
    var body: some View {
        ScrollView {
            ZStack {
                VStack(alignment: .center, spacing: 10) {
                    Text("Points")
                        .font(.headline)
                    
                    /// Increment Selection Options
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach([1, 5, 10, 100], id: \.self) { value in
                            Button(action: {
                                incrementValue = value
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                    withAnimation {
                                        selectedTab = 0
                                    }
                                }
                                
                            }) {
                                Text("\(value)")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(incrementValue == value ? .white : .white)
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(incrementValue == value ? Color.yellow : Color.clear, lineWidth: 4)
                                    .animation(.easeInOut, value: incrementValue)
                            )
                        }
                    }
                    
                    /// "Custom" Increment Button
                    Button(action: {
                        self.incrementValue = 0
                        
                        // Return to Previous Tab
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            withAnimation {
                                selectedTab = 0
                            }
                        }
                        
                    }) {
                        Text("Custom")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(incrementValue == 0 ? Color.yellow : Color.clear, lineWidth: 4)
                            .animation(.easeInOut, value: incrementValue)
                    )
                }
                
            }
        }
        
    }
}

#Preview {
    @State var incrementValue = 5
    @State var selectedTab = 0
    @State var showCustomIncrementTutorial = false
    return IncrementView(incrementValue: $incrementValue, selectedTab: $selectedTab)
}
