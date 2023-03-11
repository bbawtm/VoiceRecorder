//
//  AudioPickerInstallationUnit.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 11.03.2023.
//

import UIKit
import UniformTypeIdentifiers


class AudioPickerInstallationUnit: InstallationUnitProtocol {
    
    public let unitKey: String = "settings.audioPicker"
    
    public var value: Bool { get { true } }
    
    required public init() {}
    
    public lazy var mainTableCell = SettingsModel.MainTableCell(
        name: "Add outer file",
        sectionNum: 0,
        iconName: "sf.tray.and.arrow.down.fill",
        stateValue: value,
        action: { _ in
            if self.audioPicker.delegate != nil {
                return self.audioPicker
            }
            let alert = UIAlertController(title: "Error", message: "The operation cannot be performed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            return alert
        }
    )
    
    private lazy var audioPicker = {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio])
        picker.delegate = (UIApplication.shared.delegate as! AppDelegate).getSettingsVC()
        picker.allowsMultipleSelection = true
        return picker
    }()
    
    // MARK: - Action
    
    public static func uploadFiles(_ urls: [URL]) -> Int {
        let audiosDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(SettingsModel.audiosDirectoryName, conformingTo: .directory)
        var loadedCount = 0
        for url in urls {
            let audioNameURL = audiosDirectory.appendingPathComponent(url.lastPathComponent, conformingTo: .audio)
            do {
                try Data(contentsOf: url).write(to: audioNameURL)
            } catch {
                print(error.localizedDescription)
                break
            }
            loadedCount += 1
        }
        if loadedCount > 0 {
            (UIApplication.shared.delegate as? AppDelegate)?.reloadAppData()
        }
        return loadedCount
    }
    
}
