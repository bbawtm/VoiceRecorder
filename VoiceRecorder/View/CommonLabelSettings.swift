//
//  CommonLabelSettings.swift
//  VoiceRecorder
//
//  Created by Vadim Popov on 23.02.2023.
//

import UIKit


extension UILabel {
    
    public func appTitleStyle() {
        textColor = UIColor(named: "appWhite")
        font = UIFont.systemFont(ofSize: 40, weight: .semibold)
    }
    
    public func appOrdinaryTextStyle() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        
        let attrString = NSMutableAttributedString(string: text ?? "")
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        
        text = ""
        attributedText = attrString
        textColor = UIColor(named: "appLight")
        font = UIFont.systemFont(ofSize: 15, weight: .regular)
    }
    
    public func appSecondaryTextStyle() {
        appOrdinaryTextStyle()
        textColor = UIColor(named: "appGray")
    }
    
}
