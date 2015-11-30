//
//  SwiftWhenThenHostTests.swift
//  SwiftWhenThenHostTests
//
//  Created by Ivan Milinkovic on 11/30/15.
//
//

import XCTest
@testable import SwiftWhenThenHost

class SwiftWhenThenHostTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func asyncTask(msg: String, completion: dispatch_block_t) {
        dispatch_async(dispatch_get_main_queue()) {
            print("async task: \(msg)")
            completion()
        }
    }
    
    
    func testAsyncCompletion() {
        
        let swtExpectation = self.expectationWithDescription("SWT Excpectation")
        
        SWT.when(
            { swtCompletion in
                self.asyncTask("async1", completion: {
                    swtCompletion.done()
                })
            },
            { swtCompletion in
                self.asyncTask("async2", completion: {
                    swtCompletion.done()
                })
            },
            { swtCompletion in
                self.asyncTask("async3", completion: {
                    swtCompletion.done()
                })
            }
            ).then {
                swtExpectation.fulfill()
                print("complete")
        }
        
        waitForExpectationsWithTimeout(3) { (error: NSError?) -> Void in
            if let error = error {
                XCTFail(error.description)
            }
        }
        
    }
    
    
    func testAllSyncCompletion() {
        
        let swtExpectation = self.expectationWithDescription("SWT Excpectation")
        
        SWT.when(
            { swtCompletion in
                print("sync1")
                swtCompletion.done()
            },
            { swtCompletion in
                print("sync2")
                swtCompletion.done()
            },
            { swtCompletion in
                print("sync3")
                swtCompletion.done()
            }
            ).then {
                swtExpectation.fulfill()
                print("complete")
        }
        
        waitForExpectationsWithTimeout(3) { (error: NSError?) -> Void in
            if let error = error {
                XCTFail(error.description)
            }
        }
    }
    
    
    func testSyncAsyncCompletion() {
        
        let swtExpectation = self.expectationWithDescription("SWT Excpectation")
        
        SWT.when(
            { swtCompletion in
                swtCompletion.done()
            },
            { swtCompletion in
                self.asyncTask("async1", completion: {
                    swtCompletion.done()
                })
            },
            { swtCompletion in
                self.asyncTask("async2", completion: {
                    swtCompletion.done()
                })
            }
            ).then {
                swtExpectation.fulfill()
                print("complete")
        }
        
        waitForExpectationsWithTimeout(3) { (error: NSError?) -> Void in
            if let error = error {
                XCTFail(error.description)
            }
        }
    }
    
    
    
    func testAsyncSyncAsyncCompletion() {
        
        let swtExpectation = self.expectationWithDescription("SWT Excpectation")
        
        SWT.when(
            { swtCompletion in
                self.asyncTask("async1", completion: {
                    swtCompletion.done()
                })
            },
            { swtCompletion in
                print("sync1")
                swtCompletion.done()
            },
            { swtCompletion in
                self.asyncTask("async2", completion: {
                    swtCompletion.done()
                })
            }
            ).then {
                swtExpectation.fulfill()
                print("complete")
        }
        
        waitForExpectationsWithTimeout(3) { (error: NSError?) -> Void in
            if let error = error {
                XCTFail(error.description)
            }
        }
    }
    
    
    func testAsyncSyncCompletion() {
        
        let swtExpectation = self.expectationWithDescription("SWT Excpectation")
        
        SWT.when(
            { swtCompletion in
                self.asyncTask("async1", completion: {
                    swtCompletion.done()
                })
            },
            { swtCompletion in
                self.asyncTask("async2", completion: {
                    swtCompletion.done()
                })
            },
            { swtCompletion in
                print("sync1")
                swtCompletion.done()
            }
            ).then {
                swtExpectation.fulfill()
                print("complete")
        }
        
        waitForExpectationsWithTimeout(3) { (error: NSError?) -> Void in
            if let error = error {
                XCTFail(error.description)
            }
        }
    }
    
    
    
}
