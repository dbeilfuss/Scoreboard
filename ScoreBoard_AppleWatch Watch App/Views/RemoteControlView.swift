//
//  RemoteControlView.swift
//  scoreboardWatchPreview Watch App
//
//  Created by Daniel Beilfuss on 8/3/24.
//

import SwiftUI

struct RemoteControlView: View {
    //MARK: - Parameters
    @Binding var teamInfo: Team
    @Binding var incrementValue: Int
    
    @State private var selectedTab = 0
    
    var iPhoneConnection: IPhoneConnection
    
    //MARK: - Body
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                TeamInfoView(teamInfo: $teamInfo, incrementValue: $incrementValue, iPhoneConnection: iPhoneConnection)
                    .tabItem {
                        Label("Team Info", systemImage: "info.circle")
                    }
                    .tag(0)
                IncrementView(incrementValue: $incrementValue, selectedTab: $selectedTab)
                    .tabItem {
                        Label("Increment", systemImage: "plus.circle")
                    }
                    .tag(1)
            }
        }
    }
}

#Preview {
    @State var teamInfo = Constants().defaultTeams
    @State var incrementValue: Int = 1
    @State var showCustomIncrementTutorial: Bool = false

    return RemoteControlView(teamInfo: $teamInfo[0], incrementValue: $incrementValue, iPhoneConnection: IPhoneConnection())
}
