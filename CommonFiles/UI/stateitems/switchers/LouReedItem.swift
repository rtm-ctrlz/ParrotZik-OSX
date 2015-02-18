//
//  LouReedItem.swift
//  ParrotZik
//
//  Created by Внештатный командир земли on 18/02/15.
//  Copyright (c) 2015 Внештатный командир земли. All rights reserved.
//

import Cocoa

class LouReedItem: SwitcherItem {
    override var apiSet:String { get { return "/api/audio/specific_mode/enabled" }}
    override var path: String  { get { return "/answer/audio/specific_mode/@enabled" }}
    override var label: String  { get { return "Lou Reed mode" }}
    required override init() {
        super.init()
        self.menuItems =  (
            val: NSMenuItem(title: "", action: "stateMenuItemClick:", keyEquivalent: ""),
            NSMenuItem.separatorItem()
        )
        self.formatLabel()
    }
}