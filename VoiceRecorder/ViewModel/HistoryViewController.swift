//
//  HistoryViewController.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 23.02.2023.
//

import UIKit
import AVFoundation


class HistoryViewController: UITableViewController, PlayerDelegate, AVAudioPlayerDelegate {
    
    private let storageModel = (UIApplication.shared.delegate as! AppDelegate).storageModel
    private let recEngineModel = (UIApplication.shared.delegate as! AppDelegate).recEngineModel
    
    private var currentPlayingCell: EachTableCellView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (UIApplication.shared.delegate as? AppDelegate)?.linkHistoryVC(self)
        
        tableView.backgroundColor = UIColor(named: "appDark")
        tableView.register(UINib(nibName: "EachTableCellNib", bundle: .main), forCellReuseIdentifier: "HistoryTableCell")
        
        self.view.addSubview(nothingToShowLabel)
        nothingToShowLabel.isHidden = !storageModel.allAudio.isEmpty
        
        NSLayoutConstraint.activate([
            nothingToShowLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            nothingToShowLabel.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recEngineModel.setupPlayerDelegate(self)
    }
    
    private let nothingToShowLabel = {
        let label = UILabel()
        label.text = "Nothing to show"
        label.textColor = UIColor(named: "appGray") ?? UIColor.systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Table Params
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        storageModel.dateOrder.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard 0 <= section && section < storageModel.dateOrder.count else {
            print("numberOfRowsInSection: Section index error")
            return 0
        }
        let sectionName = storageModel.dateOrder[section]
        guard let indexes = storageModel.dateMap[sectionName] else {
            print("numberOfRowsInSection: Cannot get indexes array")
            return 0
        }
        return indexes.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if 0 <= section && section < storageModel.dateOrder.count {
            return storageModel.dateOrder[section]
        }
        return ""
    }
    
    private func getModel(forIndex indexPath: IndexPath) -> StorageModel.AudioFile? {
        guard 0 <= indexPath.section && indexPath.section < storageModel.dateOrder.count else {
            return nil
        }
        let sectionName = storageModel.dateOrder[indexPath.section]
        guard let indexes = storageModel.dateMap[sectionName] else {
            print("Cannot get indexes array")
            return nil
        }
        guard 0 <= indexPath.row && indexPath.row < indexes.count else {
            return nil
        }
        let currentIndex = indexes[indexPath.row]
        return storageModel.allAudio[currentIndex]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableCell") as? EachTableCellView else {
            print("Unknown cell type")
            return UITableViewCell()
        }
        guard let model = getModel(forIndex: indexPath) else {
            return UITableViewCell()
        }
        cell.configure(forAudioFile: model) {
            if self.currentPlayingCell != nil {
                self.recEngineModel.stopPlaying()
            }
            self.currentPlayingCell = cell
            self.recEngineModel.startPlaying(file: model.url)
        } withStopActionClosure: {
            self.recEngineModel.stopPlaying()
        }
        return cell
    }
    
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            let rowsNum = self.tableView(tableView, numberOfRowsInSection: indexPath.section)
            if let model = getModel(forIndex: indexPath), storageModel.delete(file: model) {
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                if rowsNum <= 1 {
                    tableView.deleteSections([indexPath.section], with: .automatic)
                }
                tableView.endUpdates()
                nothingToShowLabel.isHidden = !storageModel.allAudio.isEmpty
            } else {
                // error
            }
        }
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
