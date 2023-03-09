//
//  SettingsModel.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 08.03.2023.
//

import UIKit


class SettingsModel {
    
    // MARK: Main table configuration
    
    class MainTableCell {
        public let name: String
        public let sectionNum: Int
        public let iconName: String
        private let action: (Bool) -> UIViewController?
        
        init(name: String, sectionNum: Int, iconName: String, action: @escaping (Bool) -> UIViewController?) {
            self.name = name
            self.sectionNum = sectionNum
            self.iconName = iconName
            self.action = action
        }
        
        public func getIcon() -> UIImage? {
            if iconName.hasPrefix("sf.") {
                return UIImage(systemName: iconName.dropFirst(3).description)
            }
            return UIImage(named: iconName)
        }
        
        public func performAction(state: Bool) -> UIViewController? {
            action(state)
        }
    }
    
    public let mainTableCells: [MainTableCell] = [
        .init(name: "Microphone adjustment", sectionNum: 0, iconName: "sf.music.mic", action: { state in
            let alert = UIAlertController(title: "Settings", message: "Pressed 'Microphone adjustment' with state \(state)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            return alert
        }),
        .init(name: "Recording quality", sectionNum: 0, iconName: "sf.recordingtape.circle.fill", action: { state in
            let alert = UIAlertController(title: "Settings", message: "Pressed 'Recording quality' with state \(state)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            return alert
        }),
        .init(name: "Choose format", sectionNum: 0, iconName: "sf.doc.badge.gearshape.fill", action: { state in
            let alert = UIAlertController(title: "Settings", message: "Pressed 'Choose format' with state \(state)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            return alert
        }),
        .init(name: "Add outer file", sectionNum: 0, iconName: "sf.tray.and.arrow.down.fill", action: { state in
            let alert = UIAlertController(title: "Settings", message: "Pressed 'Add outer file' with state \(state)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            return alert
        }),
        
        .init(name: "Don't allow standby mode", sectionNum: 1, iconName: "sf.iphone.circle.fill", action: { state in
            let alert = UIAlertController(title: "Settings", message: "Pressed 'Don't allow standby mode' with state \(state)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            return alert
        }),
        .init(name: "\"Your voice is recording\" phrase", sectionNum: 1, iconName: "sf.ear.fill", action: { state in
            let alert = UIAlertController(title: "Settings", message: "Pressed '\"Your voice is recording\" phrase' with state \(state)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            return alert
        }),
    ]
    
    public func numberOfSections() -> Int {
        Set(mainTableCells.map { $0.sectionNum }).count
    }
    
    public func numberOfRowsInSection(_ section: Int) -> Int {
        mainTableCells.filter { $0.sectionNum == section }.count
    }
    
    public func getItem(section: Int, row: Int) -> MainTableCell {
        mainTableCells.filter { $0.sectionNum == section } [row]
    }
    
}
