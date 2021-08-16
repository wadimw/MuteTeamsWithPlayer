//
//  CallMonitor.swift
//  MuteTeamsWithPlayer
//
//  Created by Wadim on 16/08/2021.
//

import Foundation

final class CallStateMonitor : ObservableObject, FileMonitorDelegate {
    private var fileMonitor : FileMonitor?
    let logUrl : URL
    
    @Published private(set) var isMonitored = false
    @Published private(set) var isOngoing = false
    
    init(log logUrl : URL) {
        self.logUrl = logUrl
    }
    
    func startMonitoring() {
        if isMonitored { return }
        do {
            fileMonitor = try FileMonitor(url: logUrl)
        } catch {
            print(CallStateMonitorError.fileMonitorError(error))
            return
        }
        fileMonitor?.delegate = self
        isMonitored = true
    }
    
    func stopMonitoring() {
        if !isMonitored { return }
        self.fileMonitor = nil
        isMonitored = false
    }
    
    func didReceive(changes: String) {
        // if parsing fails, state is left as is
        try? parseLastCallState(from: changes)
    }
    
    /// Searching from the end of provided log chunk, look for last occurrence`isOngoing: true/false` strings which indicates call state change
    func parseLastCallState(from log: String) throws {
        let latestStateChange = log.range(of: "isOngoing: ", options: .backwards)
        guard let stateChangeIndex = latestStateChange?.upperBound else {
            // no changes in current log chunk
            return
        }
        let subChunk = log[stateChangeIndex ..< log.index(stateChangeIndex, offsetBy:5)]
        if (subChunk.starts(with: "true")) { isOngoing = true }
        else if (subChunk.starts(with: "false")) { isOngoing = false }
        else {
            print(CallStateMonitorError.unknownCallState(String(subChunk)))
        }
    }
    
    func pathDidChange() {
        // go back to monitoring original log path
        stopMonitoring()
        startMonitoring()
    }
}

enum CallStateMonitorError : LocalizedError {
    case unknownCallState(String)
    case fileMonitorError(Error)
    
    var errorDescription: String? {
        switch self {
        case .unknownCallState(let newState):
            return "New call state unknown: \(newState)"
        case .fileMonitorError(let innerError):
            return "Error initializing file monitoring: \(innerError)"
        }
    }
}
