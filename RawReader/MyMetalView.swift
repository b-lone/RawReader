//
//  MyMetalView.swift
//  RawReader
//
//  Created by Archie on 2022/2/14.
//

import Cocoa
import MetalKit

protocol MyMetalViewDelegate: AnyObject {
    func renderToMetalLayer(_ layer: CAMetalLayer)
}

class MyMetalView: NSView & CALayerDelegate {
    var metalLayer: CAMetalLayer { self.layer as! CAMetalLayer }
    weak var delegate: MyMetalViewDelegate?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        initCommon()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initCommon()
    }

    func initCommon() {
        wantsLayer = true
        layerContentsRedrawPolicy = .duringViewResize
        layer?.delegate = self
    }
    
    func display(_ layer: CALayer) {
        renderOnEvent()
    }

    func draw(_ layer: CALayer, in ctx: CGContext) {
        renderOnEvent()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        renderOnEvent()
    }
    
    func renderOnEvent() {
        delegate?.renderToMetalLayer(metalLayer)
    }
    
    
    override func makeBackingLayer() -> CALayer {
        CAMetalLayer()
    }
}
