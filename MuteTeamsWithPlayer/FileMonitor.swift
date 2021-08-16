//
//  FileMonitor.swift
//  MuteTeamsWithPlayer
//
//  Created by Wadim on 16/08/2021.
//

import Foundation

// per https://swiftrocks.com/dispatchsource-detecting-changes-in-files-and-folders-in-swift

final class FileMonitor {

    let url: URL

    let fileHandle: FileHandle
    let source: DispatchSourceFileSystemObject

    weak var delegate: FileMonitorDelegate?

    init(url: URL) throws {
        self.url = url
        self.fileHandle = try FileHandle(forReadingFrom: url)

        source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fileHandle.fileDescriptor,
            eventMask: [
                .extend,
                .delete, .rename],
            queue: DispatchQueue.main
        )

        source.setEventHandler {
            let event = self.source.data
            self.process(event: event)
        }

        source.setCancelHandler {
            try? self.fileHandle.close()
        }

        fileHandle.seekToEndOfFile() // start at the end of current file
        source.resume()
    }

    deinit {
        source.cancel()
    }

    func process(event: DispatchSource.FileSystemEvent) {
        if event.contains(.extend) {
            let newString = String(data: self.fileHandle.availableData, encoding: .utf8)!
            self.delegate?.didReceive(changes: newString)
        }
        if event.contains(.delete) || event.contains(.rename) {
            delegate?.pathDidChange()
        }
    }
}

protocol FileMonitorDelegate: AnyObject {
    /// Process incoming data
    func didReceive(changes: String)
    /// React to file being deleted or renamed
    func pathDidChange()
}
