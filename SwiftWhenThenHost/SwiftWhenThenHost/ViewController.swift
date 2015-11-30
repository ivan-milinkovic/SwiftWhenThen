//
//  ViewController.swift
//  AfterPerformDemo
//
//  Created by Ivan Milinkovic on 8/11/15.
//
//

import UIKit

class ViewController: UIViewController {
    
    func test () {
        SWT.when(
            { swtCompletion in
                self.asyncTask("one", completion: {
                    swtCompletion.done()
                })
            },
            { swtCompletion in
                self.asyncTask("two", completion: {
                    swtCompletion.done()
                })
            },
            { swtCompletion in
                self.asyncTask("three", completion: {
                    swtCompletion.done()
                })
            },
            { swtCompletion in
                self.asyncTask("four", completion: {
                    swtCompletion.done()
                })
            }
            ).then {
                print("complete")
        }
    }
    
    func asyncTask(msg: String, completion: dispatch_block_t) {
        dispatch_async(dispatch_get_main_queue()) {
            print("async task: \(msg)")
            completion()
        }
    }
    
    @IBAction func btnAction(sender: AnyObject) {
        test()
    }
    
}


