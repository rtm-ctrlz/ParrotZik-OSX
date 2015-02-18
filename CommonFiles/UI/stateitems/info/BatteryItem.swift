//
//  BatteryItem.swift
//  ParrotZik
//
//  Created by Внештатный командир земли on 17/02/15.
//  Copyright (c) 2015 Внештатный командир земли. All rights reserved.
//

import Cocoa

class BatteryItem: StateItem {
    var apiGet:String = "/api/system/battery/get"
    var paths: (level: String, state: String) = (level: "/answer/system/battery/@level", state: "/answer/system/battery/@state")
    var values: (level: String?, state: String?) = (level: nil, state: nil)
    var labels: (level: String, state: String) = (level: "Level", state: "Battery")
    
    var menuItems: (level: NSMenuItem, state: NSMenuItem, sep: NSMenuItem) = (
        level: NSMenuItem(title: "", action: "", keyEquivalent: ""),
        state: NSMenuItem(title: "", action: "", keyEquivalent: ""),
        sep: NSMenuItem.separatorItem()
    )
    
    var updateCB: () -> Void
    
    init(statusCB: () -> Void = {}) {
        self.menuItems.level.title = self.labels.level
        self.menuItems.state.title = self.labels.state
        self.updateCB = statusCB
        self.formatLabels()
    }
    
    func getDebugName() -> String {
        return "BatteryItem"
    }
    
    func getMenuItems() -> [NSMenuItem] {
        if self.menuItems.state.menu != nil {
            self.menuItems.state.menu?.removeItem(self.menuItems.state)
        }
        if self.menuItems.level.menu != nil {
            self.menuItems.level.menu?.removeItem(self.menuItems.level)
        }
        if self.menuItems.sep.menu != nil {
            self.menuItems.sep.menu?.removeItem(self.menuItems.sep)
        }
        return [
            self.menuItems.state,
            self.menuItems.level,
            self.menuItems.sep
        ]
    }
    
    func clear() {
        values.level = nil
        values.state = nil
        self.formatLabels()
    }
    func hide() {
        self.menuItems.state.hidden = true
        self.menuItems.level.hidden = true
        self.menuItems.sep.hidden = true
    }
    func show() {
        
        self.menuItems.state.hidden = false
        self.menuItems.level.hidden = false
        self.menuItems.sep.hidden = false
    }
    
    func getApiCall() -> NSData {
        return ParrotZikRequest.call(self.apiGet)!
    }
    func parseValues(req: ParrotRequestor, data:NSData) {
        self.values.level = ParrotZikResponse.getValue(Data: data, XPath: self.paths.level)
        self.values.state = ParrotZikResponse.getValue(Data: data, XPath: self.paths.state)
        self.updateCB()
        self.formatLabels()
    }
    func notifyHandler(data:NSData, req:ParrotRequestor) -> Void {
        println("NOTIFY IN BATTERY")
        req.pushItem(self)
    }
    
    func getNotityRegistrations() -> [(path:String, handler: (NSData,ParrotRequestor) -> Void)] {
        return [
            (path: self.apiGet, handler: self.notifyHandler)
        ]
    }
    
    func formatLabels() {
        if self.values.state == nil && self.values.level == nil {
            self.hide()
            return
        } else {
            self.show()
        }
        if self.values.state == nil {
            self.menuItems.state.title = self.labels.state + ": updating"
            self.menuItems.level.hidden = true
        } else if self.values.state == "in_use" {
            self.menuItems.state.title = self.labels.state + " in use"
            self.menuItems.level.hidden = false
            if self.values.level == nil || self.values.level == "" {
                self.menuItems.level.title = self.labels.level + ": updating"
            } else {
                self.menuItems.level.title = self.labels.level + ": " + self.values.level! + "%"
            }
        } else {
            self.menuItems.state.title = self.labels.state + " is " + self.values.state!
            self.menuItems.level.hidden = true
        }
    }
    
    func handleItemClick(state:ParrotState, menuItem:NSMenuItem) -> Bool {
        return false
    }
    
    func updateStatusItem(item:NSStatusItem) {
        if self.values.state == nil {
            item.title = "Connected..."
        } else {
            if self.values.state == "in_use" {
                if self.values.level == nil || self.values.level == "" {
                    item.title = "On battery..."
                } else {
                    item.title = self.values.level! + "%"
                }
            } else if self.values.state == "charging" {
                item.title = "AC"
            } else {
                item.title = "100%"
            }
        }
    }

}