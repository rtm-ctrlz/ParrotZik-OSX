//
//  ParrotZikProtocol.swift
//  ParrotZik
//
//  Created by Внештатный командир земли on 13/02/15.
//  Copyright (c) 2015 Внештатный командир земли. All rights reserved.
//

import Foundation

class ParrotZikRequest {
    
    private  class func generateRequest(requestString:String ) -> NSData {
        var lengthOffset:Int = 3
        var request:NSData? = requestString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        if request == nil || request!.length + lengthOffset >= Int(UInt8.max) {
            return NSData()
        }
        // building resulting data
        var req:NSMutableData = NSMutableData()
        
        // adding header
        var length:Int = request!.length + lengthOffset
        var header:[Byte] = [UInt8(( length&0xFF00 )>>8), UInt8(length&0x00FF), 0x80]
        req.appendBytes(&header, length: header.count)
        
        // adding body
        req.appendData(request!)
        
        // all done
        return req
    }
    
    class func getHello() -> NSData {
        var b:[Byte] = [0, 3, 0]
        return NSData(bytes: b, length: b.count)
    }
    
    class func get(apiString:String) -> NSData? {
        return self.call(apiString+"/get")
    }
    class func set(apiString:String, bArg arg:Bool ) -> NSData? {
        return self.set(apiString, sArg: arg ? "true" : "false" )
    }
    class func set(apiString:String, sArg arg:String ) -> NSData? {
        return self.generateRequest("SET " + apiString + "/set?arg=" + arg)
    }
    class func call(apiString:String) -> NSData? {
        return self.generateRequest("GET "+apiString)
    }
    
}