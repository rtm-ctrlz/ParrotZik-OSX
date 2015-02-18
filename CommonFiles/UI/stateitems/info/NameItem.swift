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
    
    var menuItem = NSMenuItem(title: "", action: "", keyEquivalent: "")

    init() {
        self.menuItem.title = self.label
        self.formatLabel()
    }
    
    func getDebugName() -> String {
        return "NameItem"
    }
    
    func getMenuItems() -> [NSMenuItem] {
        if self.menuItem.menu != nil {
            self.menuItem.menu?.removeItem(self.menuItem)
        }
        return [
            self.menuItem
        ]
    }
    
    func clear() {
        value = nil
        self.formatLabel()
    }
    func hide() {
        self.menuItem.hidden = true
    }
    func show() {
        self.menuItem.hidden = false
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
            self.menuItem.title = self.label + ": " + self.value!
        }
    }
    
    func handleItemClick(state:ParrotState, menuItem:NSMenuItem) -> Bool {
        return false
    }
}
