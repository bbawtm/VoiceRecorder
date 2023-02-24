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
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        storageModel.allAudio.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Audio"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableCell") as? HistoryTableCellView else {
            print("Unknown cell type")
            return UITableViewCell()
        }
        cell.configure(forAudioFile: self.storageModel.allAudio[indexPath.item])
        return cell
    }
    
}
