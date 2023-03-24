//
//  InstallationUnitData.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 09.03.2023.
//

import UIKit
import RealmSwift


// MARK: Realm model for settings

class InstallationUnitData: Object {
    @objc dynamic var key: String = ""
    @objc dynamic var value: Int = -1
}

