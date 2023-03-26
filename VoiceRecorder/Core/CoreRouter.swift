//
//  CoreRouter.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 24.03.2023.
//

import UIKit


// MARK: To load Core, the CoreRouter and TabBarController must be loaded.


var coreRouter: CoreRouter? = nil

class CoreRouter {
    
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
    
}

