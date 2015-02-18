//
//  ParrotCommunicator.swift
//  ParrotZik
//
//  Created by serenheit on 12/02/15.
//  Copyright (c) 2015 Внештатный командир земли. All rights reserved.
//

import Foundation
import IOBluetooth

class ParrotCommunicator : IOBluetoothDeviceInquiryDelegate {
    var iobi : IOBluetoothDeviceInquiry? = nil;
    
    init() {
        iobi = IOBluetoothDeviceInquiry(delegate: self)
        iobi?.inquiryLength = 5;
        iobi?.start()
    }
    
    func start() -> IOReturn {
        return iobi!.start();
    }
    
    func deviceInquiryStarted(sender: IOBluetoothDeviceInquiry!) {
        println("deviceInquiryStarted")
    }
    
    func deviceInquiryDeviceFound(sender: IOBluetoothDeviceInquiry!, device: IOBluetoothDevice!) {
        println("Found this device %@ ", device.getAddress());
    }
    
    func deviceInquiryUpdatingDeviceNamesStarted(sender: IOBluetoothDeviceInquiry!, devicesRemaining: UInt32) {
        println("deviceInquiryUpdatingDeviceNamesStarted for ", devicesRemaining)
    }
    
    func deviceInquiryDeviceNameUpdated(sender: IOBluetoothDeviceInquiry!, device: IOBluetoothDevice!, devicesRemaining: UInt32) {
        println("deviceInquiryDeviceNameUpdated %@", device.getAddress())
    }
    
    func deviceInquiryComplete(sender: IOBluetoothDeviceInquiry!, error: IOReturn, aborted: Bool) {
        println("deviceInquiryComplete")
    }
}