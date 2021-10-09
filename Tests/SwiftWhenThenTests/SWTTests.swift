import XCTest
import SwiftWhenThen

class SwiftWhenThenHostTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func asyncTask(_ msg: String, completion: @escaping ()->()) {
        DispatchQueue.main.async {
            print("async task: \(msg)")
            completion()
        }
    }
    
    
    func testAsyncCompletion() {
        
        let swtExpectation = self.expectation(description: "SWT Excpectation")
        
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
        
        waitForExpectations(timeout: 3) { (error: Error?) -> Void in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    
    func testAllSyncCompletion() {
        
        let swtExpectation = self.expectation(description: "SWT Excpectation")
        
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
        
        waitForExpectations(timeout: 3) { (error: Error?) -> Void in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    
    func testSyncAsyncCompletion() {
        
        let swtExpectation = self.expectation(description: "SWT Excpectation")
        
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
        
        waitForExpectations(timeout: 3) { (error: Error?) -> Void in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    
    
    func testAsyncSyncAsyncCompletion() {
        
        let swtExpectation = self.expectation(description: "SWT Excpectation")
        
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
        
        waitForExpectations(timeout: 3) { (error: Error?) -> Void in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    
    func testAsyncSyncCompletion() {
        
        let swtExpectation = self.expectation(description: "SWT Excpectation")
        
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
        
        waitForExpectations(timeout: 3) { (error: Error?) -> Void in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    
    
}
