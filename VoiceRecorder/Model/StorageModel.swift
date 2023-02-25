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
        let date: Date
        let title: String
        let size: String
        let time: String
        
        init(_ url: URL, _ date: Date, _ title: String, _ size: String, _ time: String) {
            self.url = url
            self.date = date
            self.title = title
            self.size = size
            self.time = time
        }
    }
    
    public var allAudio: [AudioFile]
    
    private var dateMapContents: [String: [Int]]? = nil
    public var dateMap: [String: [Int]] {
        if let dateMapContents {
            return dateMapContents
        }
        var res: [String: [Int]] = [:]
        for ind in 0..<allAudio.count {
            let day = dayFromDate(allAudio[ind].date)
            res[day] = res[day, default: []] + [ind]
        }
        dateMapContents = res
        return dateMapContents ?? [:]
    }
    
    private var dateOrderContents: [String]? = nil
    public var dateOrder: [String] {
        if let dateOrderContents {
            return dateOrderContents
        }
        dateOrderContents = dateMap.keys.sorted().reversed()
        return dateOrderContents ?? []
    }
    
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
                    let date = creationDate ?? Date.distantPast
                    let time = timeFromDate(date)
                    audioFile = AudioFile(fileURL, date, fileURL.lastPathComponent, size, time)
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
    
    private func dayFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.timeZone = .current
        return formatter.string(from: date)
    }
    
}
