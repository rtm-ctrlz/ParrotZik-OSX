
//  ParrotChannel.swift
//  ParrotZik
//
//  Created by serenheit on 12/02/15.
//  Copyright (c) 2015 Внештатный командир земли. All rights reserved.
//

import Foundation
import IOBluetooth

func _localCallback(data: NSData)->Void {
    println(data)
    println(NSString(data: data, encoding: NSASCIIStringEncoding))
    return
}

class ParrotChannel : NSObject {
    
    private var _parrot : ParrotDevice
    private var _hook : ParrotConnectionHook?
    private var _data : [NSData]
    private var _singleCallback : (NSData)->Void
    private var _globalCallback : (NSData)->Void
    private var _singleCallbackUsed : Bool = false
    private var _channelDelegate : ChannelDelegate? = nil
    private var _openedChannel : IOBluetoothRFCOMMChannel? = nil;
    
    private class ChannelDelegate : NSObject, IOBluetoothRFCOMMChannelDelegate {
        
        private var p : ParrotChannel
        private var _hook:ParrotConnectionHook?
        init(parent : ParrotChannel, hook : ParrotConnectionHook? = nil)
        {
            p = parent
            _hook = hook
        }
        
        func rfcommChannelData(rfcommChannel: IOBluetoothRFCOMMChannel!, data dataPointer: UnsafeMutablePointer<Void>, length dataLength: UInt)
        {
            println("rfcommChannelData")
            if (dataLength < 3) {
                p._data.append(NSData())
                interruptwait()
            }
            var data = NSData(bytes: dataPointer + 3, length: Int(dataLength - 3))
            p._singleCallback(data)
            if p._singleCallbackUsed {
                p._singleCallback = p._globalCallback
                p._singleCallbackUsed = false
            }
            else {
                p._data.append(data)
                interruptwait()
            }
            if _hook != nil {
                _hook!.dataHere()
            }
        }
        
        func rfcommChannelOpenComplete(rfcommChannel: IOBluetoothRFCOMMChannel!, status error: IOReturn)
        {
            println("rfcommChannelOpenComplete")
            p._openedChannel = rfcommChannel
            interruptwait()
            if _hook != nil {
                _hook!.channelOpened()
            }
        }
        
        func rfcommChannelClosed(rfcommChannel: IOBluetoothRFCOMMChannel!)
        {
            println("rfcommChannelClosed")
            p._openedChannel = nil
            if _hook != nil {
                _hook!.channelClosed()
            }
        }
        
        func rfcommChannelControlSignalsChanged(rfcommChannel: IOBluetoothRFCOMMChannel!)
        {
            println("rfcommChannelControlSignalsChanged")
        }
        
        func rfcommChannelFlowControlChanged(rfcommChannel: IOBluetoothRFCOMMChannel!)
        {
            println("rfcommChannelFlowControlChanged")
        }
        
        func rfcommChannelWriteComplete(rfcommChannel: IOBluetoothRFCOMMChannel!, refcon: UnsafeMutablePointer<Void>, status error: IOReturn)
        {
            println("rfcommChannelWriteComplete")
        }
        
        func rfcommChannelQueueSpaceAvailable(rfcommChannel: IOBluetoothRFCOMMChannel!)
        {
            println("rfcommChannelQueueSpaceAvailable")
        }
    }

    init(parrot : ParrotDevice, hook : ParrotConnectionHook? = nil, globalCallback : (NSData) -> Void = _localCallback) {
        _parrot = parrot
        _hook = hook
        _data = []
        _singleCallback = _localCallback
        _globalCallback = globalCallback
        super.init()
    }
    
    func establish(wait: Bool=false) -> Bool {
        if _openedChannel != nil {
            return true
        }
        
        if !_parrot.isConnected() {
            return false
        }
        
        if _channelDelegate == nil {
            _channelDelegate = ChannelDelegate(parent: self, hook: _hook)
        }

        if wait {
            return (_parrot.getDevice().performSDPQuery(self) == kIOReturnSuccess)
                    && wait_for_connect()
        }
        else {
            return (_parrot.getDevice().performSDPQuery(self) == kIOReturnSuccess)
        }
    }
    
    func sdpQueryComplete(device: IOBluetoothDevice!, status: IOReturn) -> Void {
        println("sdpQueryComplete")
        
        var rfCommChan : BluetoothRFCOMMChannelID = 0;
        self._parrot.getService().getRFCOMMChannelID(&rfCommChan)
        
        var channel : IOBluetoothRFCOMMChannel?;
        device.openRFCOMMChannelAsync(&channel, withChannelID: rfCommChan, delegate: self._channelDelegate)
    }
    
    func wait_for_connect() -> Bool {
        if (self._openedChannel != nil) {
            return true
        }

        return waituntil({self._openedChannel != nil})
    }

    func send_and_recv(data dataPointer: UnsafeMutablePointer<Void>, length dataLength: Int, timeout:NSTimeInterval?=10) -> NSData? {
        if _openedChannel == nil {
            return nil
        }
        if (!send(data: dataPointer, length: dataLength)) {
            return nil
        }

        waituntil({!self._data.isEmpty}, timeout: timeout)

        return recv_noblock()
    }
    
    // Non thread-safe!
    func send_and_recv(data dataPointer: UnsafeMutablePointer<Void>, length dataLength: Int, callback : (NSData)->Void) -> Bool {
        if _openedChannel == nil {
            return false
        }

        if _singleCallbackUsed {
            return false
        }

        if send(data: dataPointer, length: dataLength)
        {
            _singleCallbackUsed = true
            _singleCallback = callback
            return true;
        }
        return false
    }

    func send(data dataPointer: UnsafeMutablePointer<Void>, length dataLength: Int) -> Bool
    {
        if _openedChannel == nil {
            return false
        }

        _openedChannel!.writeSync(dataPointer, length: (UInt16)(dataLength))
        return true
    }
    
    func recv_block(timeout:NSTimeInterval?=10) -> NSData {
        waituntil({!self._data.isEmpty}, timeout: timeout)
        
        return recv_noblock()
    }
    
    func recv_noblock() -> NSData {
        if _data.isEmpty {
            return NSData()
        }
        else {
            return _data.removeAtIndex(0)
        }
    }
}