//
//  AppDelegate.swift
//  RawReader
//
//  Created by Archie on 2022/2/10.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
//    @IBOutlet var openDocumentWindowController: OpenDocumentWindowController!
    var openDocumentWindowController: OpenDocumentWindowController!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.openDocumentWindowController = OpenDocumentWindowController()
        openDocument(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    @IBAction func openDocument(_ sender: Any?) {
        openDocumentWindowController.window?.center()
        openDocumentWindowController.showWindow(self)
    }
}

