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
        
        let resourceKeys: [URLResourceKey] = [.fileSizeKey, .creationDateKey]
        
        for fileURL in allFiles {
            if fileURL.isFileURL && AppropriateAudioFormatsModel.allExtensions.contains(fileURL.pathExtension) {
                let audioFile: AudioFile
                do {
                    let resourceValues = try fileURL.resourceValues(forKeys: Set(resourceKeys))
                    let byteCount = resourceValues.fileSize ?? 0
                    let creationDate = resourceValues.creationDate
                    let size = ByteCountFormatter.string(fromByteCount: Int64(byteCount), countStyle: .file)
                    let time = timeFromDate(creationDate ?? Date.distantPast)
                    audioFile = AudioFile(url: fileURL, title: fileURL.lastPathComponent, size: size, time: time)
                } catch {
                    print("StorageModel: exception \(error.localizedDescription)")
                    continue
                }
                self.allAudio.append(audioFile)
            } else {
                print("StorageModel: unable to verify \(fileURL)")
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
