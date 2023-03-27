//
//  AuthLogInViewController.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 25.03.2023.
//

import UIKit


class AuthLogInViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = AuthLoginView(#selector(enterButtonPressed), #selector(gotoLogIn))
    }
    
    @objc public func gotoLogIn() {
        view.window?.rootViewController = AuthSignUpViewController()
    }
    
    @objc private func enterButtonPressed() {
        guard let view = view as? AuthLoginView else {
            fatalError("Wrong view type in LogIn")
        }
        UserModel.logIn(email: view.usernameField.getValue(), password: view.passwordField.getValue())
    }
    
}
