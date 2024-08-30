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
                ZStack {
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
                    
                    // ** Loading Screen
                    if connectionMessage != "" {
                        ZStack() {
                            Color.black
                                .ignoresSafeArea()
                            VStack {
                                Spacer()
                                Text(connectionMessage)
                                ProgressView()
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
            }
        }
    }
    
    // User Feedback Message Based on Connection State
    private var connectionMessage: String {
        switch iPhoneConnection.connectionState {
        case .initializingConnection:
            return "Connecting to iPhone"
        case .active:
            return ""
        case .pendingReponse:
            return ""
        case .noResponse:
            return "iPhone Failed to Respond"
        case .critical:
            return "iPhone Connection Lost"
        }
    }
    
}


#Preview {
    ContentView()
}
