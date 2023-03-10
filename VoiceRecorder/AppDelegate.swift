//
//  AppDelegate.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 23.02.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    // MARK: Application-specified objects
    
    public let storageModel = StorageModel()
    public let recEngineModel = RecEngineModel()
    public let settingsModel = SettingsModel()
    
    private var searchVC: SearchViewController?
    private var historyVC: HistoryViewController?
    private var settingsVC: SettingsViewController?
    
    // Reload all data method
    public func reloadAppData() {
        storageModel.validateModel()
        searchVC?.tableView.reloadData()
        historyVC?.tableView.reloadData()
    }
    
    // Link 'Data' View Controllers
    
    public func linkSearchVC(_ searchVC: SearchViewController) {
        self.searchVC = searchVC
    }
    
    public func linkHistoryVC(_ historyVC: HistoryViewController) {
        self.historyVC = historyVC
    }
    
    public func linkSettingsVC(_ settingsVC: SettingsViewController) {
        self.settingsVC = settingsVC
    }
    
    public func getSettingsVC() -> SettingsViewController? {
        self.settingsVC
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

