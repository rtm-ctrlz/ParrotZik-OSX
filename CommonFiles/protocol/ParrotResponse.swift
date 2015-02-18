//
//  ParrotZikResponseParser.swift
//  ParrotZik
//
//  Created by Внештатный командир земли on 13/02/15.
//  Copyright (c) 2015 Внештатный командир земли. All rights reserved.
//

import Foundation

public class ParrotZikResponse {
    
    public class func getValue(Data data: NSData?, XPath path:String) -> String? {
        if data == nil {
            return nil
        }
        var document:NSXMLDocument? = NSXMLDocument(data: data!, options: Int(NSXMLDocumentTidyXML), error: nil)
        if document == nil {
            return nil
        }
        return document?.nodesForXPath(path, error: nil)?.first?.stringValue!
    }

    // for notify
    class public func getNotifyPath(notifyData:NSData?) -> String? {
        if notifyData == nil {
            return nil
        }
        var document:NSXMLDocument? = NSXMLDocument(data: notifyData!, options: Int(NSXMLDocumentTidyXML), error: nil)
        
        var rootE:NSXMLElement? =  document?.rootElement()
        if rootE == nil || rootE!.name != "notify" {
            return nil
        }
        return rootE!.attributeForName("path")?.stringValue
        
    }
}