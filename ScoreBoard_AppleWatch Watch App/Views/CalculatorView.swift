//
//  CalculatorView.swift
//  ScoreBoard_AppleWatch Watch App
//
//  Created by Daniel Beilfuss on 8/31/24.
//

import Foundation
import SwiftUI

struct CalculatorView: View {
    @State private var enteredValue: String = ""
    var onConfirm: (Int) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Enter Point Value")
                .font(.headline)
            
            Text(enteredValue)
                .font(.largeTitle)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    CalculatorButton(label: "1", action: addDigit)
                    CalculatorButton(label: "2", action: addDigit)
                    CalculatorButton(label: "3", action: addDigit)
                }
                HStack(spacing: 10) {
                    CalculatorButton(label: "4", action: addDigit)
                    CalculatorButton(label: "5", action: addDigit)
                    CalculatorButton(label: "6", action: addDigit)
                }
                HStack(spacing: 10) {
                    CalculatorButton(label: "7", action: addDigit)
                    CalculatorButton(label: "8", action: addDigit)
                    CalculatorButton(label: "9", action: addDigit)
                }
                HStack(spacing: 10) {
                    CalculatorButton(label: "0", action: addDigit)
//                    CalculatorButton(label: "C", action: clearValue)
//                    CalculatorButton(label: "✔︎", action: confirmValue)
                }
            }
        }
        .padding()
    }

    private func addDigit(_ digit: String) {
        if enteredValue.count < 5 { // Limit to 5 digits
            enteredValue += digit
        }
    }

    private func clearValue() {
        enteredValue = ""
    }

    private func confirmValue() {
        if let value = Int(enteredValue) {
            onConfirm(value)
        }
    }
}

struct CalculatorButton: View {
    let label: String
    let action: (String) -> Void

    var body: some View {
        Button(action: {
            action(label)
        }) {
            Text(label)
                .font(.title)
                .frame(width: 60, height: 60)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}
