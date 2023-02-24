//
//  RecordViewController.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 23.02.2023.
//

import UIKit
import AVFoundation


class RecordViewController: UIViewController, AVAudioRecorderDelegate, RecorderDelegate {
    
    private let recEngineModel = (UIApplication.shared.delegate as! AppDelegate).recEngineModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = RecordView(startRecordingSelector: #selector(startRecordingFuncCoverage))
        recEngineModel.setupRecorderDelegate(self)
    }
    
    internal func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        guard let view = self.view as? RecordView else { fatalError("Unknown view type") }
        
        if !flag {
            recEngineModel.finishAudioRecording(success: false)
        }
        view.stopRecording()
    }
    
    @objc private func startRecordingFuncCoverage() {
        recEngineModel.startRecording()
    }
    
    // MARK: - Recorder Delegate
    
    func recordingDidStart() {
        guard let view = self.view as? RecordView else { fatalError("Unknown view type") }
        view.startRecording()
    }
    
    func recordingDidEnd() {
        guard let view = self.view as? RecordView else { fatalError("Unknown view type") }
        view.stopRecording()
    }
    
    func recordingCurrentTiming(_ timing: String) {
        guard let view = self.view as? RecordView else { fatalError("Unknown view type") }
        view.setCurrentTiming(timing)
    }

//    internal func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        guard let view = self.view as? RecordView else { fatalError("Unknown view type") }
//
//        view.waitingForAction()
//    }
    
}
