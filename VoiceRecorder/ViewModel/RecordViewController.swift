//
//  RecordViewController.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 23.02.2023.
//

import UIKit
import AVFoundation


class RecordViewController: UIViewController, AVAudioRecorderDelegate, RecorderDelegate {
    
    // MARK: Initializing
    
    private let recEngineModel = (UIApplication.shared.delegate as! AppDelegate).recEngineModel
    private let recordView = RecordView(
        startRecordingSelector: #selector(startRecordingFuncCoverage),
        playpauseRecordingSelector: #selector(playpauseRecordingCoverage)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = recordView
        recEngineModel.setupRecorderDelegate(self)
    }
    
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
    }
    
    internal func recordingDidEnd() {
        recordView.stopRecording()
    }
    
    internal func recordingCurrentTiming(_ timing: String) {
        recordView.setCurrentTiming(timing)
    }
    
    internal func recordingDidPauseed() {
        recordView.pauseRecording()
    }
    
    internal func recordingDidContinued() {
        recordView.continueRecording()
    }
    
}
