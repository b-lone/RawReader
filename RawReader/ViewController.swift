//
//  ViewController.swift
//  RawReader
//
//  Created by Archie on 2022/2/10.
//

import Cocoa

class ViewController: NSViewController & MyMetalViewDelegate {
    var renderer: AAPLRenderer!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let metalView = self.view as? MyMetalView, let device = MTLCreateSystemDefaultDevice() {
            metalView.metalLayer.device = device
            metalView.delegate = self
            
            metalView.metalLayer.pixelFormat = .bgra8Unorm_srgb
            renderer = AAPLRenderer(metalDevice: device, drawablePixelFormat: metalView.metalLayer.pixelFormat)
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func renderToMetalLayer(_ layer: CAMetalLayer) {
        renderer.render(to: layer)
    }
}

