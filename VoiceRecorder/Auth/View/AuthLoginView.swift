//
//  AuthLoginView.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 26.03.2023.
//

import UIKit


class AuthLoginView: UIView {
    
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
        lbl.text = "Log In"
        lbl.appTitleStyle()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    public let usernameField: CustomTextFieldView = {
        let lbl = CustomTextFieldView(label: "Username", placeholder: "Enter the username", contentType: UITextContentType.username)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    public let passwordField: CustomTextFieldView = {
        let lbl = CustomTextFieldView(label: "Password", placeholder: "Enter the password", contentType: UITextContentType.password)
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
    
    public let gotoSignUpButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.setTitle("or Sign Up", for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public init(_ enterButton: Selector, _ gotoSignUp: Selector) {
        super.init(frame: .zero)
        backgroundColor = UIColor(named: "appDark")
        
        confirmButton.addTarget(nil, action: enterButton, for: .touchUpInside)
        gotoSignUpButton.addTarget(nil, action: gotoSignUp, for: .touchUpInside)
        
        addSubview(topIconView)
        addSubview(titleText)
        addSubview(usernameField)
        addSubview(passwordField)
        addSubview(confirmButton)
        addSubview(gotoSignUpButton)
        
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
                        
            confirmButton.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 16),
            confirmButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -16),
            confirmButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 45),
            confirmButton.heightAnchor.constraint(equalToConstant: 49),
            
            gotoSignUpButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            gotoSignUpButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
