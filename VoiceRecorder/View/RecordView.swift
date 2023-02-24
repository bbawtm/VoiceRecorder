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
    
    // MARK: - Initializing
    
    @objc public init(startRecordingSelector: Selector) {
        self.startRecordingSelector = startRecordingSelector
        super.init(frame: .zero)
        
        backgroundColor = UIColor(named: "appDark")
        
        addSubview(recordingTimeLabel)
        addSubview(recordButton)
        
        NSLayoutConstraint.activate([
            recordingTimeLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            recordButton.topAnchor.constraint(equalTo: recordingTimeLabel.bottomAnchor),
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
        label.text = "0.0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var recordButton = {
        let button = UIButton(type: .infoDark)
        button.setTitle("Record", for: .normal)
        button.setTitle("Stop recording", for: .selected)
        button.addTarget(nil, action: startRecordingSelector, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Public methods
    
    public func startRecording() {
        recordButton.isEnabled = true
        recordButton.isSelected = true
    }
    
    public func stopRecording() {
        recordButton.isEnabled = true
        recordButton.isSelected = false
    }
    
    public func setCurrentTiming(_ currentTime: String) {
        recordingTimeLabel.text = currentTime
    }
    
}

