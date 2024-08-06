//
//  RemoteControlView.swift
//  scoreboardWatchPreview Watch App
//
//  Created by Daniel Beilfuss on 8/3/24.
//

import SwiftUI

struct RemoteControlView: View {
    @Binding var teamInfo: Team
    @Binding var incrementValue: Int
    
    var body: some View {
        TabView {
            TeamInfoView(teamInfo: $teamInfo, incrementValue: $incrementValue)
            IncrementView(incrementValue: $incrementValue)
        }
    }
}

#Preview {
    @State var teamInfo = Constants().defaultTeams
    @State var incrementValue: Int = 1
    
    return RemoteControlView(teamInfo: $teamInfo[0], incrementValue: $incrementValue)
}
