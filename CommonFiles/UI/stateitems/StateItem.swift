//
//  StateItem.swift
//  ParrotZik
//
//  Created by Внештатный командир земли on 18/02/15.
//  Copyright (c) 2015 Внештатный командир земли. All rights reserved.
//

import Cocoa

protocol StateItem {
    func getDebugName() -> String
    func getApiCall() -> NSData
    func parseValues(data:NSData)
    func getNotityRegistrations() -> [(path:String, handler: (NSData,ParrotRequestor) -> Void)]
    func handleItemClick(state:ParrotState, menuItem:NSMenuItem) -> Bool
}