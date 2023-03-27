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
            print("Log in: \(error?.localizedDescription ?? "nil")")
            setupModel(authResult, error)
        }
    }
    
    public static func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            print("Created: \(error?.localizedDescription ?? "nil")")
            setupModel(authResult, error)
        }
    }
    
    private static func setupModel(_ authResult: AuthDataResult?, _ error: Error?) {
        if let error {
            print("Got error \(error.localizedDescription)")
            return
        }
        guard let authResult else {
            print("((")
            return
        }
        setupModel(authResult.user)
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
