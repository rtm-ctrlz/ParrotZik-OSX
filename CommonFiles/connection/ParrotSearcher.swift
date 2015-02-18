//
//  ParrotSearcher.swift
//  ParrotZik
//
//  Created by serenheit on 12/02/15.
//  Copyright (c) 2015 Внештатный командир земли. All rights reserved.
//

import Foundation
import IOBluetooth

protocol ParrotDevice {
    func getDevice() -> IOBluetoothDevice;
    func getService() -> IOBluetoothSDPServiceRecord;
    func isConnected() -> Bool;
}

class ParrotSearcher : ParrotDevice {
    private var _device : IOBluetoothDevice? = nil
    private var _service : IOBluetoothSDPServiceRecord? = nil
    
    init() {
        scan()
    }
    
    func scan() {
        // Do not scan if we already scanned for the devices
        if _device != nil && _service != nil {
            return
        }
        
        var pairedDevices = IOBluetoothDevice.pairedDevices()
        for dev in pairedDevices {
            scan(dev as IOBluetoothDevice);
        }
    }
    
    func scan(device : IOBluetoothDevice) {
        // Do not scan if we already scanned for the devices
        if _device != nil && _service != nil {
            return
        }
        
        if (device.services != nil)
        {
            for service in device.services! {
                if service.getServiceName()? == "Parrot RFcomm service" {
                    _device = device
                    _service = service as? IOBluetoothSDPServiceRecord
                    return
                }
            }
        }
    }
    
    func isConnected() -> Bool {
        if _device == nil {
            return false
        }
        else {
            return _device!.isConnected()
        }
    }

    func getDevice() -> IOBluetoothDevice {
        // Will cause runtime error if no device found
        return _device!
    }
    
    func getService() -> IOBluetoothSDPServiceRecord {
        // Will cause runtime error if no device found
        return _service!
    }
}