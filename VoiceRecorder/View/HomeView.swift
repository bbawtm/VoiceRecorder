//
//  HomeView.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 23.02.2023.
//

import UIKit


class HomeView: UIView {
    
    // MARK: Properties
    
    private let textPadding: CGFloat = 22
    private let colouredAreaPadding: CGFloat = 16
    private let swiperPadding: CGFloat = 20
    private let actionDeltaLag: CGFloat = 0.07
    
    private let startRecordingClosure: () -> Void
    
    // MARK: - Initializing
    
    public init(startRecordingClosure: @escaping () -> Void) {
        self.startRecordingClosure = startRecordingClosure
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor(named: "appDark")
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(swipeToStartButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: textPadding),
            titleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -textPadding),
            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -18),

            subtitleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: textPadding),
            subtitleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -textPadding),
            subtitleLabel.bottomAnchor.constraint(equalTo: swipeToStartButton.topAnchor, constant: -30),
            
            swipeToStartButton.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: swiperPadding),
            swipeToStartButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -swiperPadding),
            swipeToStartButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -18),
        ])
    }
    
    public override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "Voice recording\nmade simple"
        label.appTitleStyle()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel = {
        let label = UILabel()
        label.text = "Recorder for sound recording with high\nquality. Voice recorder application is free."
        label.appOrdinaryTextStyle()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var swipeToStartButton: UIButton = {
        let swiperSizeValue: CGFloat = 64
        let swiperImageSizeValue: CGFloat = 30
        let swiperPadding: CGFloat = 4
        
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(named: "appDarkest")
        button.layer.cornerRadius = (swiperSizeValue + 2 * swiperPadding) / 2
        button.addTarget(self, action: #selector(startButtonStarted(_:event:)), for: .touchDragInside)
        button.addTarget(self, action: #selector(startButtonEnded(_:)), for: .touchUpInside)
        
        let swipableView = UIImageView.init()
        swipableView.tag = 2924057
        swipableView.backgroundColor = UIColor(named: "appDark")
        swipableView.layer.cornerRadius = swiperSizeValue / 2
        
        let swipableImageView = UIImageView()
        let swipableImageColor = UIColor(named: "appWhite") ?? .white
        swipableImageView.image = UIImage(systemName: "arrow.right")?.withTintColor(swipableImageColor, renderingMode: .alwaysOriginal)
        
        let label = UILabel()
        label.text = "Swipe to start..."
        label.appSecondaryTextStyle()
        
        button.addSubview(label)
        button.addSubview(swipableView)
        swipableView.addSubview(swipableImageView)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        swipableView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        swipableImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            swipableView.heightAnchor.constraint(equalToConstant: swiperSizeValue),
            swipableView.widthAnchor.constraint(equalToConstant: swiperSizeValue),
            swipableView.topAnchor.constraint(equalTo: button.topAnchor, constant: swiperPadding),
            swipableView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -swiperPadding),
            swipableView.leftAnchor.constraint(lessThanOrEqualTo: button.leftAnchor, constant: swiperPadding),
            
            label.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            
            swipableImageView.centerXAnchor.constraint(equalTo: swipableView.centerXAnchor),
            swipableImageView.centerYAnchor.constraint(equalTo: swipableView.centerYAnchor),
            swipableImageView.heightAnchor.constraint(equalToConstant: swiperImageSizeValue),
            swipableImageView.widthAnchor.constraint(equalToConstant: swiperImageSizeValue),
        ])
        
        return button
    }()
    
    // MARK: - Swipe button functions
    
    @objc private func startButtonStarted(_ sender : UIButton, event: UIEvent) {
        let swipableView = sender.viewWithTag(2924057)!
        swipableView.center = location(event: event, subView: swipableView, superView: sender)
    }
    
    @objc private func startButtonEnded(_ sender : UIButton) {
        let swipableView = sender.viewWithTag(2924057)!
        let centerPositionX = swipableView.frame.size.width / 2
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 7, options: .curveEaseInOut, animations: {
            swipableView.center.x = centerPositionX
        }) { _ in}
    }
    
    public func resetButtonSlider() {
        startButtonEnded(swipeToStartButton)
    }
    
    private func location(event: UIEvent, subView: UIView, superView: UIButton) -> CGPoint {
        guard let touch = event.touches(for: superView)?.first else { return CGPoint.zero }
        
        let previousLocation = touch.previousLocation(in: superView)
        let location = touch.location(in: superView)
        let delta_x = location.x - previousLocation.x
        var centerPosition = CGPoint.init(x: subView.center.x + delta_x, y: subView.center.y)
        let minX = subView.frame.size.width / 2
        let maxX = superView.frame.size.width - subView.frame.size.width / 2
        
        centerPosition.x = centerPosition.x < minX ? minX : centerPosition.x
        centerPosition.x = centerPosition.x > maxX ? maxX : centerPosition.x
        
        if maxX - centerPosition.x < maxX * actionDeltaLag { startRecordingClosure() }
        
        return centerPosition
    }
    
}
