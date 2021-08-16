//
//  MuteTeamsWithPlayerApp.swift
//  MuteTeamsWithPlayer
//
//  Created by Wadim on 16/08/2021.
//

import SwiftUI

@main
struct MuteTeamsWithPlayerApp: App {
    static let shared = MuteTeamsWithPlayerApp()
    
    /// Handler for Now Playing behaviour and intercepting Media Button calls
    @ObservedObject var nowPlayable = NowPlayable()
    
    /// Util for monitoring MS Teams log and detecting call state changes
    @ObservedObject var callStateMonitor = CallStateMonitor(
        log: FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appendingPathComponent("Microsoft/Teams/logs.txt")
    )
    
    var keypressEmulator = KeypressEmulator()
    
    /// Indicates if app should register as Now Playing and intercept remote control events when a call is ongoing
    @AppStorage("ShouldInterceptRemoteEvents") var shouldIntercept : Bool = false
    
    init() {
        nowPlayable.delegate = keypressEmulator
        if (shouldIntercept) { callStateMonitor.startMonitoring() }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(shouldInterceptEvents: $shouldIntercept)
                .environmentObject(nowPlayable)
                .environmentObject(callStateMonitor)
                .onChange(of: shouldIntercept) {
                    $0 ? callStateMonitor.startMonitoring() : callStateMonitor.stopMonitoring()
                }
                .onChange(of: callStateMonitor.isOngoing) {
                    $0 ? nowPlayable.register() : nowPlayable.deregister()
                }
        }
    }
}
