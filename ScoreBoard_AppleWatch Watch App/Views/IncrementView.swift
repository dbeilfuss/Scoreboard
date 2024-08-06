//
//  ConfigurationView.swift
//  scoreboardWatchPreview Watch App
//
//  Created by Daniel Beilfuss on 8/3/24.
//

import SwiftUI

struct IncrementView: View {
    @Binding var incrementValue: Int
    
    let values = [1, 5, 10, 100]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Increment Value")
                .font(.headline)
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach([1, 5, 10, 100], id: \.self) { value in
                    Button(action: {
                        incrementValue = value
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
        }
    }
}

#Preview {
    @State var incrementValue = 5
    return IncrementView(incrementValue: $incrementValue)
}
