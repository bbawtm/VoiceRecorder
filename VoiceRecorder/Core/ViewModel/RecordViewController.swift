//
//  RecordViewController.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 23.02.2023.
//

import UIKit
import AVFoundation


class RecordViewController: UIViewController {
    
    // MARK: Initializing
    
    private let recEngineModel = coreRouter!.recEngineModel
    private let settingsModel = coreRouter!.settingsModel
    private let recordView = RecordView(
        startRecordingSelector: #selector(startRecordingFuncCoverage),
        playpauseRecordingSelector: #selector(playpauseRecordingCoverage)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = recordView
        recEngineModel.setupRecorderDelegate(self)
    }
    
}

extension RecordViewController: AVAudioRecorderDelegate, RecorderDelegate {
    
    // MARK: - AV Recorder Delegate
    
    internal func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            recEngineModel.finishAudioRecording(success: false)
        }
        recordView.stopRecording()
    }
    
    @objc private func startRecordingFuncCoverage() {
        recEngineModel.startRecording()
    }
    
    @objc private func playpauseRecordingCoverage() {
        recEngineModel.pauseRecording()
    }
    
    // MARK: - Recorder Delegate
    
    internal func recordingDidStart() {
        recordView.startRecording()
        if settingsModel.settings[1].value {
            recEngineModel.startPlaying(file: SettingsModel.recordingInitAudioURL)
        }
    }
    
    internal func recordingDidEnd() {
        recordView.stopRecording()
        recEngineModel.stopPlaying()
    }
    
    internal func recordingCurrentTiming(_ timing: String) {
        recordView.setCurrentTiming(timing)
    }
    
    internal func recordingDidPauseed() {
        recordView.pauseRecording()
        recEngineModel.stopPlaying()
    }
    
    internal func recordingDidContinued() {
        recordView.continueRecording()
    }
    
}

extension RecordViewController: AVAudioPlayerDelegate, PlayerDelegate {
    
    // MARK: - AV Player Delegate
    
    internal func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recEngineModel.stopPlaying()
    }
    
    // MARK: - Player Delegate
    
    internal func playerDidStart() {
        
    }
    
    internal func playerDidEnd() {
        
    }
    
}

