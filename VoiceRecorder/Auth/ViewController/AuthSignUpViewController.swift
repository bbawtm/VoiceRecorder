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
            } else {
                print("No user found")
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
        guard view.emailField.isCorrect && view.passwordField.isCorrect && view.secondPasswordField.isCorrect else {
            print("Fields error")
            return
        }
        removeAuthHandler()
        UserModel.logIn(email: view.emailField.getValue(), password: view.passwordField.getValue())
    }
    
}
