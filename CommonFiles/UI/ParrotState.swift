//
//  Parrot.swift
//  ParrotZik
//
//  Created by Внештатный командир земли on 17/02/15.
//  Copyright (c) 2015 Внештатный командир земли. All rights reserved.
//

import Cocoa

class ParrotState {
    var bat: BatteryItem
    var item: NSStatusItem
    
    var req:ParrotRequestor? = nil
    
    init(item: NSStatusItem) {
        self.item = item
        self.bat = BatteryItem()
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
        return result
    }
    
    func onConnect(req:ParrotRequestor?) {
        if req != nil {
            self.req = req
        }
        self.bat.clear()
        self.req!.pushItem(self.bat)
    }
    func onDisconnect() {
        self.bat.clear()
        self.req!.clean()
    }
    
    func updateStatusItem(item: NSStatusItem) {
        self.bat.updateStatusItem(item)
    }
}