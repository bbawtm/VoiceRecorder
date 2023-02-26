//
//  SettingsLinkTableCellNib.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 26.02.2023.
//

import UIKit


class SettingsLinkTableCellNib: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    public func configure(withTitle title: String, icon: UIImage) {
        iconImageView.image = icon
        titleLabel.text = title
    }
    
}
