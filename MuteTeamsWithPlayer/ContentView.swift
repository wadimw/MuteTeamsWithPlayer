//
//  ContentView.swift
//  MuteTeamsWithPlayer
//
//  Created by Wadim on 16/08/2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var nowPlayable : NowPlayable
    @EnvironmentObject var callStateMonitor : CallStateMonitor
    @Binding var shouldInterceptEvents : Bool
    
    var body: some View {
        VStack {
            Toggle("Intercept media buttons when call is ongoing", isOn: $shouldInterceptEvents)
            .padding()
            Text("Teams log monitored: \(callStateMonitor.isMonitored.description)")
            Text("Call ongoing: \(callStateMonitor.isOngoing.description)")
            Text("Registered as Now Playing: \(nowPlayable.isRegistered.description)")
        }.padding()
    }
}
