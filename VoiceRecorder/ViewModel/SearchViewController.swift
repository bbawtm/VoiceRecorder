//
//  SearchViewController.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 23.02.2023.
//

import UIKit
import AVFoundation


class SearchViewController: UITableViewController, UISearchBarDelegate, PlayerDelegate, AVAudioPlayerDelegate {
    
    private let storageModel = (UIApplication.shared.delegate as! AppDelegate).storageModel
    private let recEngineModel = (UIApplication.shared.delegate as! AppDelegate).recEngineModel
    
    private var currentManagingFiles: [StorageModel.AudioFile] = []
    private weak var currentPlayingCell: EachTableCellView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (UIApplication.shared.delegate as? AppDelegate)?.linkSearchVC(self)
        
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        self.view.addSubview(nothingToShowLabel)
        hideKeyboardWhenTappedAround()
                
        tableView.backgroundColor = UIColor(named: "appDark")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "EachTableCellNib", bundle: .main), forCellReuseIdentifier: "SearchTableCell")
        
        NSLayoutConstraint.activate([
            nothingToShowLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            nothingToShowLabel.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recEngineModel.setupPlayerDelegate(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        recEngineModel.stopPlaying()
        currentPlayingCell = nil
    }
    
    private let searchBar = {
        let sb = UISearchBar()
        sb.barStyle = .default
        sb.placeholder = " Search..."
        sb.sizeToFit()
        sb.isTranslucent = false
        return sb
    }()
    
    private let nothingToShowLabel = {
        let label = UILabel()
        label.text = "Nothing to show"
        label.textColor = UIColor(named: "appGray") ?? UIColor.systemGray2
        label.isHidden = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Table Params
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentManagingFiles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableCell") as? EachTableCellView else {
            print("Unknown cell type")
            return UITableViewCell()
        }
        guard 0 <= indexPath.item && indexPath.item < currentManagingFiles.count else {
            print("IndexPath.item index error")
            return UITableViewCell()
        }
        let model = currentManagingFiles[indexPath.item]
        cell.configure(forAudioFile: model) {
            if self.currentPlayingCell != nil {
                self.recEngineModel.stopPlaying()
            }
            self.currentPlayingCell = cell
            self.recEngineModel.startPlaying(file: model.url)
        } withStopActionClosure: {
            self.recEngineModel.stopPlaying()
        }
        cell.isUserInteractionEnabled = true
        return cell
    }
    
    // MARK: - Search Bar
    
    internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentManagingFiles = storageModel.search(withPhrase: searchText)
        recEngineModel.stopPlaying()
        currentPlayingCell = nil
        nothingToShowLabel.isHidden = !currentManagingFiles.isEmpty
        tableView.reloadData()
    }
    
    internal func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    internal func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
    // MARK: - AV Player Delegate
    
    internal func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recEngineModel.stopPlaying()
        currentPlayingCell?.hasSelectedButton(false)
        currentPlayingCell = nil
    }
    
    
    // MARK: - Player Delegate
    
    internal func playerDidStart() {
        currentPlayingCell?.hasSelectedButton(true)
    }
    
    internal func playerDidEnd() {
        currentPlayingCell?.hasSelectedButton(false)
        currentPlayingCell = nil
    }
    
}
