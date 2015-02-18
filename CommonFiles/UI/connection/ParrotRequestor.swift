//
//  ParrotRequestor.swift
//
//
//  Created by Внештатный командир земли on 18/02/15.
//
//

import Foundation

@objc class ParrotRequestor {
    var con: ParrotConnection
    var updateItems: [StateItem]
    var requestT:NSThread? = nil
    var _lock: NSLock? = nil
    
    
    func startT() -> Bool {
        if self.requestT != nil && self.requestT!.executing {
            return false
        }
        self.requestT = NSThread(target: self, selector: "threadTick", object: nil)
        self.requestT!.start()
        return true
    }
    
    init(con: ParrotConnection) {
        self.con = con
        self.updateItems = [StateItem]()
        self._lock = NSLock()
    }
    var inReq:Bool = false
    
    func clean() {
        self._lock!.lock()
        self.updateItems.removeAll(keepCapacity: false)
        self.updateItems = [StateItem]()
        self._lock!.unlock()
    }
    
    func pushItem(item:StateItem) {
        self._lock!.lock()
        self.updateItems.append(item)
        self._lock!.unlock()
        self.startT()
    }
    func threadTick() -> Void {
        var upitem : StateItem?
        var cnt: Int
        self.inReq = false
        
        var sem  = dispatch_semaphore_create(0)
        while self.con.isConnected && self.updateItems.count > 0  {
            self._lock!.lock()
            
            upitem = self.updateItems.first
            if upitem == nil {
                
                self._lock!.unlock()
            } else {
                self.updateItems.removeAtIndex(0)
                
                self._lock!.unlock()
                println("requesting \(upitem!.getDebugName())")
                self.con.man.dataHandler().send(data: upitem!.getApiCall(), callback: {
                    (data:NSData) in
                    
                    println("Data for \(upitem!.getDebugName()) is : ")
                    println(NSString(data: data, encoding: NSASCIIStringEncoding))
                    
                    upitem!.parseValues(self, data: data)
                    dispatch_semaphore_signal(sem)
                })
                // 5 sec
                if dispatch_semaphore_wait(sem,dispatch_time(DISPATCH_TIME_NOW, 5 * 1000000000)) != 0 {
                    println("Semaphore: timeout")
                }
            }
        }
        NSThread.exit()
    }
}
