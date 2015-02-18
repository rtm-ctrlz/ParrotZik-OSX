//
//  macutil.swift
//  ParrotZik
//
//  Created by Внештатный командир земли on 10/02/15.
//  Copyright (c) 2015 Внештатный командир земли. All rights reserved.
//

import Foundation
import AppKit

func interruptwait() {
    var event:NSEvent = NSEvent.otherEventWithType(NSEventType.ApplicationDefined, location: NSPoint(), modifierFlags: NSEventModifierFlags.allZeros, timestamp: 0, windowNumber: 1, context: nil, subtype: 0, data1: 0, data2: 0)!
    NSApplication.sharedApplication().postEvent (event, atStart: true)
            println("send int")
}

func waituntil(callback: () -> Bool, timeout:NSTimeInterval?=10) -> Bool {
    var app:NSApplication = NSApplication.sharedApplication()
    var e:NSEvent?
    var wait:NSDate
    var endtime:NSTimeInterval = NSDate().timeIntervalSince1970 + timeout!
    while true {
        if NSDate().timeIntervalSince1970 > endtime {
            break
        }
        wait = NSDate().dateByAddingTimeInterval(10)
//        println(NSDate())
//        println( NSDate().dateByAddingTimeInterval(2))
//        println(wait)
        e=app.nextEventMatchingMask(Int(NSEventMask.ApplicationDefinedMask.rawValue), untilDate: wait, inMode: NSDefaultRunLoopMode, dequeue: true)
//        println("got evnt")
        if e != nil {
            if e?.type == NSEventType.ApplicationDefined {
                if callback() {
                    return true
                }
            } else {
                app.postEvent(e!, atStart: true)
            }
        }
    }
    return false
}