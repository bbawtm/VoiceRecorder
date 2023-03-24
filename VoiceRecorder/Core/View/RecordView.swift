//
//  RecordView.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 24.02.2023.
//

import UIKit


class RecordView: UIView {
    
    // MARK: Properties
    
    private let startRecordingSelector: Selector
    private let playpauseRecordingSelector: Selector
    
    // MARK: - Initializing
    
    @objc public init(startRecordingSelector: Selector, playpauseRecordingSelector: Selector) {
        self.startRecordingSelector = startRecordingSelector
        self.playpauseRecordingSelector = playpauseRecordingSelector
        super.init(frame: .zero)
        
        backgroundColor = UIColor(named: "appDark")
        
        addSubview(recordingTimeLabel)
        addSubview(pauseButton)
        addSubview(recordButton)
        
        NSLayoutConstraint.activate([
            recordingTimeLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            recordingTimeLabel.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 16),
            recordingTimeLabel.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -16),
            recordingTimeLabel.heightAnchor.constraint(equalToConstant: 70),
            
            pauseButton.topAnchor.constraint(equalTo: recordingTimeLabel.bottomAnchor, constant: 30),
            pauseButton.heightAnchor.constraint(equalToConstant: 64),
            pauseButton.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 16),
            
            recordButton.topAnchor.constraint(equalTo: recordingTimeLabel.bottomAnchor, constant: 30),
            recordButton.heightAnchor.constraint(equalToConstant: 64),
            recordButton.leftAnchor.constraint(equalTo: pauseButton.rightAnchor, constant: 20),
            recordButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -16),
            recordButton.widthAnchor.constraint(equalTo: pauseButton.widthAnchor, multiplier: 2)
        ])
    }
    
    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    
    private let recordingTimeLabel = {
        let label = UILabel()
        label.text = "00h 00m 00s"
        label.backgroundColor = UIColor(named: "appBlue") ?? .systemCyan
        label.textColor = UIColor(named: "appDarkGray") ?? .systemGray
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 15
        label.font = UIFont.systemFont(ofSize: 35, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var recordButton = {
        let button = UIButton(type: .infoDark)
        let redColor = UIColor(named: "appRed") ?? .systemRed
        button.setImage(
            UIImage(systemName: "record.circle.fill")?.withTintColor(redColor, renderingMode: .alwaysOriginal),
            for: .normal
        )
        button.setImage(
            UIImage(systemName: "stop.fill")?.withTintColor(redColor, renderingMode: .alwaysOriginal),
            for: .selected
        )
        button.addTarget(nil, action: startRecordingSelector, for: .touchUpInside)
        button.layer.borderWidth = 4
        button.layer.borderColor = UIColor(named: "appDarkest")?.cgColor ?? UIColor.systemGray2.cgColor
        button.layer.cornerRadius = 32
        button.backgroundColor = UIColor(named: "appDark")?.withAlphaComponent(0.2) ?? .systemGray2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var pauseButton = {
        let button = UIButton(type: .infoDark)
        let whiteColor = UIColor(named: "appWhite") ?? UIColor.white
        button.setImage(
            UIImage(systemName: "pause.fill")?.withTintColor(whiteColor, renderingMode: .alwaysOriginal),
            for: .normal
        )
        button.setImage(
            UIImage(systemName: "pause.fill")?.withTintColor(whiteColor.withAlphaComponent(0.4), renderingMode: .alwaysOriginal),
            for: .disabled
        )
        button.setImage(
            UIImage(systemName: "playpause.fill")?.withTintColor(whiteColor, renderingMode: .alwaysOriginal),
            for: .selected
        )
        button.addTarget(nil, action: playpauseRecordingSelector, for: .touchUpInside)
        button.layer.borderWidth = 4
        button.layer.borderColor = UIColor(named: "appDarkest")?.cgColor ?? UIColor.systemGray2.cgColor
        button.layer.cornerRadius = 32
        button.backgroundColor = UIColor(named: "appDark")?.withAlphaComponent(0.2) ?? .systemGray2
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Public methods
    
    public func startRecording() {
        recordButton.isEnabled = true
        recordButton.isSelected = true
        pauseButton.isEnabled = true
        pauseButton.isSelected = false
    }
    
    public func stopRecording() {
        recordButton.isEnabled = true
        recordButton.isSelected = false
        pauseButton.isEnabled = false
        pauseButton.isSelected = false
    }
    
    public func setCurrentTiming(_ currentTime: String) {
        recordingTimeLabel.text = currentTime
    }
    
    public func pauseRecording() {
        pauseButton.isSelected = true
    }
    
    public func continueRecording() {
        pauseButton.isSelected = false
    }
    
}

