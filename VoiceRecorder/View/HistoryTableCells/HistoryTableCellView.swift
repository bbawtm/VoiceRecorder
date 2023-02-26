//
//  HistoryTableCellView.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 24.02.2023.
//

import UIKit


class HistoryTableCellView: UITableViewCell {
    
    private var playPlayingClosure: (() -> Void)?
    private var stopPlayingClosure: (() -> Void)?
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    public func configure(
        forAudioFile file: StorageModel.AudioFile,
        withPlayActionClosure playPlayingClosure: @escaping () -> Void,
        withStopActionClosure stopPlayingClosure: @escaping () -> Void
    ) {
        self.playPlayingClosure = playPlayingClosure
        self.stopPlayingClosure = stopPlayingClosure
        
        backgroundColor = UIColor(named: "appDarkGray")
        selectionStyle = .none
        
        title.text = file.title
        size.text = file.size
        time.text = file.time
        
        playButton.setImage(
            UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium)),
            for: .normal
        )
        playButton.setImage(
            UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium)),
            for: .selected
        )
        playButton.addTarget(nil, action: #selector(buttonWasPressed), for: .touchUpInside)
        
        title.appOrdinaryTextStyle()
        size.appSecondaryTextStyle()
        time.appSecondaryTextStyle()
    }
    
    @objc private func buttonWasPressed() {
        if playButton.isSelected {
            stopPlayingClosure?()
        } else {
            playPlayingClosure?()
        }
    }
    
    public func hasSelectedButton(_ val: Bool) {
        playButton.isSelected = val
    }
    
}
