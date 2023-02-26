//
//  SettingsViewController.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 23.02.2023.
//

import UIKit


class SettingsViewController: UITableViewController {
    
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
    
}
