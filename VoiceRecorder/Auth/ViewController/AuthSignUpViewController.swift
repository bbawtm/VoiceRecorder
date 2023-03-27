//
//  AuthSignUpViewController.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 25.03.2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class AuthSignUpViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = AuthSignUpView(#selector(enterButtonPressed), #selector(gotoLogIn))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setAuthHandler()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeAuthHandler()
    }
    
    // MARK: - Loading currently log-in'ed used
    
    private var logInHandle: AuthStateDidChangeListenerHandle? = nil
    
    private func setAuthHandler() {
        logInHandle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user {
                UserModel.setupModel(user)
            }
        }
    }
    
    private func removeAuthHandler() {
        if let logInHandle {
            Auth.auth().removeStateDidChangeListener(logInHandle)
        }
    }
    
    // MARK: - Button target actions
    
    @objc public func gotoLogIn() {
        view.window?.rootViewController = AuthLogInViewController()
    }
    
    @objc private func enterButtonPressed() {
        guard let view = view as? AuthSignUpView else {
            fatalError("Wrong view type in SignUp")
        }
        guard view.emailField.isCorrect else {
            showAlert(title: "Error", message: "Email field is incorrect")
            return
        }
        guard view.passwordField.isCorrect else {
            showAlert(title: "Error", message: "Password field is incorrect")
            return
        }
        guard view.secondPasswordField.isCorrect else {
            showAlert(title: "Error", message: "Second password field is incorrect")
            return
        }
        removeAuthHandler()
        UserModel.signUp(email: view.emailField.getValue(), password: view.passwordField.getValue())
    }
    
    // MARK: Alerts
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
    
}
