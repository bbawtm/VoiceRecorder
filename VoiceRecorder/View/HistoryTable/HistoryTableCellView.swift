//
//  HistoryTableCellView.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 24.02.2023.
//

import UIKit


class HistoryTableCellView: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    public func configure(forAudioFile file: StorageModel.AudioFile) {
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
        playButton.isSelected.toggle()
    }
    
}
