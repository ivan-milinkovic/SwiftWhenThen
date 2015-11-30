# SwiftWhenThen

SwiftWhenThen is a simple library which helps join multiple asynchronous requests. It is a simple jQuery-like when-then logic, using GCD dispatch groups.
An example:

```swift
    func testSWT () {
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

```

## Installation

Just copy the SWT.swift file into your project.

:) 

---


