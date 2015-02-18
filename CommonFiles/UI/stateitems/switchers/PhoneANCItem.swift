//
//  PhoneANCItem.swift
//  ParrotZik
//
//  Created by Внештатный командир земли on 18/02/15.
//  Copyright (c) 2015 Внештатный командир земли. All rights reserved.
//

import Cocoa

class PhoneANCItem: StateItem {
    var apiGet:String = "/api/system/anc_phone_mode/enabled/get"
    var apiSet:String = "/api/system/anc_phone_mode/enabled"
    var _inSetMode = false
    var path: String = "/answer/system/anc_phone_mode/@enabled"
    var value: String? = nil
    var label: String = "Phone ANC"
    
    var menuItems: (val: NSMenuItem, sep: NSMenuItem) = (
        val: NSMenuItem(title: "", action: "stateMenuItemClick:", keyEquivalent: ""),
        sep: NSMenuItem.separatorItem()
    )
    
    init() {
        self.menuItems.val.title = self.label
        self.formatLabel()
    }
    
    func getDebugName() -> String {
        return "PhoneANCItem"
    }
    
    func getMenuItems() -> [NSMenuItem] {
        if self.menuItems.val.menu != nil {
            self.menuItems.val.menu?.removeItem(self.menuItems.val)
        }
        if self.menuItems.sep.menu != nil {
            self.menuItems.sep.menu?.removeItem(self.menuItems.sep)
        }
        return [
            self.menuItems.val
            ,self.menuItems.sep
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
        if self._inSetMode {
            var f:Bool = self.value == "true"
            return ParrotZikRequest.set(self.apiSet, bArg: !f )!
        }
        return ParrotZikRequest.call(self.apiGet)!
    }
    func parseValues(data:NSData) {
        if self._inSetMode {
            self._inSetMode = false
        } else {
            self.value = ParrotZikResponse.getValue(Data: data, XPath: self.path)
            self.formatLabel()
        }
    }
    
    func getNotityRegistrations() -> [(path:String, handler: (NSData,ParrotRequestor) -> Void)] {
        return []
    }
    
    func formatLabel() {
        self.menuItems.val.enabled = true
        if self.value == nil {
            self.menuItems.val.state = NSOffState
            self.hide()
        } else {
            self.menuItems.val.state = NSOffState
            if self.value == "true" {
                self.menuItems.val.state = NSOnState
            } else {
                self.menuItems.val.state = NSOffState
            }
            self.show()
        }
    }
    
    func handleItemClick(state:ParrotState, menuItem:NSMenuItem) -> Bool {
        if self.menuItems.val.isEqual(menuItem) {
            self._inSetMode = true
            self.menuItems.val.enabled = false
            state.req!.pushItem(self)
            state.req!.pushItem(self)
            return true
        }
        return false
    }
}

