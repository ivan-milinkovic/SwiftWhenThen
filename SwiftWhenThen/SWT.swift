//
//  WT.swift
//  AfterPerformDemo
//
//  Created by Ivan Milinkovic on 11/26/15.
//
//

import Foundation


class SWTCompletion {
    fileprivate let currentWt : SWT
    fileprivate init(currentWt : SWT) {
        // keep the current instance in memory
        self.currentWt = currentWt
    }
    
    // note: can't use dispatch_once as it requires a token to be a global or a static varible
    // which does not fit this use case, because locking should be done on per instance level
    fileprivate var lock = NSLock()
    fileprivate var isDone: Bool = false
    
    func done () {
        
        let lockStatus = lock.try()
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
    
    typealias SWTClosure = (_ swtCompletion: SWTCompletion) -> Void
    typealias SWTCompletionClosure = ()->()
    
    fileprivate var dispatchGroup : DispatchGroup
    fileprivate var finalClosure : SWTCompletionClosure? = nil
    
    fileprivate var closures : [SWTClosure]? = nil
    
    fileprivate init () {
        dispatchGroup = DispatchGroup()
    }
    
    fileprivate func onClosureStart() {
        self.dispatchGroup.enter()
    }
    
    fileprivate func onClosureDone() {
        self.dispatchGroup.leave()
    }
    
    fileprivate func start() {
        
        dispatchGroup = DispatchGroup()
        
        if let closures = closures {
            for closure in closures {
                let swtCompletion = SWTCompletion(currentWt: self)
                onClosureStart()
                closure(swtCompletion)
            }
        }
        
        // callback to execute the final "then" closure
        dispatchGroup.notify(queue: DispatchQueue.main) {
            if let finalClosure = self.finalClosure {   // intentionally capture self
                finalClosure()
            }
        }
    }
    
    class func when(_ closures: SWTClosure...) -> SWT {
        
        let instance = SWT()
        instance.closures = closures
        return instance
    }
    
    func then(_ closure: @escaping SWTCompletionClosure) {
        finalClosure = closure
        
        // all setup, go!
        start()
    }
    
}


