//
//  WT.swift
//  AfterPerformDemo
//
//  Created by Ivan Milinkovic on 11/26/15.
//
//

import Foundation


class SWTCompletion {
    private let currentWt : SWT
    private init(currentWt : SWT) {
        // keep the current instance in memory
        self.currentWt = currentWt
    }
    
    // note: can't use dispatch_once as it requires a token to be a global or a static varible
    // which does not fit this use case, because locking should be done on per instance level
    private var lock = NSLock()
    private var isDone: Bool = false
    
    func done () {
        
        let lockStatus = lock.tryLock()
        if lockStatus {
            
            if !isDone {    // prevent multiple done calls doing harm
                isDone = true
                currentWt.onClosureDone()
            }
            
            lock.unlock()
        }
        else {
            // the property is unecpectedly being accessed from another thread
            // do nothing, completion can be marked only once
        }
    }
    
}



class SWT {
    
    typealias SWTClosure = (swtCompletion: SWTCompletion) -> Void
    typealias SWTCompletionClosure = dispatch_block_t //(errors: [NSError]?) -> Void
    
    private var dispatchGroup : dispatch_group_t? = nil
    private var finalClosure : SWTCompletionClosure? = nil
    
    private var closures : [SWTClosure]? = nil
    private var errors : [NSError]? = nil
    
    
    private init () {
        
    }
    
    private func onClosureStart() {
        dispatch_group_enter(self.dispatchGroup!)
    }
    
    private func onClosureDone() {
        dispatch_group_leave(self.dispatchGroup!)
    }
    
    private func start() {
        
        dispatchGroup = dispatch_group_create()
        
        if let closures = closures {
            for closure in closures {
                let swtCompletion = SWTCompletion(currentWt: self)
                onClosureStart()
                closure(swtCompletion: swtCompletion)
            }
        }
        
        // callback to execute the final "then" closure
        dispatch_group_notify(dispatchGroup!, dispatch_get_main_queue()) {
            if let finalClosure = self.finalClosure {   // intentionally capture self
                finalClosure()
            }
        }
    }
    
    class func when(closures: SWTClosure...) -> SWT {
        
        let instance = SWT()
        instance.closures = closures
        return instance
    }
    
    func then(closure: SWTCompletionClosure) {
        finalClosure = closure
        
        // all setup, go!
        start()
    }
    
}


