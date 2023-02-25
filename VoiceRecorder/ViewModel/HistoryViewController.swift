//
//  HistoryViewController.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 23.02.2023.
//

import UIKit


class HistoryViewController: UITableViewController {
    
    private let storageModel = (UIApplication.shared.delegate as! AppDelegate).storageModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(named: "appDark")
        tableView.register(UINib(nibName: "HistoryTableCellNib", bundle: .main), forCellReuseIdentifier: "HistoryTableCell")
    }
    
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableCell") as? HistoryTableCellView else {
            print("Unknown cell type")
            return UITableViewCell()
        }
        guard 0 <= indexPath.section && indexPath.section < storageModel.dateOrder.count else {
            print("IndexPath.section index error")
            return UITableViewCell()
        }
        let sectionName = storageModel.dateOrder[indexPath.section]
        guard let indexes = storageModel.dateMap[sectionName] else {
            print("Cannot get indexes array")
            return UITableViewCell()
        }
        guard 0 <= indexPath.row && indexPath.row < indexes.count else {
            print("IndexPath.row index error")
            return UITableViewCell()
        }
        let currentIndex = indexes[indexPath.row]
        let model = storageModel.allAudio[currentIndex]
        cell.configure(forAudioFile: model)
        return cell
    }
    
}
