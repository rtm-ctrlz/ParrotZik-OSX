//
//  main.swift
//  ParrotZikCli
//
//  Created by Внештатный командир земли on 17/02/15.
//  Copyright (c) 2015 Внештатный командир земли. All rights reserved.
//

import Foundation




var m = ParrotManager()
m.start()

// This call is for debug only
m.waitForConnect()

// stop sending to device empty request
println(m.dataHandler().send(data: ParrotZikRequest.getHello(), callback: _localCallback))

waituntil({return false}, timeout: 1)
println("with Protocol")


println(m.dataHandler().send(data: ParrotZikRequest.get("/api/system/battery")!, callback: _localCallback))

waituntil({return false}, timeout: 2)

