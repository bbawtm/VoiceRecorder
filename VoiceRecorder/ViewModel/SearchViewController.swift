//
//  SearchViewController.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 23.02.2023.
//

import UIKit


class SearchViewController: UITableViewController, UISearchBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "appDark")
        
        searchBar.delegate = self
        tableView.delegate = self
        navigationItem.titleView = searchBar
    }
    
    public let searchBar = {
        let sb = UISearchBar()
        sb.barStyle = .default
        sb.placeholder = " Search..."
        sb.sizeToFit()
        sb.isTranslucent = false
        return sb
    }()
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
}
