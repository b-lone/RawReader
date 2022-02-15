//
//  PreviewManager.swift
//  RawReader
//
//  Created by Archie on 2022/2/15.
//

import Cocoa

var previewManager = PreviewManager()

class PreviewManager: NSObject {
    class var share: PreviewManager { previewManager }
    
    private var previewWindowControllerList = [ImagePreviewWindowController]()
    
    func previewImage(_ image: RawImage) {
        let previewWindowController = ImagePreviewWindowController(image: image)
        previewWindowController.showWindow(self)
        
        previewWindowControllerList.append(previewWindowController)
    }
}
