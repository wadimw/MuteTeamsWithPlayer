//
//  ActionBridge.swift
//  MuteTeamsWithPlayer
//
//  Created by Wadim on 16/08/2021.
//

import Foundation

class KeypressEmulator : NowPlayableDelegate {
    func didReceiveCommand() {
        toggleMute()
    }
    
    func toggleMute() {
        let script = """
beep
tell application "System Events" to tell process "Teams" to keystroke "m" using {command down, shift down}
"""
        runApplescript(script)
    }
    
    private func runApplescript(_ script: String) {
        // wrap script into activate/reactivate block to ensure events are correctly received
        let wrappedScript = """
set previouslyActiveApplication to (path to frontmost application as text)
tell application \"Microsoft Teams\" to activate
\(script)
tell application previouslyActiveApplication to activate
"""
        var error: NSDictionary?
        guard let scriptObject = NSAppleScript(source: wrappedScript) else { return }
        _ = scriptObject.executeAndReturnError(&error)
        if (error != nil) { print(error!) }
    }
}
