//
//  AuthSignUpView.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 26.03.2023.
//

import UIKit


class AuthSignUpView: UIView {
    
    public let topIconView: UIView = {
        let blueColor = UIColor(named: "appBlue") ?? .systemCyan
        let darkColor = UIColor(named: "appDark") ?? .systemGray
        
        let backgroundImageView = UIImageView(image: UIImage(named: "homePageWaves")?.withTintColor(blueColor, renderingMode: .alwaysOriginal))
        backgroundImageView.alpha = 0.8
        
        let logoImageView = UIImageView(image: UIImage(named: "appLogo")?.withTintColor(blueColor, renderingMode: .alwaysOriginal))
        logoImageView.backgroundColor = darkColor
        logoImageView.layer.cornerRadius = 50
        
        let result = UIView()
        result.addSubview(backgroundImageView)
        result.addSubview(logoImageView)
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        result.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundImageView.centerXAnchor.constraint(equalTo: result.centerXAnchor),
            backgroundImageView.centerYAnchor.constraint(equalTo: result.centerYAnchor, constant: 20),
            backgroundImageView.widthAnchor.constraint(equalTo: result.widthAnchor),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 170),
            
            logoImageView.centerXAnchor.constraint(equalTo: result.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: result.centerYAnchor, constant: 20),
            logoImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 80),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
        ])
        
        return result
    }()
    
    public let titleText: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sign Up"
        lbl.appTitleStyle()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    public lazy var usernameField: CustomTextFieldView = {
        let lbl = CustomTextFieldView(
            label: "Username",
            placeholder: "Enter the username",
            contentType: UITextContentType.username
        )
        lbl.setChecker { self.usernameFieldChecker(sender: lbl)}
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    public lazy var passwordField: CustomTextFieldView = {
        let lbl = CustomTextFieldView(
            label: "Password",
            placeholder: "Enter the password",
            contentType: UITextContentType.password
        )
        lbl.setChecker { self.passwordFieldChecker(sender: lbl)}
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    public lazy var secondPasswordField: CustomTextFieldView = {
        let lbl = CustomTextFieldView(
            label: "Confirm password",
            placeholder: "Enter the password again",
            contentType: UITextContentType.password
        )
        lbl.setChecker { self.secondPasswordFieldChecker(sender: lbl)}
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    public let confirmButton: UIButton = {
        let button = UIButton(configuration: UIButton.Configuration.gray())
        button.setTitle("Continue", for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public let gotoLogInButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.setTitle("or Log In", for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public init(_ enterButton: Selector, _ gotoLogIn: Selector) {
        super.init(frame: .zero)
        backgroundColor = UIColor(named: "appDark")
        
        confirmButton.addTarget(nil, action: enterButton, for: .touchUpInside)
        gotoLogInButton.addTarget(nil, action: gotoLogIn, for: .touchUpInside)
        
        addSubview(topIconView)
        addSubview(titleText)
        addSubview(usernameField)
        addSubview(passwordField)
        addSubview(secondPasswordField)
        addSubview(confirmButton)
        addSubview(gotoLogInButton)
        
        NSLayoutConstraint.activate([
            topIconView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 16),
            topIconView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -16),
            topIconView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30),
            
            titleText.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            titleText.topAnchor.constraint(equalTo: topIconView.bottomAnchor, constant: 140),
            
            usernameField.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 16),
            usernameField.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -16),
            usernameField.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 40),
            
            passwordField.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 16),
            passwordField.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -16),
            passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 30),
            
            secondPasswordField.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 16),
            secondPasswordField.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -16),
            secondPasswordField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            
            confirmButton.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 16),
            confirmButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -16),
            confirmButton.topAnchor.constraint(equalTo: secondPasswordField.bottomAnchor, constant: 45),
            confirmButton.heightAnchor.constraint(equalToConstant: 49),
            
            gotoLogInButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            gotoLogInButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func usernameFieldChecker(sender: CustomTextFieldView) {
        let str = sender.getValue()
        if str.count >= 1 && !str.contains(" ") {
            sender.hideError()
        } else {
            sender.showError()
        }
    }
    
    private func passwordFieldChecker(sender: CustomTextFieldView) {
        let str = sender.getValue()
        if str.count >= 5 {
            sender.hideError()
        } else {
            sender.showError()
        }
        secondPasswordFieldChecker(sender: secondPasswordField)
    }
    
    private func secondPasswordFieldChecker(sender: CustomTextFieldView) {
        if sender.getValue() == passwordField.getValue() {
            sender.hideError()
        } else {
            sender.showError()
        }
    }
    
}
