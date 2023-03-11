//
//  StorageModel.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 24.02.2023.
//

import UIKit


class StorageModel {
    
    // Audio File type
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
    
    // All stored audio files
    public var allAudio: [AudioFile] = []
    
    // Section title <-> [indices]
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
    
    // Ordered section titles
    private var dateOrderContents: [String]? = nil
    public var dateOrder: [String] {
        if let dateOrderContents {
            return dateOrderContents
        }
        var dates: [String: Date] = [:]
        for el in allAudio {
            let str = dayFromDate(el.date)
            dates[str] = dates[str, default: el.date]
        }
        dateOrderContents = dates.keys.sorted { dates[$0]! > dates[$1]! }
        return dateOrderContents ?? []
    }
    
    public init() {
        validateModel()
    }
    
    public func validateModel() {
        self.allAudio = []
        self.dateOrderContents = nil
        self.dateMapContents = nil
        
        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        print("Document directory: \(documentsDir.absoluteString)")
        let audiosDir = documentsDir.appendingPathComponent(SettingsModel.audiosDirectoryName, conformingTo: .directory)
        let allFiles: [URL]
        do {
            allFiles = try FileManager.default.contentsOfDirectory(at: audiosDir, includingPropertiesForKeys: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        let resourceKeys: [URLResourceKey] = [.fileSizeKey, .creationDateKey]
        
        for fileURL in allFiles {
            if fileURL.isFileURL && AppropriateFormats.allExtensions.contains(fileURL.pathExtension) {
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
                print("StorageModel: unable to verify \(fileURL) with path extension \(fileURL.pathExtension)")
            }
        }
        self.allAudio.sort { $0.date < $1.date }
    }
    
    public func search(withPhrase phrase: String) -> [AudioFile] {
        self.allAudio.filter { $0.title.localizedCaseInsensitiveContains(phrase) }
    }
    
    // MARK: - Private
    
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
