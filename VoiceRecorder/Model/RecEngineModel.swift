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
    private var isPausedRecording = false
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
        if recorderDelegate != nil {
            fatalError("There may be just one recorder")
        }
        recorderDelegate = delegate
    }
    
    public func setupPlayerDelegate(_ delegate: any PlayerVCD) {
        if isPlaying {
            stopPlaying()
        }
        playerDelegate = delegate
    }

    private func getFileUrl(byName filename: String) -> URL {
        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentsDir
            .appendingPathComponent(SettingsModel.audiosDirectoryName, conformingTo: .directory)
            .appendingPathComponent(filename)
        return filePath
    }
    
    private func displayAlert(title: String, description: String, buttonTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .cancel))
        
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
            dateFormatter.dateFormat = "dd MMM yyyy, HH:mm:ss"
            let audioName = dateFormatter.string(from: Date())
            guard let audioExtension = AppropriateFormats.getFirstExtension(byKey: kAudioFormatMPEG4AAC) else {
                fatalError("Unsupported type format")
            }
            
            audioRecorder = try AVAudioRecorder(
                url: getFileUrl(byName: audioName + "." + audioExtension),
                settings: settings
            )
            audioRecorder.delegate = recorderDelegate
            audioRecorder.isMeteringEnabled = true
            audioRecorder.updateMeters()
            audioRecorder.prepareToRecord()
        } catch {
            displayAlert(title: "Ошибка", description: error.localizedDescription)
        }
    }
    
    public func startRecording() {
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
    
    private func updateAudioMeter(timer: Timer) {
        guard audioRecorder.isRecording else { return }
        
        let hr = Int((audioRecorder.currentTime / 60) / 60)
        let min = Int(audioRecorder.currentTime / 60)
        let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
        let totalTimeString = String(format: "%02dh %02dm %02ds", hr, min, sec)
        recorderDelegate?.recordingCurrentTiming(totalTimeString)
        audioRecorder.updateMeters()
    }

    public func finishAudioRecording(success: Bool) {
        guard success else {
            displayAlert(title: "Ошибка", description: "Не удалось записать.")
            return
        }
        
        audioRecorder.stop()
        meterTimer.invalidate()
        audioRecorder = nil
        isRecording = false
        
        (UIApplication.shared.delegate as? AppDelegate)?.reloadAppData()
    }
    
    public func pauseRecording() {
        guard isRecording else { return }
        if isPausedRecording {
            isPausedRecording = false
            audioRecorder.record()
            recorderDelegate?.recordingDidContinued()
        } else {
            isPausedRecording = true
            audioRecorder.pause()
            recorderDelegate?.recordingDidPauseed()
        }
    }
    
    // MARK: Merge recording with "Recording Init Audio" (unused)
    
    private func mergeRecordingWithRecInit(forURL recordingURL: URL) async {
        // Recording track
        let recAsset = AVURLAsset(url: recordingURL)
        let recTrack: AVAssetTrack
        let originTimeRange: CMTimeRange
        do {
            recTrack = try await recAsset.loadTracks(withMediaType: .audio)[0]
            originTimeRange = await CMTimeRange(
                start: .zero,
                duration: try recTrack.load(.timeRange).duration
            )
        } catch {
            fatalError(error.localizedDescription)
        }
        
        // Init track
        let initAsset = AVURLAsset(url: SettingsModel.recordingInitAudioURL)
        let initTrack: AVAssetTrack
        do {
            initTrack = try await initAsset.loadTracks(withMediaType: .audio)[0]
        } catch {
            fatalError(error.localizedDescription)
        }
        
        // Make composition
        let composition = AVMutableComposition()
        guard
            let recAVComposition = composition.addMutableTrack(
                withMediaType: .audio,
                preferredTrackID: CMPersistentTrackID()),
            let initAVComposition = composition.addMutableTrack(
                withMediaType: .audio,
                preferredTrackID: CMPersistentTrackID())
        else {
            fatalError("Unable to instantiate AVMutableCompositionTrack")
        }
        do {
            try recAVComposition.insertTimeRange(originTimeRange, of: recTrack, at: .zero)
            try initAVComposition.insertTimeRange(originTimeRange, of: initTrack, at: .zero)
        } catch {
            fatalError(error.localizedDescription)
        }

        // Export
        let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)!
        assetExport.outputFileType = .m4a
        assetExport.outputURL = getFileUrl(byName: recordingURL.lastPathComponent)
        await assetExport.export()
        if let error = assetExport.error {
            print(error.localizedDescription)
        }
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

    public func startPlaying(file fileURL: URL) {
        if isPlaying {
            fatalError("Some player is running")
        }
        if FileManager.default.fileExists(atPath: fileURL.path) {
            playerDelegate?.playerDidStart()
            preparePlay(file: fileURL)
            audioPlayer.play()
            isPlaying = true
        } else {
            displayAlert(title: "Ошибка", description: "Аудио файл не найден.")
        }
    }
    
    public func stopPlaying() {
        guard isPlaying else { return }
        audioPlayer.stop()
        playerDelegate?.playerDidEnd()
        isPlaying = false
    }
    
}


protocol RecorderDelegate {
    func recordingDidStart()
    func recordingDidEnd()
    func recordingCurrentTiming(_: String)
    func recordingDidPauseed()
    func recordingDidContinued()
}

protocol PlayerDelegate {
    func playerDidStart()
    func playerDidEnd()
}
