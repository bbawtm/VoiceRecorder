//
//  AuthNavViewController.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 26.03.2023.
//

import UIKit


class AuthNavViewController: UINavigationController {
    
    public init() {
        super.init(rootViewController: AuthSignUpViewController())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
