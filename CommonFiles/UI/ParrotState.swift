//
//  Parrot.swift
//  ParrotZik
//
//  Created by Внештатный командир земли on 17/02/15.
//  Copyright (c) 2015 Внештатный командир земли. All rights reserved.
//

import Cocoa

class ParrotState {
    var bat: BatteryItem = BatteryItem()
    var nam: NameItem = NameItem()
    var ver: VersionItem = VersionItem()
    var anc: ANCItem = ANCItem()
    var panc: PhoneANCItem = PhoneANCItem()
    var lou: LouReedItem = LouReedItem()
    
    var item: NSStatusItem
    
    var req:ParrotRequestor? = nil
    
    init(item: NSStatusItem) {
        self.item = item
        self.bat.updateCB = {
            self.bat.updateStatusItem(self.item)
        }
    }
    
    func getNotifyRegistrations() -> [(path:String, handler: (NSData,ParrotRequestor) -> Void)] {
        var result:[(path:String, handler: (NSData,ParrotRequestor) -> Void)]
        result = self.bat.getNotityRegistrations()
        return result
    }
    
    func getMenuItems() -> [NSMenuItem] {
        var result: [NSMenuItem] = [NSMenuItem]()
        result.extend(self.bat.getMenuItems())
        result.extend(self.nam.getMenuItems())
        result.extend(self.ver.getMenuItems())
        result.extend(self.anc.getMenuItems())
        result.extend(self.panc.getMenuItems())
        result.extend(self.lou.getMenuItems())
        return result
    }
    
    func onConnect(req:ParrotRequestor?) {
        if req != nil {
            self.req = req
        }
        self.bat.clear()
        self.nam.clear()
        self.ver.clear()
        self.anc.clear()
        self.panc.clear()
        self.lou.clear()
        self.req!.clean()
        self.req!.pushItem(self.bat)
        self.req!.pushItem(self.nam)
        self.req!.pushItem(self.ver)
        self.req!.pushItem(self.anc)
        self.req!.pushItem(self.panc)
        self.req!.pushItem(self.lou)
    }
    func onDisconnect() {
        self.req!.clean()
        self.bat.clear()
        self.nam.clear()
        self.ver.clear()
        self.anc.clear()
        self.panc.clear()
        self.lou.clear()
    }
    
    func updateStatusItem(item: NSStatusItem) {
        self.bat.updateStatusItem(item)
    }

    func forwardMenuItemClick(menuItem: NSMenuItem) {
        if self.anc.handleItemClick(self, menuItem: menuItem) {
            return
        }
        if self.panc.handleItemClick(self, menuItem: menuItem) {
            return
        }
        if self.lou.handleItemClick(self, menuItem: menuItem) {
            return
        }
    }
}