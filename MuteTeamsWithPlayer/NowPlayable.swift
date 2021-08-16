//
//  NowPlayable.swift
//  MuteTeamsWithPlayer
//
//  Created by Wadim on 16/08/2021.
//

import Foundation
import MediaPlayer

class NowPlayable {
    let remoteCommandCenter = MPRemoteCommandCenter.shared()
    let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
    
    // Commands that are not used
    var disabledCommands : [MPRemoteCommand] { return [
//            remoteCommandCenter.pauseCommand,
//            remoteCommandCenter.playCommand,
//            remoteCommandCenter.stopCommand,
//            remoteCommandCenter.togglePlayPauseCommand,
        remoteCommandCenter.nextTrackCommand,
        remoteCommandCenter.previousTrackCommand,
        remoteCommandCenter.changeRepeatModeCommand,
        remoteCommandCenter.changeShuffleModeCommand,
        remoteCommandCenter.changePlaybackRateCommand,
        remoteCommandCenter.seekBackwardCommand,
        remoteCommandCenter.seekForwardCommand,
        remoteCommandCenter.skipBackwardCommand,
        remoteCommandCenter.skipForwardCommand,
        remoteCommandCenter.changePlaybackPositionCommand,
        remoteCommandCenter.ratingCommand,
        remoteCommandCenter.likeCommand,
        remoteCommandCenter.dislikeCommand,
        remoteCommandCenter.bookmarkCommand,
        remoteCommandCenter.enableLanguageOptionCommand,
        remoteCommandCenter.disableLanguageOptionCommand
    ] }
    
    // Commands that are intercepted
    var enabledCommands : [MPRemoteCommand] { return [
        remoteCommandCenter.pauseCommand,
        remoteCommandCenter.playCommand,
        remoteCommandCenter.stopCommand,
        remoteCommandCenter.togglePlayPauseCommand
    ] }
    
    var isRegistered = false
    
    // Make app show in Now Playing menu and register for remote commands
    func register() {
        guard isRegistered == false else { return }
        
        print("registering now playable")
        // set all unused commands to disabled
        disabledCommands.forEach({$0.isEnabled = false})
        // register handler for all used commands
        enabledCommands.forEach() {
            $0.addTarget() { remoteCommandEvent in
                print("Command received: \(remoteCommandEvent.description)")
                return .success
            }
            $0.isEnabled = true
        }
        // Set metadata and state as Now Playing
        let nowPlayingInfo : [String : Any] = [
            MPNowPlayingInfoPropertyIsLiveStream : true,
            MPMediaItemPropertyTitle : "MS Teams ongoing call"
        ]
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
        nowPlayingInfoCenter.playbackState = .playing
        // Save state
        isRegistered = true
    }
    
    func deregister() {
        guard isRegistered == true else { return }
        
        print("deregistering now playable")
        // deregister all handlers for used commands
        enabledCommands.forEach() {
            $0.removeTarget(nil) // remove all targets
        }
        // clear metadata and state from Now Playing
        nowPlayingInfoCenter.playbackState = .stopped
        nowPlayingInfoCenter.nowPlayingInfo = [:]
        // Save state
        isRegistered = false
    }
    
}
