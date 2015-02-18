//
//  AppDelegate.swift
//  ParrotZik
//
//  Created by Внештатный командир земли on 17/02/15.
//  Copyright (c) 2015 Внештатный командир земли. All rights reserved.
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    
    @IBOutlet var statusMenu: NSMenu!
    var statusItem: NSStatusItem
    
    lazy var pstate: ParrotState = ParrotState(item: self.statusItem)
    lazy var con: ParrotConnection = ParrotConnection(state: self.pstate, statusUp: self.updateStatusItem)
    
    override func awakeFromNib() {
        self.statusItem.menu = self.statusMenu
        self.statusItem.highlightMode = true
    }
    
    override init() {
        self.statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(CGFloat(-1))
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification?) {

        self.updateStatusItem()
        
        self.statusItem.menu!.removeAllItems()
        for i in self.pstate.getMenuItems() {
            self.statusItem.menu!.addItem(i)
        }
        
        self.statusItem.menu!.addItem(NSMenuItem.separatorItem())
        self.statusItem.menu!.addItem(NSMenuItem(title: "About ParrotZik", action: "statusMenuItemAboutZik_Action:", keyEquivalent: ""))
        self.statusItem.menu!.addItem(NSMenuItem(title: "About ParrotZik OSX", action: "statusMenuItemAbout_Action:", keyEquivalent: ""))
        
        self.statusItem.menu!.addItem(NSMenuItem.separatorItem())
        self.statusItem.menu!.addItem(NSMenuItem(title: "Quit", action: "statusMenuItemQuit_Action:", keyEquivalent: ""))
        self.con.start()
    }
    
    func updateStatusItem() {
        if self.con.isConnected {
            self.pstate.updateStatusItem(self.statusItem)
        } else if self.con.isConnecting {
            self.statusItem.title = "Connecting..."
        } else {
            self.statusItem.title = ""
        }
        self.statusItem.length = CGFloat(0)
        if self.statusItem.title != "" {
            var image = NSImage(named: "zik-audio-headset")
            if image != nil {
                image!.size = NSSize(width: 16, height: 16)
                image!.setTemplate(true)
                self.statusItem.image = image!
            }
            self.statusItem.length = CGFloat(-1)
        }
    }
    
    func statusMenuItemAboutZik_Action(sender: NSMenuItem) {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: "http://www.parrot.com/zik")!)
    }
    
    func statusMenuItemAbout_Action(sender: NSMenuItem) {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: "https://github.com/rtm-ctrlz/ParrotZik-OSX")!)
    }
    
    func statusMenuItemQuit_Action(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
    func stateMenuItemClick(sender: NSMenuItem) {
        self.pstate.forwardMenuItemClick(sender)
    }
    
    
    
}

