//
//  RawImage.swift
//  RawReader
//
//  Created by Archie on 2022/2/15.
//

import Cocoa

enum RawImageFormat: String {
    case gray = "Gray"
    case bgra = "BGRA"
    case rgba = "RGBA"
    
    var pixelFormat: MTLPixelFormat {
        switch(self) {
        case .gray:
            return .r8Unorm
        case .bgra:
            return .bgra8Unorm
        case .rgba:
            return .rgba8Unorm
        }
    }
}

@objc class RawImage: NSObject {
    @objc var width: Int = 0
    @objc var height: Int = 0
    var format = RawImageFormat.bgra
    @objc var url: URL
    
    init(url: URL) {
        self.url = url
        
        super.init()
    }
    
    @objc func pixelFormat() -> MTLPixelFormat {
        format.pixelFormat
    }
}
