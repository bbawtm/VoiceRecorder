//
//  RecEngineModel.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 24.02.2023.
//

import UIKit
import AVFoundation


class RecEngineModel {
    
    typealias RecorderVCD = AVAudioRecorderDelegate & RecorderDelegate
    typealias PlayerVCD = AVAudioPlayerDelegate & PlayerDelegate
    
    // MARK: State properties
    
    private var audioRecorder: AVAudioRecorder!
    private var audioPlayer : AVAudioPlayer!
    private var meterTimer: Timer!
    private var isAudioRecordingGranted: Bool!
    private var isRecording = false
    private var isPlaying = false
    private var recorderDelegate: (any RecorderVCD)?
    private var playerDelegate: (any PlayerVCD)?
    
    // MARK: - Initializing
    
    init() {
        // Check permissions
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
    
    public func setupRecorderDelegate(_ delegate: any RecorderVCD) {
        recorderDelegate = delegate
    }
    
    public func setupPlayerDelegate(_ delegate: any PlayerVCD) {
        playerDelegate = delegate
    }

    private func getFileUrl(byName filename: String) -> URL {
        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentsDir.appendingPathComponent(filename)
        return filePath
    }
    
    private func displayAlert(title: String, description: String, buttonTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: title, style: .cancel))
        
        let scene = UIApplication.shared.connectedScenes.first
        if let sceneDelegate = (scene?.delegate as? SceneDelegate) {
            sceneDelegate.window?.rootViewController?.present(alert, animated: true)
        }
    }
    
    // MARK: - Recorder
    
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
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = .current
            dateFormatter.timeZone = .current
            dateFormatter.dateFormat = "dd MMM yyyy, HH:mm"
            let audioName = dateFormatter.string(from: Date())
            guard let audioExtension = AppropriateAudioFormatsModel.getFirstExtension(byKey: kAudioFormatMPEG4AAC) else {
                fatalError("Unsupported type format")
            }
            
            audioRecorder = try AVAudioRecorder(
                url: getFileUrl(byName: audioName + "." + audioExtension),
                settings: settings
            )
            audioRecorder.delegate = recorderDelegate
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
        } catch {
            displayAlert(title: "Ошибка", description: error.localizedDescription)
        }
    }
    
    @objc public func startRecording() {
        if isRecording {
            finishAudioRecording(success: true)
            recorderDelegate?.recordingDidEnd()
            isRecording = false
        } else {
            setupRecorder()

            audioRecorder.record()
            meterTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
                self.updateAudioMeter(timer: timer)
            })
            recorderDelegate?.recordingDidStart()
            isRecording = true
        }
    }
    
    @objc private func updateAudioMeter(timer: Timer) {
        guard audioRecorder.isRecording else { return }
        
        let hr = Int((audioRecorder.currentTime / 60) / 60)
        let min = Int(audioRecorder.currentTime / 60)
        let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
        let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
        recorderDelegate?.recordingCurrentTiming(totalTimeString)
        audioRecorder.updateMeters()
    }

    public func finishAudioRecording(success: Bool) {
        guard success else {
            displayAlert(title: "Ошибка", description: "Не удалось записать.")
            return
        }
        
        audioRecorder.stop()
        audioRecorder = nil
        meterTimer.invalidate()
        print("recorded successfully.")
    }
    
    // MARK: - Player
    
    private func preparePlay(file fileURL: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer.delegate = playerDelegate
            audioPlayer.prepareToPlay()
        } catch{
            print(error.localizedDescription)
        }
    }

    @objc public func startPlaying(file fileURL: URL) {
        if isPlaying {
            audioPlayer.stop()
            playerDelegate?.playerDidEnd()
            isPlaying = false
        } else if FileManager.default.fileExists(atPath: fileURL.path) {
            playerDelegate?.playerDidStart()
            preparePlay(file: fileURL)
            audioPlayer.play()
            isPlaying = true
        } else {
            displayAlert(title: "Ошибка", description: "Аудио файл не найден.")
        }
    }
    
}


protocol RecorderDelegate {
    func recordingDidStart()
    func recordingDidEnd()
    func recordingCurrentTiming(_: String)
}

protocol PlayerDelegate {
    func playerDidStart()
    func playerDidEnd()
}
