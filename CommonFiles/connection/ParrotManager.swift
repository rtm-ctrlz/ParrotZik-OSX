//
//  ParrotManager.swift
//  ParrotZik
//
//  Created by serenheit on 13/02/15.
//  Copyright (c) 2015 Внештатный командир земли. All rights reserved.
//

import Foundation
import IOBluetooth

protocol ParrotConnectionHook {
    func connected();
    func channelOpened();
    func channelClosed();
    func dataHere();
    func disconnected();
}

class ParrotManager : NSObject {
    private var _device : ParrotSearcher
    private var _channel : ParrotChannel
    private var _dataHandler : ParrotDataHandler
    
    private var _hook : ParrotConnectionHook? = nil
    
    private var _notification : IOBluetoothUserNotification? = nil
    
    init(hook : ParrotConnectionHook? = nil, syncDataHandler : Bool? = false, notifyHook : (NSData) -> Void = _localCallback) {
        _device = ParrotSearcher()
        _hook = hook
        _channel = ParrotChannel(parrot: _device, hook: _hook, globalCallback : notifyHook)
        if syncDataHandler ?? false {
            _dataHandler = ParrotDataSync(parrotChannel: _channel)
        }
        else {
            _dataHandler = ParrotDataAsync(parrotChannel: _channel)
        }
        super.init()
    }

    func start() {
        IOBluetoothDevice.registerForConnectNotifications(self, selector: Selector("connected:device:"))
    }

    func dataHandler() -> ParrotDataHandler {
        return _dataHandler
    }
    
    // Debug purpose
    func waitForConnect() -> Bool {
        return _channel.wait_for_connect()
    }
    
    @objc private func disconnected(notification : IOBluetoothUserNotification, device : IOBluetoothDevice) {
        println("Parrot ZiK disconnected")
        _hook?.disconnected()
    }
    
    @objc private func connected(notification : IOBluetoothUserNotification, device : IOBluetoothDevice) {
        _device.scan(device)
        if _device.isConnected() {
            println("Parrot ZiK connected")
            _hook?.connected()
            _channel.establish()
            if _notification == nil {
                _notification = _device.getDevice().registerForDisconnectNotification(self, selector: Selector("disconnected:device:"))
            }
        }
    }
    
}
