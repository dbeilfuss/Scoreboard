//
//  ContentView.swift
//  scoreboardWatchPreview Watch App
//
//  Created by Daniel Beilfuss on 8/1/24.
//

import SwiftUI

struct ContentView: View {
    //MARK: - Properties
    @State var incrementValue: Int = 1
    @StateObject var iPhoneConnection = IPhoneConnection()

    //MARK: - Data Management

    let columns = [
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(iPhoneConnection.teamList.indices, id: \.self) { index in
                        NavigationLink(destination:
                                        RemoteControlView(teamInfo: $iPhoneConnection.teamList[index], incrementValue: $incrementValue, iPhoneConnection: iPhoneConnection)
                        ) {
                            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                                Text(iPhoneConnection.teamList[index].name)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                                Spacer()
                                Text(String(iPhoneConnection.teamList[index].score))
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            
                        }
                        .padding(4)
                    }
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
