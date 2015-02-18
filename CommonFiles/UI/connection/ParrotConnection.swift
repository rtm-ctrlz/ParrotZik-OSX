//
//  ParrotConnection.swift
//  ParrotZik
//
//  Created by Внештатный командир земли on 17/02/15.
//  Copyright (c) 2015 Внештатный командир земли. All rights reserved.
//

import Foundation

class ParrotConnection: ParrotConnectionHook {
    lazy var man : ParrotManager = ParrotManager(hook: self, syncDataHandler: false, notifyHook: self.onNotify)
    var state: ParrotState
    var statusUp: ()->Void
    
    var isConnected:Bool = false
    var isConnecting:Bool = false
    var helloHere:Bool = false
    
    
    lazy var req:ParrotRequestor = ParrotRequestor(con: self)
    
    init(state: ParrotState, statusUp: ()->Void ) {
        self.state = state
        self.statusUp = statusUp
    }
    
    
    func start() {
        self.man.start()
    }
    
    func connected() {
        self.isConnected = false
        self.isConnecting = true
        self.statusUp()
        println("CON")
    }
    func disconnected() {
        self.isConnected = false
        self.isConnecting = false
        self.statusUp()
        println("DIS")
    }
    func channelOpened() {
        self.doHello()
        println("COP")
    }
    func channelClosed() {
        self.isConnected = false
        self.isConnecting = true
        self.state.onDisconnect()
        self.statusUp()
        println("CCL")
    }
    func dataHere() {
        println("DTHR")
    }
    
    func onNotify(data:NSData) {
        println("onNTF")
        var path = ParrotZikResponse.getNotifyPath(data)
        if path == nil {
            return
        }
        println("NTF PTH: \(path)")
        for reg in self.state.getNotifyRegistrations() {
            if path == reg.path {
                reg.handler(data, req)
            }
        }
    }
    
    func doHello() {
        if self.hello() {
            self.isConnecting = false
            self.isConnected = true
            self.statusUp()
            self.state.onConnect(self.req)
        } else {
            println("BAD HELLO")
        }
    }
    func hello() -> Bool {
        self.helloHere = false
        self.man.dataHandler().send(data: ParrotZikRequest.getHello(), callback: {
            (data:NSData) in
            self.helloHere = true
            println("HELLO HERE!")
            interruptwait()
        })
        return waituntil({return self.helloHere}, timeout: 20)
    }
}