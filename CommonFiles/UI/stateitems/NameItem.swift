//
//  NameItem.swift
//  ParrotZik
//
//  Created by Внештатный командир земли on 17/02/15.
//  Copyright (c) 2015 Внештатный командир земли. All rights reserved.
//

import Cocoa

class NameItem: StateItem {
    var apiGet:String = "/api/bluetooth/friendlyname/get"
    var path: String = "/answer/bluetooth/@friendlyname"
    var value: String? = nil
    var label: String = "Name"
    
    var menuItems: (name: NSMenuItem, sep: NSMenuItem) = (
        name: NSMenuItem(title: "", action: "", keyEquivalent: ""),
        sep: NSMenuItem.separatorItem()
    )

    init() {
        self.menuItems.name.title = self.label
        self.formatLabel()
    }
    
    func getDebugName() -> String {
        return "NameItem"
    }
    
    func getMenuItems() -> [NSMenuItem] {
        if self.menuItems.name.menu != nil {
            self.menuItems.name.menu?.removeItem(self.menuItems.name)
        }
        if self.menuItems.sep.menu != nil {
            self.menuItems.sep.menu?.removeItem(self.menuItems.sep)
        }
        return [
            self.menuItems.name,
            self.menuItems.sep
        ]
    }
    
    func clear() {
        value = nil
        self.formatLabel()
    }
    func hide() {
        self.menuItems.name.hidden = true
        self.menuItems.sep.hidden = true
    }
    func show() {
        
        self.menuItems.name.hidden = false
        self.menuItems.sep.hidden = false
    }
    
    func getApiCall() -> NSData {
        return ParrotZikRequest.call(self.apiGet)!
    }
    func parseValues(data:NSData) {
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
            self.menuItems.name.title = self.label + ": " + self.value!
        }
    }
}
