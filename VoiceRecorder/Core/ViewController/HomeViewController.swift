//
//  HomeViewController.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 23.02.2023.
//

import UIKit


class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = HomeView(startRecordingClosure: {
            guard let tabBarController = self.tabBarController else { fatalError("No tabBarController provided") }
            tabBarController.selectedIndex = 2
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let view = self.view as? HomeView else { return }
        view.resetButtonSlider()
    }
    
}
