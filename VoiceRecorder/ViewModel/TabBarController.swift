//
//  TabBarController.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 23.02.2023.
//

import UIKit


class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: Common settings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        overrideUserInterfaceStyle = .dark  // TODO: remove
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let controllers = [homeVC, searchVC, recordVC, historyVC, settingsVC]
        self.viewControllers = controllers
    }
    
    // MARK: - Items
    
    private let homeVC: UIViewController = {
        let vc = HomeViewController()
        let (ordinary, selected) = configureTabBarImages(systemName: "house.fill")
        vc.tabBarItem = UITabBarItem(title: nil, image: ordinary, selectedImage: selected)
        return vc
    }()
    
    private let searchVC: UIViewController = {
        let vc = SearchViewController()
        let (ordinary, selected) = configureTabBarImages(systemName: "magnifyingglass")
        vc.tabBarItem = UITabBarItem(title: nil, image: ordinary, selectedImage: selected)
        
        let navVC = UINavigationController(rootViewController: vc)
        return navVC
    }()
    
    private let recordVC: UIViewController = {
        let vc = RecordViewController()
        let (ordinary, selected) = configureTabBarImages(systemName: "mic.fill", color: UIColor(named: "appRed") ?? .red)
        vc.tabBarItem = UITabBarItem(title: nil, image: ordinary, selectedImage: selected)
        return vc
    }()
    
    private let historyVC: UIViewController = {
        let vc = HistoryViewController()
        let (ordinary, selected) = configureTabBarImages(systemName: "clock.arrow.circlepath")
        vc.tabBarItem = UITabBarItem(title: nil, image: ordinary, selectedImage: selected)
        return vc
    }()
    
    private let settingsVC: UIViewController = {
        let vc = SettingsViewController()
        let (ordinary, selected) = configureTabBarImages(systemName: "gearshape.fill")
        vc.tabBarItem = UITabBarItem(title: nil, image: ordinary, selectedImage: selected)
        return vc
    }()
    
    // MARK: - Configure images function
    
    private static func configureTabBarImages(systemName: String, color: UIColor? = nil, alpha: CGFloat = 0.75) -> (UIImage?, UIImage?) {
        let sfImage = UIImage(systemName: systemName)
        
        let ordinaryColor = color?.withAlphaComponent(alpha) ?? UIColor(named: "appGray") ?? .white.withAlphaComponent(alpha)
        let ordinaryImage = sfImage?.withTintColor(ordinaryColor, renderingMode: .alwaysOriginal)
        
        let selectedColor = color ?? UIColor(named: "appLight") ?? .white
        let selectedImage = sfImage?.withTintColor(selectedColor, renderingMode: .alwaysOriginal)
        
        return (ordinaryImage, selectedImage)
    }
    
}
