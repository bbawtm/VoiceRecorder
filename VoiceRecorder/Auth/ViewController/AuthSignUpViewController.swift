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
        view = AuthSignUpView(#selector(enterButtonPressed), #selector(gotoLogIn))
    }
    
    @objc public func gotoLogIn() {
        view.window?.rootViewController = AuthLogInViewController()
    }
    
    @objc private func enterButtonPressed() {
        guard let view = view as? AuthSignUpView else {
            fatalError("Wrong view type in SignUp")
        }
    }
    
}
