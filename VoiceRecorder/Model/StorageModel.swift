//
//  StorageModel.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 24.02.2023.
//

import UIKit


class StorageModel {
    
    class AudioFile {
        let url: URL
        let title: String
        let size: String
        let time: String
        
        init(url: URL, title: String, size: String, time: String) {
            self.url = url
            self.title = title
            self.size = size
            self.time = time
        }
    }
    
    public var allAudio: [AudioFile]
    
    public init() {
        self.allAudio = []
        
        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let allFiles: [URL]
        do {
            allFiles = try FileManager.default.contentsOfDirectory(at: documentsDir, includingPropertiesForKeys: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
        for fileURL in allFiles {
            if fileURL.isFileURL && AppropriateAudioFormatsModel.allExtensions.contains(fileURL.pathExtension) {
                let audioFile: AudioFile
                do {
                    let attridutes = try FileManager.default.attributesOfItem(atPath: fileURL.path())
                    let size = ByteCountFormatter.string(fromByteCount: (attridutes[.size] as? Int64) ?? Int64(), countStyle: .file)
                    let time = timeFromDate((attridutes[.creationDate] as? Date) ?? Date.distantPast)
                    audioFile = AudioFile(url: fileURL, title: fileURL.lastPathComponent, size: size, time: time)
                } catch {
                    continue
                }
                self.allAudio.append(audioFile)
            }
        }
    }
    
    private func timeFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.timeZone = .current
        return formatter.string(from: date)
    }
    
}
