//
//  SettingsCellViewInterface.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 08.03.2023.
//

import UIKit


protocol SettingsCellViewInterface {
    func configure(withTitle title: String, icon: UIImage?, callback: @escaping (Bool) -> Void)
    func performAction()
}
