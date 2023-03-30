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
        guard view.emailField.isCorrect else {
            showAlert(title: "Error", message: "Email field is incorrect")
            return
        }
        guard view.passwordField.isCorrect else {
            showAlert(title: "Error", message: "Password field is incorrect")
            return
        }
        UserModel.logIn(email: view.emailField.getValue(), password: view.passwordField.getValue())
    }
    
    // MARK: Alerts
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
    
}
