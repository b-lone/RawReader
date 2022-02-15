//
//  ImageSelectionWindowController.swift
//  RawReader
//
//  Created by Archie on 2022/2/15.
//

import Cocoa

class OpenDocumentWindowController: NSWindowController {
    @IBOutlet weak var widthTextField: NSTextField!
    @IBOutlet weak var heightTextField: NSTextField!
    @IBOutlet weak var formatComboBox: NSComboBox!
    
    override var windowNibName: NSNib.Name? { "OpenDocumentWindowController" }

    override func windowDidLoad() {
        super.windowDidLoad()
    }

    @IBAction func onSelectButton(_ sender: Any) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false;
        openPanel.message = "Please select raw image."
        openPanel.begin { [weak self] result in
            guard let self = self else { return }
            if result == .OK, let url = openPanel.url {
                let image = RawImage(url: url)
                image.width = Int(NSString(string: self.widthTextField.stringValue).intValue)
                image.height = Int(NSString(string: self.heightTextField.stringValue).intValue)
                image.format = RawImageFormat(rawValue: self.formatComboBox.stringValue) ?? .bgra
                PreviewManager.share.previewImage(image)
            }
            self.close()
        }
    }
}
