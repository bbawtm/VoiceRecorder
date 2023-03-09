//
//  SettingsLinkTableCellView.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 26.02.2023.
//

import UIKit


class SettingsLinkTableCellView: UITableViewCell, SettingsCellViewInterface {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var touchCallback: ((Bool) -> Void)?
    
    public func configure(withTitle title: String, icon: UIImage?, state: Bool, callback: @escaping (Bool) -> Void) {
        backgroundColor = UIColor(named: "appDarkGray")
        selectionStyle = .none
        
        iconImageView.image = icon
        titleLabel.text = title
        
        titleLabel.appOrdinaryTextStyle()
        
        touchCallback = callback
    }
    
    public func performAction() {
        touchCallback?(true)
    }
    
}
