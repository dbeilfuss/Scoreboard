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
    @Environment(\.scenePhase) var scenePhase

    //MARK: - Data Management

    let columns = [
        GridItem(.flexible())
    ]
    
//    var body: some View {
//            Text("Hello, world!")
//                .onChange(of: scenePhase) { oldPhase, newPhase in
//                    if newPhase == .active {
//                        print("Active")
//                    } else if newPhase == .inactive {
//                        print("Inactive")
//                    } else if newPhase == .background {
//                        print("Background")
//                    }
//                }
//        }

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
                    
                    // Loading Screen
                    if connectionMessage != "" {
                        ZStack() {
                            Color.black
                                .ignoresSafeArea()
                            VStack {
                                Spacer()
                                Text(connectionMessage)
                                    .multilineTextAlignment(.center)
                                    .frame(height: 40)
                                ProgressView()
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    
                }
            }
        }
        .onChange(of: scenePhase) {oldPhase, newPhase in
            var printStatement = ""
            
            switch newPhase {
            case .background:
                printStatement = ".background"
            case .inactive:
                printStatement = ".inactive"
            case .active:
                printStatement = ".active"
            @unknown default:
                printStatement = ".unknown default"
            }
            
            print(printStatement)
            
            if newPhase == .active {
                iPhoneConnection.requestTeamDataFromPhone()
            }
            
        }
    }
    
    // User Feedback Message Based on Connection State
    private var connectionMessage: String {
        let reconnectInstructions = "Bring iPhone within range"
        let appInstructions = "Open Scoreboard or Remote"
        switch iPhoneConnection.connectionState {
        case .initializingConnection:
            return """
                    Connecting to iPhone
                    \(appInstructions)
                    """
        case .active:
            return ""
        case .pendingReponse:
            return ""
        case .noResponse:
            return """
                    Reconnecting to iPhone
                    """
        case .critical:
            return """
                    iPhone Connection Lost
                    \(reconnectInstructions)
                    """
        }
    }
    
}


#Preview {
    ContentView()
}
