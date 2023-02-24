//
//  RecordViewController.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 23.02.2023.
//

import UIKit
import AVFoundation


class RecordViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    private var audioRecorder: AVAudioRecorder!
    private var audioPlayer : AVAudioPlayer!
    private var meterTimer: Timer!
    private var isAudioRecordingGranted: Bool!
    private var isRecording = false
    private var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = RecordView(startRecordingSelector: #selector(startRecording), playRecordingSelector: #selector(playRecording))
        
        checkRecordPermission()
    }
    
    private func checkRecordPermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSession.RecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { allowed in
                self.isAudioRecordingGranted = allowed
            }
            break
        default:
            break
        }
    }

    private func getFileUrl() -> URL {
        let filename = "myRecording.m4a"
        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentsDir.appendingPathComponent(filename)
        return filePath
    }
    
    private func setupRecorder() {
        guard isAudioRecordingGranted else {
            displayAlert(title: "Ошибка", description: "Нет доступа к микрофону.")
            return
        }
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
            try session.setActive(true)
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
        } catch {
            displayAlert(title: "Ошибка", description: error.localizedDescription)
        }
    }
    
    @objc private func startRecording() {
        guard let view = self.view as? RecordView else { fatalError("Unknown view type") }
        
        if isRecording {
            finishAudioRecording(success: true)
            view.waitingForAction()
            isRecording = false
        } else {
            setupRecorder()

            audioRecorder.record()
            meterTimer = Timer.scheduledTimer(
                timeInterval: 0.1,
                target:self,
                selector: #selector(updateAudioMeter(timer:)),
                userInfo:nil,
                repeats:true
            )
            view.startRecording()
            isRecording = true
        }
    }
    
    @objc private func updateAudioMeter(timer: Timer) {
        guard let view = self.view as? RecordView else { fatalError("Unknown view type") }
        guard audioRecorder.isRecording else { return }
        
        let hr = Int((audioRecorder.currentTime / 60) / 60)
        let min = Int(audioRecorder.currentTime / 60)
        let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
        let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
        view.setCurrentTiming(totalTimeString)
        audioRecorder.updateMeters()
    }

    private func finishAudioRecording(success: Bool) {
        guard success else {
            displayAlert(title: "Ошибка", description: "Не удалось записать.")
            return
        }
        
        audioRecorder.stop()
        audioRecorder = nil
        meterTimer.invalidate()
        print("recorded successfully.")
    }
    
    private func preparePlay() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        } catch{
            print(error.localizedDescription)
        }
    }

    @objc private func playRecording() {
        guard let view = self.view as? RecordView else { fatalError("Unknown view type") }
        
        if isPlaying {
            audioPlayer.stop()
            view.waitingForAction()
            isPlaying = false
        } else if FileManager.default.fileExists(atPath: getFileUrl().path) {
            view.startPlaying()
            preparePlay()
            audioPlayer.play()
            isPlaying = true
        } else {
            displayAlert(title: "Ошибка", description: "Аудио файл не найден.")
        }
    }
    
    internal func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        guard let view = self.view as? RecordView else { fatalError("Unknown view type") }
        
        if !flag {
            finishAudioRecording(success: false)
        }
        view.waitingForAction()
    }

    internal func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        guard let view = self.view as? RecordView else { fatalError("Unknown view type") }
        
        view.waitingForAction()
    }
    
    // MARK: - Displaying alerts
    
    private func displayAlert(title: String, description: String, buttonTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: title, style: .cancel))
        present(alert, animated: true)
    }
    
}
