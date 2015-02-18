//
//  ParrotDataHandler.swift
//  ParrotZik
//
//  Created by serenheit on 13/02/15.
//  Copyright (c) 2015 Внештатный командир земли. All rights reserved.
//

import Foundation

protocol ParrotDataHandler {
    func send(bytes dataPointer: UnsafeMutablePointer<Void>, length: Int) -> Bool
    func send(bytes dataPointer: UnsafeMutablePointer<Void>, length: Int, callback : (NSData)->Void) -> Bool
    func send(#data: NSData) -> Bool
    func send(#data: NSData, callback: (NSData)->Void) -> Bool
    func recv() -> NSData
}

class ParrotBaseDataHandler : ParrotDataHandler {
    func send(bytes dataPointer: UnsafeMutablePointer<Void>, length dataLength: Int) -> Bool {
        return false
    }
    
    func send(bytes dataPointer: UnsafeMutablePointer<Void>, length dataLength: Int, callback : (NSData)->Void) -> Bool {
        return false
    }
    
    func send(#data: NSData) -> Bool {
        var dataPointer : [Byte] = [Byte](count: data.length, repeatedValue: 0)
        data.getBytes(&dataPointer)
        return self.send(bytes: &dataPointer, length: data.length)
    }
    
    func send(#data: NSData, callback: (NSData)->Void) -> Bool {
        var dataPointer : [Byte] = [Byte](count: data.length, repeatedValue: 0)
        data.getBytes(&dataPointer)
        return self.send(bytes: &dataPointer, length: data.length, callback)
    }
    
    func recv() -> NSData {
        return NSData()
    }

}
    
class ParrotDataAsync : ParrotBaseDataHandler {
    private var _parrotChannel : ParrotChannel
    
    init(parrotChannel : ParrotChannel) {
        _parrotChannel = parrotChannel
    }
    
    override func send(bytes dataPointer: UnsafeMutablePointer<Void>, length dataLength: Int) -> Bool {
        return _parrotChannel.establish() &&
                _parrotChannel.send(data: dataPointer, length: dataLength)
    }
    
    override func send(bytes dataPointer: UnsafeMutablePointer<Void>, length dataLength: Int, callback : (NSData)->Void) -> Bool {
        return _parrotChannel.establish() &&
                _parrotChannel.send_and_recv(data: dataPointer, length: dataLength, callback: callback)
    }
    
    override func recv() -> NSData {
        if !_parrotChannel.establish() {
            return NSData()
        }
        
        return _parrotChannel.recv_noblock()
    }
}

class ParrotDataSync : ParrotBaseDataHandler {
    private var _parrotChannel : ParrotChannel
    
    init(parrotChannel : ParrotChannel) {
        _parrotChannel = parrotChannel
    }
    
    override func send(bytes dataPointer: UnsafeMutablePointer<Void>, length dataLength: Int) -> Bool {
        return _parrotChannel.establish(wait: true) &&
            _parrotChannel.send(data: dataPointer, length: dataLength)
    }
    
    override func send(bytes dataPointer: UnsafeMutablePointer<Void>, length dataLength: Int, callback : (NSData)->Void) -> Bool {
        return send(bytes: dataPointer, length: dataLength)
    }
    
    override func recv() -> NSData {
        if !_parrotChannel.establish(wait: true) {
            return NSData()
        }
        
        return _parrotChannel.recv_block()
    }
}