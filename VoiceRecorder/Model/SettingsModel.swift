//
//  SettingsModel.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 08.03.2023.
//

import UIKit


class SettingsModel {
    
    class MainTableCell {
        public let name: String
        public let sectionNum: Int
        public let iconName: String
        
        init(name: String, sectionNum: Int, iconName: String) {
            self.name = name
            self.sectionNum = sectionNum
            self.iconName = iconName
        }
    }
    
    public let mainTableCells: [MainTableCell] = [
        .init(name: "Microphone adjustment", sectionNum: 0, iconName: "AppIcon"),
        .init(name: "Recording quality", sectionNum: 0, iconName: "AppIcon"),
        .init(name: "Choose format", sectionNum: 0, iconName: "AppIcon"),
        .init(name: "Add outer file", sectionNum: 0, iconName: "AppIcon"),
        
        .init(name: "Don't allow standby mode", sectionNum: 1, iconName: "AppIcon"),
        .init(name: "\"Your voice is recording\" phrase", sectionNum: 1, iconName: "AppIcon"),
    ]
    
    public func numberOfSections() -> Int {
        Set(mainTableCells.map { $0.sectionNum }).count
    }
    
    public func numberOfRowsInSection(_ section: Int) -> Int {
        mainTableCells.filter { $0.sectionNum == section }.count
    }
    
    public func getItem(section: Int, row: Int) -> MainTableCell {
        mainTableCells.filter { $0.sectionNum == section } [row]
    }
    
}
