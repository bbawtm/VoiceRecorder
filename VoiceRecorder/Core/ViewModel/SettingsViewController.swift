//
//  SettingsViewController.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 23.02.2023.
//

import UIKit


class SettingsViewController: UITableViewController {
    
    let settingsModel = coreRouter!.settingsModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(named: "appDark")
        
        tableView.register(
            UINib(nibName: "SettingsLinkTableCellNib", bundle: .main),
            forCellReuseIdentifier: "SettingsLinkTableCell"
        )
        tableView.register(
            UINib(nibName: "SettingsToggleTableCellNib", bundle: .main),
            forCellReuseIdentifier: "SettingsToggleTableCell"
        )
        
        coreRouter!.linkSettingsVC(self)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        settingsModel.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingsModel.numberOfRowsInSection(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = settingsModel.getItem(section: indexPath.section, row: indexPath.row)
        let cell: (UITableViewCell & SettingsCellViewInterface)?
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "SettingsLinkTableCell") as? SettingsLinkTableCellView
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "SettingsToggleTableCell") as? SettingsToggleTableCellView
        }
        guard let cell else {
            fatalError("Wrong identifier name")
        }
        cell.configure(
            withTitle: cellModel.name,
            icon: cellModel.getIcon()?.withTintColor(UIColor(named: "appLight") ?? .white, renderingMode: .alwaysOriginal),
            state: cellModel.stateValue
        ) { value in
            if let vc = cellModel.performAction(state: value) {
                self.present(vc, animated: true)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        30
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SettingsCellViewInterface else {
            print("Unable to identify cell")
            return
        }
        cell.performAction()
    }
    
}

extension SettingsViewController: UIDocumentPickerDelegate {
    
    internal func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let loadedCount = AudioPickerInstallationUnit.uploadFiles(urls)
        
        let alertText, alertMessage: String
        if loadedCount == urls.count {
            alertText = "Done"
            alertMessage = "\(loadedCount) audio file(s) were uploaded."
        } else {
            alertText = "Error"
            alertMessage = "\(loadedCount) audio file(s) were not uploaded."
        }
        
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
    
}

