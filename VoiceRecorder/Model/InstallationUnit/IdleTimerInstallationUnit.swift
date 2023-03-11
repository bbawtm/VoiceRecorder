//
//  IdleTimerInstallationUnit.swift
//  VoiceRecorder
//
//  Created by Вадим Попов on 11.03.2023.
//

import UIKit
import RealmSwift


class IdleTimerInstallationUnit: InstallationUnitProtocol {

    public let unitKey: String = "settings.isIdleTimerDisabled"
    
    public var value: Bool {
        get {
            UIApplication.shared.isIdleTimerDisabled
        }
    }
    
    private lazy var loadedInstallationUnit: InstallationUnitData? = {
        let realm = try! Realm()
        let dataUnits: [InstallationUnitData] = Array(realm.objects(InstallationUnitData.self).where { $0.key == unitKey })
        let count = dataUnits.count
        if count == 0 {
            return nil
        } else if count == 1 {
            return dataUnits[0]
        }
        fatalError("More than 1 unit for one key")
    }()
    
    required public init() {
        if let loadedInstallationUnit {
            let loadedValue = loadedInstallationUnit.value
            UIApplication.shared.isIdleTimerDisabled = loadedValue == 1 ? true : false
        } else {
            let realm = try! Realm()
            try! realm.write {
                let newDataUnit = InstallationUnitData()
                newDataUnit.key = unitKey
                newDataUnit.value = 0
                realm.add(newDataUnit)
                self.loadedInstallationUnit = newDataUnit
            }
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
    
    public lazy var mainTableCell = SettingsModel.MainTableCell(
        name: "Don't allow standby mode",
        sectionNum: 1,
        iconName: "sf.iphone.circle.fill",
        stateValue: UIApplication.shared.isIdleTimerDisabled,
        action:
            { state in
                guard let loadedUnit = self.loadedInstallationUnit else {
                    fatalError("No loaded unit exists")
                }
                let realm = try! Realm()
                try! realm.write {
                    loadedUnit.value = state ? 1 : 0
                }
                UIApplication.shared.isIdleTimerDisabled = state
                return nil
            }
    )
    
}
