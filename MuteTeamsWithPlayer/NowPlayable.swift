//
//  NowPlayable.swift
//  MuteTeamsWithPlayer
//
//  Created by Wadim on 16/08/2021.
//

import Foundation
import MediaPlayer
import SwiftUI

class NowPlayable : ObservableObject, CallStateMonitorDelegate {
    private let remoteCommandCenter = MPRemoteCommandCenter.shared()
    private let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
    
    weak var delegate : NowPlayableDelegate?
    
    @Published private(set) var isRegistered = false
    
    // Commands that are not used
    private var disabledCommands : [MPRemoteCommand] { return [
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
    private var enabledCommands : [MPRemoteCommand] { return [
        remoteCommandCenter.pauseCommand,
        remoteCommandCenter.playCommand,
        remoteCommandCenter.stopCommand,
        remoteCommandCenter.togglePlayPauseCommand
    ] }
    
    private let nowPlayingInfo : [String : Any] = [
        MPNowPlayingInfoPropertyIsLiveStream : true,
        MPMediaItemPropertyTitle : "MS Teams Ongoing Call"
    ]
    
    // Make app show in Now Playing menu and register for remote commands
    private func register() {
        guard isRegistered == false else { return }
        // set all unused commands to disabled
        disabledCommands.forEach({$0.isEnabled = false})
        // register handler for all used commands
        enabledCommands.forEach() {
            $0.removeTarget(nil) // remove all targets previously assigned to this command
            $0.addTarget() { return self.handleEvent($0) }
            $0.isEnabled = true
        }
        // Set metadata and state as Now Playing
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
        nowPlayingInfoCenter.playbackState = .playing
        // Save state
        isRegistered = true
    }
    
    private func deregister() {
        guard isRegistered == true else { return }
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
    
    private func handleEvent(_ remoteCommandEvent : MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        self.delegate?.didReceiveCommand()
        return .success
    }
    
    func stateDidChange(_ ongoing: Bool) {
        ongoing ? register() : deregister()
    }
    
}

protocol NowPlayableDelegate : AnyObject {
    func didReceiveCommand()
}
