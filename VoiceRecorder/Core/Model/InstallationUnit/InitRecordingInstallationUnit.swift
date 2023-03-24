//
//  InitRecordingInstallationUnit.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 11.03.2023.
//

import UIKit
import RealmSwift


class InitRecordingInstallationUnit: InstallationUnitProtocol {
    
    public let unitKey: String = "settings.isInitRecordingEnabled"
    
    public var value: Bool {
        get {
            loadedInstallationUnit.value == 1 ? true : false
        }
    }
    
    private lazy var loadedInstallationUnit: InstallationUnitData = {
        let realm = try! Realm()
        let dataUnits: [InstallationUnitData] = Array(realm.objects(InstallationUnitData.self).where { $0.key == unitKey })
        let count = dataUnits.count
        if count == 0 {
            try! realm.write {
                let newDataUnit = InstallationUnitData()
                newDataUnit.key = unitKey
                newDataUnit.value = 0
                realm.add(newDataUnit)
                return newDataUnit
            }
            print("dd")
        } else if count == 1 {
            return dataUnits[0]
        }
        fatalError("More than 1 unit for one key")
    }()
    
    required public init() {}
    
    public lazy var mainTableCell = SettingsModel.MainTableCell(
        name: "Recording warning",
        sectionNum: 1,
        iconName: "sf.ear.fill",
        stateValue: value,
        action:
            { state in
                let realm = try! Realm()
                try! realm.write {
                    self.loadedInstallationUnit.value = state ? 1 : 0
                }
                if state {
                    let alert = UIAlertController(title: "Attention", message: "Make sure that the sound from the speakers will be heard in the microphone.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    return alert
                }
                return nil
            }
    )
}
