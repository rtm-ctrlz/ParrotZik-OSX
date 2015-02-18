//
//  VersionItem.swift
//  ParrotZik
//
//  Created by Внештатный командир земли on 18/02/15.
//  Copyright (c) 2015 Внештатный командир земли. All rights reserved.
//

import Cocoa

class VersionItem: StateItem {
    var apiGet:String = "/api/software/version/get"
    var path: String = "/answer/software/@version"
    var value: String? = nil
    var label: String = "Version"
    
    var menuItems: (val: NSMenuItem, sep: NSMenuItem) = (
        val: NSMenuItem(title: "", action: "", keyEquivalent: ""),
        sep: NSMenuItem.separatorItem()
    )
    
    init() {
        self.menuItems.val.title = self.label
        self.formatLabel()
    }
    
    func getDebugName() -> String {
        return "VersionItem"
    }
    
    func getMenuItems() -> [NSMenuItem] {
        if self.menuItems.val.menu != nil {
            self.menuItems.val.menu?.removeItem(self.menuItems.val)
        }
        if self.menuItems.sep.menu != nil {
            self.menuItems.sep.menu?.removeItem(self.menuItems.sep)
        }
        return [
            self.menuItems.val,
            self.menuItems.sep
        ]
    }
    
    func clear() {
        value = nil
        self.formatLabel()
    }
    func hide() {
        self.menuItems.val.hidden = true
        self.menuItems.sep.hidden = true
    }
    func show() {
        
        self.menuItems.val.hidden = false
        self.menuItems.sep.hidden = false
    }
    
    func getApiCall() -> NSData {
        return ParrotZikRequest.call(self.apiGet)!
    }
    func parseValues(req: ParrotRequestor, data:NSData) {
        self.value = ParrotZikResponse.getValue(Data: data, XPath: self.path)
        self.formatLabel()
    }
    
    func getNotityRegistrations() -> [(path:String, handler: (NSData,ParrotRequestor) -> Void)] {
        return []
    }
    
    func formatLabel() {
        if self.value == nil {
            self.hide()
        } else {
            self.show()
            self.menuItems.val.title = self.label + ": " + self.value!
        }
    }
    
    func handleItemClick(state:ParrotState, menuItem:NSMenuItem) -> Bool {
        return false
    }
}
