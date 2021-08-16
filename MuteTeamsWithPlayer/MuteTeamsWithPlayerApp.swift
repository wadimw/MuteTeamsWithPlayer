//
//  MuteTeamsWithPlayerApp.swift
//  MuteTeamsWithPlayer
//
//  Created by Wadim on 16/08/2021.
//

import SwiftUI

@main
struct MuteTeamsWithPlayerApp: App {
    /// Reference to app
    static let shared = MuteTeamsWithPlayerApp()
    /// Handler for Now Playing behaviour and intercepting Media Button calls
    let nowPlayable = NowPlayable()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
