//
//  RemoteTeamViewCell.swift
//  scoreboardWatchPreview Watch App
//
//  Created by Daniel Beilfuss on 8/1/24.
//

import SwiftUI

struct TeamInfoView: View {
    @Binding var teamInfo: Team
    @Binding var incrementValue: Int
    var iPhoneConnection: IPhoneConnection
    
    var body: some View {
        VStack(alignment: .center) {
            Text(teamInfo.name)
                .font(.headline)
                .padding(.bottom, 5)
            
            Text("\(teamInfo.score)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            
            HStack(spacing: 20) {
                Button(action: {
                    teamInfo.score -= incrementValue
                    print(teamInfo.score)
                    iPhoneConnection.sendTeamsToiOS(teams: [teamInfo])
                }) {
                    Image(systemName: "minus.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    teamInfo.score += incrementValue
                    print(teamInfo.score)
                    iPhoneConnection.sendTeamsToiOS(teams: [teamInfo])
                }) {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .cornerRadius(10)
    }
}

#Preview {
    @State var teamInfo = Constants().defaultTeams
    @State var incrementValue = 1
    return TeamInfoView(teamInfo: $teamInfo[0], incrementValue: $incrementValue, iPhoneConnection: IPhoneConnection())
}
