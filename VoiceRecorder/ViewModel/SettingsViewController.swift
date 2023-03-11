//
//  SettingsViewController.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 23.02.2023.
//

import UIKit


class SettingsViewController: UITableViewController {
    
    let settingsModel = (UIApplication.shared.delegate as! AppDelegate).settingsModel
    
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
