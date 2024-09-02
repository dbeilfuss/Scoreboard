//
//  CalculatorView.swift
//  ScoreBoard_AppleWatch Watch App
//
//  Created by Daniel Beilfuss on 8/31/24.
//

import Foundation
import SwiftUI

struct CalculatorView: View {
    @State private var enteredValue: Int = 0
    @Binding var showCalculator: Bool
    var onConfirm: (Int) -> Void

    //MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                
                /// Entered Value
                Text(String(enteredValue))
                    .font(.subheadline)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                

                /// Keypad
                let spacing: CGFloat = 7.0
                HStack(spacing: spacing) {
                    let buttonSize = geometry.size.width / 5
                    
                    Spacer()
                    VStack(spacing: spacing) {
                        CalculatorButton(label: "1", action: addDigit, size: buttonSize)
                        CalculatorButton(label: "4", action: addDigit, size: buttonSize)
                        CalculatorButton(label: "7", action: addDigit, size: buttonSize)
                    }
                    VStack(spacing: spacing) {
                        CalculatorButton(label: "2", action: addDigit, size: buttonSize)
                        CalculatorButton(label: "5", action: addDigit, size: buttonSize)
                        CalculatorButton(label: "8", action: addDigit, size: buttonSize)
                    }
                    VStack(spacing: spacing) {
                        CalculatorButton(label: "3", action: addDigit, size: buttonSize)
                        CalculatorButton(label: "6", action: addDigit, size: buttonSize)
                        CalculatorButton(label: "9", action: addDigit, size: buttonSize)
                    }
                    VStack(spacing: spacing) {
                        CalculatorButtonClear(label: "C", action: clearValue, size: buttonSize)
                        CalculatorButtonEnter(label: "✔︎", action: confirmValue, size: buttonSize)
                        CalculatorButton(label: "0", action: addDigit, size: buttonSize)
                    }
                    Spacer()
                }
                

            }
            .padding(.top, 12)
            .edgesIgnoringSafeArea(.top)
        }
    }

    private func addDigit(_ digit: String) {
        if enteredValue / 10000 < 1 { // Limit to 5 digits
            enteredValue = (enteredValue * 10) + Int(digit)!
        }
    }

    private func clearValue() {
        enteredValue = 0
    }

    private func confirmValue() {
        let value = enteredValue
        onConfirm(value)
        showCalculator = false
    }
}

//MARK: - Buttons
struct CalculatorButton: View {
    let label: String
    let action: (String) -> Void
    let size: CGFloat

    var body: some View {
        Button(action: {
            action(label)
        }) {
            Text(label)
                .font(.title2)
                .padding(0)
                .foregroundColor(.white)
        }
        .controlSize(.mini)
        .frame(width: size)
        .frame(height: size)
    }

}

struct CalculatorButtonClear: View {
    let label: String
    let action: () -> Void
    let size: CGFloat

    var body: some View {
        Button(action: {
            action()
        }) {
            Text(label)
                .font(.title2)
                .frame(width: size, height: size)
                .foregroundColor(.orange)
        }
        .controlSize(.mini)
        .frame(width: size)
        .frame(height: size)    }
}

struct CalculatorButtonEnter: View {
    let label: String
    let action: () -> Void
    let size: CGFloat

    var body: some View {
        Button(action: {
            action()
        }) {
            Text(label)
                .font(.title2)
                .frame(width: size, height: size)
                .foregroundColor(.orange)
        }
        .controlSize(.mini)
        .frame(width: size)
        .frame(height: size)    }
}
