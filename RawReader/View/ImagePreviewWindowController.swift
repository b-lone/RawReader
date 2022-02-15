//
//  ImagePreviewWindowController.swift
//  RawReader
//
//  Created by Archie on 2022/2/15.
//

import Cocoa

class ImagePreviewWindowController: NSWindowController {
    @IBOutlet var previewView: PreviewView!
    
    override var windowNibName: NSNib.Name? { "ImagePreviewWindowController" }
    private var image: RawImage
    private var renderer: RRRenderer!
    
    init(image: RawImage) {
        self.image = image
        
        super.init(window: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        previewView.delegate = self
        
        if let device = MTLCreateSystemDefaultDevice() {
            previewView.metalLayer.device = device
            
            previewView.metalLayer.pixelFormat = .bgra8Unorm_srgb
            renderer = RRRenderer(metalDevice: device, drawablePixelFormat: previewView.metalLayer.pixelFormat, image: image)
        }
    }
}

extension ImagePreviewWindowController: PreviewViewDelegate {
    func renderToMetalLayer(_ layer: CAMetalLayer) {
        renderer?.render(to: layer)
    }
}
