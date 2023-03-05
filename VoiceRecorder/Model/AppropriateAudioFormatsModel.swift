//
//  AppropriateAudioFormatsModel.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 24.02.2023.
//

import UIKit
import AVFoundation


class AppropriateAudioFormatsModel {
    
    class AudioFormat: CustomStringConvertible {
        let description: String
        let format: AudioFormatID
        let fileExtensions: [String]
        
        init(description: String, format: AudioFormatID, fileExtensions: [String]) {
            self.description = description
            self.format = format
            self.fileExtensions = fileExtensions
        }
    }
    
    public static let formats: [AudioFormat] = [
        .init(description: "Linear PCM", format: kAudioFormatLinearPCM, fileExtensions: ["lpcm"]),
        .init(description: "MPEG 4 AAC", format: kAudioFormatMPEG4AAC, fileExtensions: ["m4a", "aac", "mp4"]),
        .init(description: "MPEG Layer 3", format: kAudioFormatMPEGLayer3, fileExtensions: ["mp3"]),
        .init(description: "Apple Lossless", format: kAudioFormatAppleLossless, fileExtensions: ["m4a", "caf"]),
        .init(description: "Apple IMA4", format: kAudioFormatAppleIMA4, fileExtensions: ["aif", "aiff", "aifc", "caf"]),
        .init(description: "iLBC", format: kAudioFormatiLBC, fileExtensions: ["ilbc"]),
        .init(description: "ULaw", format: kAudioFormatULaw, fileExtensions: ["wav", "aif", "aiff", "aifc", "caf", "snd", "au"])
    ]
    
    public static let allExtensions: [String] = {
        formats.flatMap { $0.fileExtensions }
    }()
    
    public static func getFirstExtension(byKey key: AudioFormatID) -> String? {
        formats.first { $0.format == key }?.fileExtensions.first
    }
    
}
