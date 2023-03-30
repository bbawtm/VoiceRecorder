//
//  UserModel.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 25.03.2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class UserModel {
    
    private let fbUser: User
    
    // MARK: Initializing only via LogIn / SignUp
    
    public static func logIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            setupModel(authResult, error)
        }
    }
    
    public static func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            setupModel(authResult, error)
        }
    }
    
    private static func setupModel(_ authResult: AuthDataResult?, _ error: Error?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("No AppDelegate found")
        }
        if let error {
            appDelegate.displayAlert(title: "Error", description: error.localizedDescription)
            return
        }
        guard let authResult else {
            appDelegate.displayAlert(title: "Error", description: "No auth result")
            return
        }
        guard authResult.user.isEmailVerified == true else {
            appDelegate.displayAlert(title: "E-mail verification", description: "Please, check your incoming emails for verification")
            _ = UserModel.signOut()
            return
        }
        setupModel(authResult.user)
    }
    
    public static func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    public static func setupModel(_ user: User) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not found")
        }
        let userModel = UserModel(user)
        appDelegate.runCore(withUser: userModel)
    }
    
    public init() {
        fatalError("UserModel can not be empty")
    }
    
    private init(_ user: User) {
        self.fbUser = user
    }
    
}
