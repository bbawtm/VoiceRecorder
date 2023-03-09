//
//  SettingsModel.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 08.03.2023.
//

import UIKit


protocol InstallationUnitProtocol {
    init()
    var unitKey: String { get }
    var mainTableCell: SettingsModel.MainTableCell { get }
}


class SettingsModel {
    
    // MARK: - Settings
    
    class IdleTimerInstallationUnit: InstallationUnitProtocol {
        
        public let unitKey: String = "settings.isIdleTimerDisabled"
        
        required public init() {
            let defaultsValue = UserDefaults.standard.bool(forKey: unitKey)
            UIApplication.shared.isIdleTimerDisabled = defaultsValue
        }
        
        public lazy var mainTableCell = SettingsModel.MainTableCell(
            name: "Don't allow standby mode",
            sectionNum: 1,
            iconName: "sf.iphone.circle.fill",
            stateValue: UserDefaults.standard.bool(forKey: unitKey),
            action:
                { state in
                    UserDefaults.standard.setValue(state, forKey: self.unitKey)
                    UIApplication.shared.isIdleTimerDisabled = state
                    return nil
                }
        )
        
    }
    
//    public let allInstallationUnits: [InstallationUnitProtocol] = [
//        IdleTimerInstallationUnit()
//    ]
    
    // MARK: - Main table configuration
    
    class MainTableCell {
        public let name: String
        public let sectionNum: Int
        public let iconName: String
        private let action: (Bool) -> UIViewController?
        
        private var currentStateValue: Bool
        public var stateValue: Bool {
            get {
                currentStateValue
            }
        }
        
        init(name: String, sectionNum: Int, iconName: String, stateValue: Bool, action: @escaping (Bool) -> UIViewController?) {
            self.name = name
            self.sectionNum = sectionNum
            self.iconName = iconName
            self.currentStateValue = stateValue
            self.action = action
        }
        
        public func getIcon() -> UIImage? {
            if iconName.hasPrefix("sf.") {
                return UIImage(systemName: iconName.dropFirst(3).description)
            }
            return UIImage(named: iconName)
        }
        
        public func performAction(state: Bool) -> UIViewController? {
            currentStateValue = state
            return action(state)
        }
    }
    
    public let mainTableCells: [MainTableCell] = [
        .init(name: "Microphone adjustment", sectionNum: 0, iconName: "sf.music.mic", stateValue: false, action: { state in
            let alert = UIAlertController(title: "Settings", message: "Pressed 'Microphone adjustment' with state \(state)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            return alert
        }),
        .init(name: "Recording quality", sectionNum: 0, iconName: "sf.recordingtape.circle.fill", stateValue: false, action: { state in
            let alert = UIAlertController(title: "Settings", message: "Pressed 'Recording quality' with state \(state)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            return alert
        }),
        .init(name: "Choose format", sectionNum: 0, iconName: "sf.doc.badge.gearshape.fill", stateValue: false, action: { state in
            let alert = UIAlertController(title: "Settings", message: "Pressed 'Choose format' with state \(state)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            return alert
        }),
        .init(name: "Add outer file", sectionNum: 0, iconName: "sf.tray.and.arrow.down.fill", stateValue: false, action: { state in
            let alert = UIAlertController(title: "Settings", message: "Pressed 'Add outer file' with state \(state)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            return alert
        }),
        
        IdleTimerInstallationUnit().mainTableCell,
        .init(name: "\"Your voice is recording\" phrase", sectionNum: 1, iconName: "sf.ear.fill", stateValue: false, action: { state in
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
