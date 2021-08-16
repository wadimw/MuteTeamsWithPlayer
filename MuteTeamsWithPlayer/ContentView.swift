//
//  ContentView.swift
//  MuteTeamsWithPlayer
//
//  Created by Wadim on 16/08/2021.
//

import SwiftUI

struct ContentView: View {
    @State var registered = false
    let app = MuteTeamsWithPlayerApp.shared
    
    var body: some View {
        Button(registered ? "Deregister" : "Register") {
            if !registered {
                app.nowPlayable.register()
            } else {
                app.nowPlayable.deregister()
            }
            registered = app.nowPlayable.isRegistered
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
