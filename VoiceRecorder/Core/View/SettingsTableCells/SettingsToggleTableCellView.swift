//
//  SettingsToggleTableCellView.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 26.02.2023.
//

import UIKit


class SettingsToggleTableCellView: UITableViewCell, SettingsCellViewInterface {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var toggleSwitch: UISwitch!
    
    private var toggleCallback: ((Bool) -> Void)?
    
    public func configure(withTitle title: String, icon: UIImage?, state: Bool, callback: @escaping (Bool) -> Void) {
        backgroundColor = UIColor(named: "appDarkGray")
        selectionStyle = .none
        
        iconImageView.image = icon
        titleLabel.text = title
        
        titleLabel.appOrdinaryTextStyle()
        
        toggleCallback = callback
        toggleSwitch.isOn = state
    }
    
    @IBAction func toggleDidPressed(sender: UISwitch) {
        guard sender === toggleSwitch else {
            fatalError("Unrecognised toggle pressed")
        }
        toggleCallback?(toggleSwitch.isOn)
    }
    
    public func performAction() {
        toggleSwitch.isOn.toggle()
        toggleCallback?(toggleSwitch.isOn)
    }
    
}
