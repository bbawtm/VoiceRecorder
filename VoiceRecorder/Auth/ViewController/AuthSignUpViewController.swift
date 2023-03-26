//
//  AuthSignUpViewController.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 25.03.2023.
//

import UIKit


class AuthSignUpViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = AuthSignUpView(#selector(gotoLogIn))
    }
    
    @objc public func gotoLogIn() {
        self.view.window?.rootViewController = AuthLogInViewController()
    }
    
}
