//
//  ActionBridge.swift
//  MuteTeamsWithPlayer
//
//  Created by Wadim on 16/08/2021.
//

import Foundation

class KeypressEmulator : NowPlayableDelegate {
    func sendKeypress() {
        
    }
    
    func didReceiveEvent() {
        sendKeypress()
    }
}
